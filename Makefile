.PHONY: build manifest run debug push save clean clobber buildaltergo buildprovers

REPO    = gitlab-research.centralesupelec.fr:4567/boulange/mydocker-images/
NAME    = docker-webtop-3asl
TAG     = 2023
ARCH   := $$(arch=$$(uname -m); if [ $$arch = "x86_64" ]; then echo amd64; elif [ $$arch = "aarch64" ]; then echo arm64; else echo $$arch; fi)
#RESOL   = 1440x900
ARCHS   = amd64 arm64
IMAGES := $(ARCHS:%=$(REPO)$(NAME):$(TAG)-%)
PLATFORMS := $$(first="True"; for a in $(ARCHS); do if [[ $$first == "True" ]]; then printf "linux/%s" $$a; first="False"; else printf ",linux/%s" $$a; fi; done)
DOCKERFILE = Dockerfile
ARCHIMAGE := $(REPO)$(NAME):$(TAG)-$(ARCH)

help:
	@echo "# Available targets:"
	@echo "#   - build: build docker image"
	@echo "#   - clean: clean docker build cache"
	@echo "#   - run: run docker container"
	@echo "#   - push: push docker image to docker hub"

# Build image
build:
	@echo "Building $(ARCHIMAGE) for $(ARCH) from $(DOCKERFILE)"
	docker build --pull --build-arg arch=$(ARCH) --tag $(ARCHIMAGE) --file $(DOCKERFILE) .
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
