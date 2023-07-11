.PHONY: build manifest run debug push save clean clobber buildaltergo buildprovers

REPO    = gitlab-research.centralesupelec.fr:4567/boulange/mydocker-images/
NAME    = docker-webtop-3asl
TAG     = 2023
# Can be overriden with "make ARCH=amd64" for instance
# ARCH   := $$(arch=$$(uname -m); if [ $$arch = "x86_64" ]; then echo amd64; elif [ $$arch = "aarch64" ]; then echo arm64; else echo $$arch; fi)
ARCH   := $(shell if [ `uname -m` = "x86_64" ]; then echo "amd64"; elif [ `uname -m` = "aarch64" ]; then echo "arm64"; else echo `uname -m`; fi)
ARCHS   = amd64 arm64
IMAGES := $(ARCHS:%=$(REPO)$(NAME):$(TAG)-%)
PLATFORMS := $$(first="True"; for a in $(ARCHS); do if [[ $$first == "True" ]]; then printf "linux/%s" $$a; first="False"; else printf ",linux/%s" $$a; fi; done)
DOCKERFILE = Dockerfile
DOCKERFILEECLIPSE = Dockerfile_Eclipse
DOCKERFILEISABELLE = Dockerfile_Isabelle
ARCHIMAGE := $(REPO)$(NAME):$(TAG)-$(ARCH)
ARCHIMAGEECLIPSE := $(REPO)docker-webtop-eclipse:$(TAG)-$(ARCH)
ARCHIMAGEISABELLE := $(REPO)docker-webtop-isabelle:$(TAG)-$(ARCH)

help:
	@echo "# Available targets:"
	@echo "#   - build: build docker image"
	@echo "#   - clean: clean docker build cache"
	@echo "#   - run: run docker container"
	@echo "#   - push: push docker image to docker hub"

# Build image
build:
	@echo "Building $(ARCHIMAGE) for $(ARCH) from $(DOCKERFILE)"
	@if [ `docker images $(ARCHIMAGEECLIPSE) | wc -l` -lt 2 ] ; then \
		echo "*****************************************" ; \
		echo "* You should 'make build_eclipse' first *" ; \
		echo "*****************************************" ; \
	fi
	@if [ `docker images $(ARCHIMAGEISABELLE) | wc -l` -lt 2 ] ; then \
		echo "******************************************" ; \
		echo "* You should 'make build_isabelle' first *" ; \
		echo "******************************************" ; \
	fi
	docker build --platform linux/$(ARCH) \
							 --build-arg arch=$(ARCH) \
							 --build-arg ECLIPSEIMAGE=$(ARCHIMAGEECLIPSE) \
							 --build-arg ISABELLEIMAGE=$(ARCHIMAGEISABELLE) \
							 --tag $(ARCHIMAGE) --file $(DOCKERFILE) .
	@danglingimages=$$(docker images --filter "dangling=true" -q); \
	if [[ $$danglingimages != "" ]]; then \
	  docker rmi $$(docker images --filter "dangling=true" -q); \
	fi

# Build Eclipse image
build_eclipse:
	@echo "Building $(ARCHIMAGEECLIPSE) for $(ARCH) from $(DOCKERFILEECLIPSE)"
	docker build --pull --platform linux/$(ARCH) \
											--build-arg arch=$(ARCH) \
											--tag $(ARCHIMAGEECLIPSE) \
											--file $(DOCKERFILEECLIPSE) .
	@danglingimages=$$(docker images --filter "dangling=true" -q); \
	if [[ $$danglingimages != "" ]]; then \
	  docker rmi $$(docker images --filter "dangling=true" -q); \
	fi

# Build Isabelle image
build_isabelle:
	@echo "Building $(ARCHIMAGEISABELLE) for $(ARCH) from $(DOCKERFILEISABELLE)"
	docker build --pull --platform linux/$(ARCH) \
											--build-arg arch=$(ARCH) \
											--tag $(ARCHIMAGEISABELLE) \
											--file $(DOCKERFILEISABELLE) .
	@danglingimages=$$(docker images --filter "dangling=true" -q); \
	if [[ $$danglingimages != "" ]]; then \
	  docker rmi $$(docker images --filter "dangling=true" -q); \
	fi

login:
	docker login gitlab-research.centralesupelec.fr:4567

# Safe way to build multiarchitecture images:
# - build each image on the matching hardware, with the -$(ARCH) tag
# - push the architecture specific images to Dockerhub
# - build a manifest list referencing those images
# - push the manifest list so that the multiarchitecture image exist
manifest:
	docker manifest create $(REPO)$(NAME):$(TAG) $(IMAGES)
	@for arch in $(ARCHS); \
	 do \
	   echo docker manifest annotate --os linux --arch $$arch $(REPO)$(NAME):$(TAG) $(REPO)$(NAME):$(TAG)-$$arch; \
	   docker manifest annotate --os linux --arch $$arch $(REPO)$(NAME):$(TAG) $(REPO)$(NAME):$(TAG)-$$arch; \
	 done
	docker manifest push $(REPO)$(NAME):$(TAG)

rmmanifest:
	docker manifest rm $(REPO)$(NAME):$(TAG)


push:
	docker push $(ARCHIMAGE)

save:
	docker save $(ARCHIMAGE) | gzip > $(NAME)-$(TAG)-$(ARCH).tar.gz

# Clear caches
clean:
	docker builder prune

clobber:
	docker rmi $(REPO)$(NAME):$(TAG) $(ARCHIMAGE)
	docker rmi $(REPO)$(NAMEX):$(TAG) $(ARCHIMAGEX)
	docker builder prune --all

run:
	docker run --rm --detach \
	  --platform linux/$(ARCH) \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGE)
	sleep 5
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

run_eclipse:
	docker run --rm --detach \
	  --platform linux/$(ARCH) \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGEECLIPSE)
	sleep 5
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

run_isabelle:
	docker run --rm --detach \
	  --platform linux/$(ARCH) \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGEISABELLE)
	sleep 5
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

runpriv:
	docker run --rm --interactive --tty --privileged \
	  --platform linux/$(ARCH) \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGE)
	sleep 5
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

debug:
	docker run --rm --tty --interactive \
	  --platform linux/$(ARCH) \
		--volume ${PWD}/config:/config:rw \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		--entrypoint=bash \
		$(ARCHIMAGE)
