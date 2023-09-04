.PHONY: build manifest run debug push save clean clobber buildaltergo buildprovers

# REPO    = gitlab-research.centralesupelec.fr:4567/boulange/mydocker-images/
REPO    = fredblgr/
NAME    = docker-webtop-3asl
TAG     = 2023
MAINTAG = 2023a
# Can be overriden with "make ARCH=amd64" for instance
# ARCH   := $$(arch=$$(uname -m); if [ $$arch = "x86_64" ]; then echo amd64; elif [ $$arch = "aarch64" ]; then echo arm64; else echo $$arch; fi)
ARCH   := $(shell if [ `uname -m` = "x86_64" ]; then echo "amd64"; elif [ `uname -m` = "aarch64" ]; then echo "arm64"; else echo `uname -m`; fi)
ARCHS   = amd64 arm64
IMAGES := $(ARCHS:%=$(REPO)$(NAME):$(MAINTAG)-%)
PLATFORMS := $$(first="True"; for a in $(ARCHS); do if [[ $$first == "True" ]]; then printf "linux/%s" $$a; first="False"; else printf ",linux/%s" $$a; fi; done)
DOCKERFILE = Dockerfile
DOCKERFILEECLIPSE = Dockerfile_Eclipse
DOCKERFILEISABELLE = Dockerfile_Isabelle
DOCKERFILESOUFFLE = Dockerfile_Souffle
DOCKERFILEFRAMAC = Dockerfile_Frama-C
ARCHIMAGE := $(REPO)$(NAME):$(MAINTAG)-$(ARCH)
ARCHIMAGEECLIPSE := $(REPO)docker-webtop-eclipse:$(TAG)-$(ARCH)
ARCHIMAGEISABELLE := $(REPO)docker-webtop-isabelle:$(TAG)-$(ARCH)
ARCHIMAGESOUFFLE := $(REPO)docker-webtop-souffle:$(TAG)-$(ARCH)
ARCHIMAGEFRAMAC := $(REPO)docker-webtop-framac:$(TAG)-$(ARCH)

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
	@if [ `docker images $(ARCHIMAGESOUFFLE) | wc -l` -lt 2 ] ; then \
		echo "******************************************" ; \
		echo "* You should 'make build_souffle' first *" ; \
		echo "******************************************" ; \
	fi
	@if [ `docker images $(ARCHIMAGEFRAMAC) | wc -l` -lt 2 ] ; then \
		echo "******************************************" ; \
		echo "* You should 'make build_framac' first *" ; \
		echo "******************************************" ; \
	fi
	docker build --platform linux/$(ARCH) \
							 --build-arg arch=$(ARCH) \
							 --build-arg ECLIPSEIMAGE=$(ARCHIMAGEECLIPSE) \
							 --build-arg ISABELLEIMAGE=$(ARCHIMAGEISABELLE) \
							 --build-arg SOUFFLEIMAGE=$(ARCHIMAGESOUFFLE) \
							 --build-arg FRAMACIMAGE=$(ARCHIMAGEFRAMAC) \
							 --tag $(ARCHIMAGE) --file $(DOCKERFILE) .
	@danglingimages=$$(docker images --filter "dangling=true" -q); \
	if [[ $$danglingimages != "" ]]; then \
	  docker rmi $$(docker images --filter "dangling=true" -q); \
	fi

# Build Eclipse image
build_eclipse:
	@echo "Building $(ARCHIMAGEECLIPSE) for $(ARCH) from $(DOCKERFILEECLIPSE)"
	docker build --platform linux/$(ARCH) \
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
	docker build --platform linux/$(ARCH) \
							 --build-arg arch=$(ARCH) \
							 --tag $(ARCHIMAGEISABELLE) \
							 --file $(DOCKERFILEISABELLE) .
	@danglingimages=$$(docker images --filter "dangling=true" -q); \
	if [[ $$danglingimages != "" ]]; then \
	  docker rmi $$(docker images --filter "dangling=true" -q); \
	fi

# Build Souffle image
build_souffle:
	@echo "Building $(ARCHIMAGESOUFFLE) for $(ARCH) from $(DOCKERFILESOUFFLE)"
	docker build --platform linux/$(ARCH) \
							 --build-arg arch=$(ARCH) \
							 --tag $(ARCHIMAGESOUFFLE) \
							 --file $(DOCKERFILESOUFFLE) .
	@danglingimages=$$(docker images --filter "dangling=true" -q); \
	if [[ $$danglingimages != "" ]]; then \
	  docker rmi $$(docker images --filter "dangling=true" -q); \
	fi

# Build Frama-C image
build_framac:
	@echo "Building $(ARCHIMAGEFRAMAC) for $(ARCH) from $(DOCKERFILEFRAMAC)"
	docker build --platform linux/$(ARCH) \
							 --build-arg arch=$(ARCH) \
							 --build-arg ISABELLEIMAGE=$(ARCHIMAGEISABELLE) \
							 --tag $(ARCHIMAGEFRAMAC) \
							 --file $(DOCKERFILEFRAMAC) .
	@danglingimages=$$(docker images --filter "dangling=true" -q); \
	if [[ $$danglingimages != "" ]]; then \
	  docker rmi $$(docker images --filter "dangling=true" -q); \
	fi

# login:
# 	docker login gitlab-research.centralesupelec.fr:4567

login:
	docker login --username fredblgr https://index.docker.io

# Safe way to build multiarchitecture images:
# - build each image on the matching hardware, with the -$(ARCH) tag
# - push the architecture specific images to Dockerhub
# - build a manifest list referencing those images
# - push the manifest list so that the multiarchitecture image exist
manifest:
	docker manifest create $(REPO)$(NAME):$(MAINTAG) $(IMAGES)
	@for arch in $(ARCHS); \
	 do \
	   echo docker manifest annotate --os linux --arch $$arch $(REPO)$(NAME):$(MAINTAG) $(REPO)$(NAME):$(MAINTAG)-$$arch; \
	   docker manifest annotate --os linux --arch $$arch $(REPO)$(NAME):$(MAINTAG) $(REPO)$(NAME):$(MAINTAG)-$$arch; \
	 done
	docker manifest push $(REPO)$(NAME):$(MAINTAG)

rmmanifest:
	docker manifest rm $(REPO)$(NAME):$(MAINTAG)


push:
	docker push $(ARCHIMAGE)

save:
	docker save $(ARCHIMAGE) | gzip > $(NAME)-$(MAINTAG)-$(ARCH).tar.gz

# Clear caches
clean:
	docker builder prune

clobber:
	docker rmi $(REPO)$(NAME):$(MAINTAG) $(ARCHIMAGE)
	docker rmi $(ARCHIMAGEECLIPSE)
	docker rmi $(ARCHIMAGEISABELLE)
	docker rmi $(DOCKERFILESOUFFLE)
	docker rmi $(ARCHIMAGEFRAMAC)
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
	sleep 10
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
	sleep 10
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
	sleep 10
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

run_souffle:
	docker run --rm --detach \
	  --platform linux/$(ARCH) \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGESOUFFLE)
	sleep 10
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

run_framac:
	docker run --rm --detach \
	  --platform linux/$(ARCH) \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGEFRAMAC)
	sleep 10
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
	sleep 10
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
