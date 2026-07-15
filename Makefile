.PHONY: build manifest run debug push save clean clobber buildaltergo buildprovers
DOCKER=docker
# DOCKER=podman

# REPO    = gitlab-research.centralesupelec.fr:4567/boulange/mydocker-images/
REPO    = fredblgr/
NAME    = docker-webtop-3asl
TAG     = 2026
MAINTAG = 2026
# Can be overriden with "make ARCH=amd64" for instance
# ARCH   := $$(arch=$$(uname -m); if [ $$arch = "x86_64" ]; then echo amd64; elif [ $$arch = "aarch64" ]; then echo arm64; else echo $$arch; fi)
ARCH   := $(shell if [ `uname -m` = "x86_64" ]; then echo "amd64"; elif [ `uname -m` = "aarch64" ]; then echo "arm64"; else echo `uname -m`; fi)
ARCHS   = amd64 arm64
IMAGES := $(ARCHS:%=$(REPO)$(NAME):$(MAINTAG)-%)
PLATFORMS := $$(first="True"; for a in $(ARCHS); do if [[ $$first == "True" ]]; then printf "linux/%s" $$a; first="False"; else printf ",linux/%s" $$a; fi; done)
DOCKERFILE = Dockerfile
# DOCKERFILEBASE = Dockerfile_base
DOCKERFILEECLIPSE = Dockerfile_Eclipse
# DOCKERFILEMICROC = Dockerfile_MicroC
DOCKERFILEISABELLE = Dockerfile_Isabelle
# DOCKERFILESOUFFLE = Dockerfile_Souffle
DOCKERFILEFRAMAC = Dockerfile_Frama-C
DOCKERFILEATELIERB = Dockerfile_AtelierB
ARCHIMAGE := $(REPO)$(NAME):$(MAINTAG)-$(ARCH)
ARCHIMAGEBASE := $(REPO)docker-webtop-base:$(TAG)-$(ARCH)
ARCHIMAGEECLIPSE := $(REPO)docker-webtop-eclipse:$(TAG)-$(ARCH)
# ARCHIMAGEMICROC := $(REPO)docker-webtop-microc:$(TAG)-$(ARCH)
ARCHIMAGEISABELLE := $(REPO)docker-webtop-isabelle:$(TAG)-$(ARCH)
# ARCHIMAGESOUFFLE := $(REPO)docker-webtop-souffle:$(TAG)-$(ARCH)
ARCHIMAGEFRAMAC := $(REPO)docker-webtop-framac:$(TAG)-$(ARCH)
ARCHIMAGEATELIERB := $(REPO)docker-webtop-atelierb:$(TAG)-$(ARCH)

help:
	@echo "# Available targets:"
	@echo "#   - build: build docker image"
	@echo "#   - clean: clean docker build cache"
	@echo "#   - run: run docker container"
	@echo "#   - push: push docker image to docker hub"

# Build image
build:
	@echo "Building $(ARCHIMAGE) for $(ARCH) from $(DOCKERFILE)"
	@if [ `$(DOCKER) images $(ARCHIMAGEBASE) | wc -l` -lt 2 ] ; then \
		echo "*****************************************" ; \
		echo "* You should build the $(ARCHIMAGEBASE) first *" ; \
		echo "*****************************************" ; \
	fi
	@if [ `$(DOCKER) images $(ARCHIMAGEECLIPSE) | wc -l` -lt 2 ] ; then \
		echo "*****************************************" ; \
		echo "* You should 'make build_eclipse' first *" ; \
		echo "*****************************************" ; \
	fi
	@if [ `$(DOCKER) images $(ARCHIMAGEISABELLE) | wc -l` -lt 2 ] ; then \
		echo "******************************************" ; \
		echo "* You should 'make build_isabelle' first *" ; \
		echo "******************************************" ; \
	fi
	@if [ `$(DOCKER) images $(ARCHIMAGEFRAMAC) | wc -l` -lt 2 ] ; then \
		echo "******************************************" ; \
		echo "* You should 'make build_framac' first *" ; \
		echo "******************************************" ; \
	fi
	$(DOCKER) build --platform linux/$(ARCH) \
							 --build-arg arch=$(ARCH) \
							 --build-arg BASEIMAGE=$(ARCHIMAGEBASE) \
							 --build-arg ECLIPSEIMAGE=$(ARCHIMAGEECLIPSE) \
							 --build-arg MICROCIMAGE=$(ARCHIMAGEMICROC) \
							 --build-arg ISABELLEIMAGE=$(ARCHIMAGEISABELLE) \
							 --build-arg FRAMACIMAGE=$(ARCHIMAGEFRAMAC) \
							 --build-arg ATELIERBIMAGE=$(ARCHIMAGEATELIERB) \
							 --tag $(ARCHIMAGE) --file $(DOCKERFILE) .
	@danglingimages=$$($(DOCKER) images --filter "dangling=true" -q); \
	if [ "$$danglingimages" != "" ]; then \
	  $(DOCKER) rmi $$($(DOCKER) images --filter "dangling=true" -q); \
	fi

# # Build base image to experiment with installing new stuff
# build_base:
# 	@echo "Building $(ARCHIMAGEBASE) for $(ARCH) from $(DOCKERFILEBASE)"
# 	$(DOCKER) build --platform linux/$(ARCH) \
# 							 --build-arg arch=$(ARCH) \
# 							 --tag $(ARCHIMAGEBASE) \
# 							 --file $(DOCKERFILEBASE) .
# 	@danglingimages=$$($(DOCKER) images --filter "dangling=true" -q); \
# 	if [ "$$danglingimages" != "" ]; then \
# 	  $(DOCKER) rmi $$($(DOCKER) images --filter "dangling=true" -q); \
# 	fi

# Build Eclipse MicroC feature image
build_microc:
	@echo "Building $(ARCHIMAGEMICROC) for $(ARCH) from $(DOCKERFILEMICROC)"
	$(DOCKER) build --platform linux/$(ARCH) \
							 --build-arg arch=$(ARCH) \
							 --build-arg BASEIMAGE=$(ARCHIMAGEBASE) \
							 --tag $(ARCHIMAGEMICROC) \
							 --file $(DOCKERFILEMICROC) .
	@danglingimages=$$($(DOCKER) images --filter "dangling=true" -q); \
	if [ "$$danglingimages" != "" ]; then \
	  $(DOCKER) rmi $$($(DOCKER) images --filter "dangling=true" -q); \
	fi

# Build Eclipse image
build_eclipse:
	@echo "Building $(ARCHIMAGEECLIPSE) for $(ARCH) from $(DOCKERFILEECLIPSE)"
	$(DOCKER) build --platform linux/$(ARCH) \
							 --build-arg arch=$(ARCH) \
							 --build-arg BASEIMAGE=$(ARCHIMAGEBASE) \
							 --tag $(ARCHIMAGEECLIPSE) \
							 --file $(DOCKERFILEECLIPSE) .
	@danglingimages=$$($(DOCKER) images --filter "dangling=true" -q); \
	if [ "$$danglingimages" != "" ]; then \
	  $(DOCKER) rmi $$($(DOCKER) images --filter "dangling=true" -q); \
	fi

# Build Isabelle image
build_isabelle:
	@echo "Building $(ARCHIMAGEISABELLE) for $(ARCH) from $(DOCKERFILEISABELLE)"
	$(DOCKER) build --platform linux/$(ARCH) \
							 --build-arg arch=$(ARCH) \
							 --build-arg BASEIMAGE=$(ARCHIMAGEBASE) \
							 --tag $(ARCHIMAGEISABELLE) \
							 --file $(DOCKERFILEISABELLE) .
	@danglingimages=$$($(DOCKER) images --filter "dangling=true" -q); \
	if [ "$$danglingimages" != "" ]; then \
	  $(DOCKER) rmi $$($(DOCKER) images --filter "dangling=true" -q); \
	fi

# # Build Souffle image
# build_souffle:
# 	@echo "Building $(ARCHIMAGESOUFFLE) for $(ARCH) from $(DOCKERFILESOUFFLE)"
# 	$(DOCKER) build --platform linux/$(ARCH) \
# 							 --build-arg arch=$(ARCH) \
# 							 --build-arg BASEIMAGE=$(ARCHIMAGEBASE) \
# 							 --tag $(ARCHIMAGESOUFFLE) \
# 							 --file $(DOCKERFILESOUFFLE) .
# 	@danglingimages=$$($(DOCKER) images --filter "dangling=true" -q); \
# 	if [ "$$danglingimages" != "" ]; then \
# 	  $(DOCKER) rmi $$($(DOCKER) images --filter "dangling=true" -q); \
# 	fi

# Build Frama-C image
build_framac:
	@echo "Building $(ARCHIMAGEFRAMAC) for $(ARCH) from $(DOCKERFILEFRAMAC)"
	$(DOCKER) build --platform linux/$(ARCH) \
							 --build-arg arch=$(ARCH) \
							 --build-arg BASEIMAGE=$(ARCHIMAGEBASE) \
							 --build-arg ISABELLEIMAGE=$(ARCHIMAGEISABELLE) \
							 --tag $(ARCHIMAGEFRAMAC) \
							 --file $(DOCKERFILEFRAMAC) .
	@danglingimages=$$($(DOCKER) images --filter "dangling=true" -q); \
	if [ "$$danglingimages" != "" ]; then \
	  $(DOCKER) rmi $$($(DOCKER) images --filter "dangling=true" -q); \
	fi

# Build AtelierB image
build_atelierb:
	@echo "Building $(ARCHIMAGEATELIERB) for $(ARCH) from $(DOCKERFILEATELIERB)"
	$(DOCKER) build --platform linux/$(ARCH) \
							 --build-arg arch=$(ARCH) \
							 --build-arg BASEIMAGE=$(ARCHIMAGEBASE) \
							 --tag $(ARCHIMAGEATELIERB) \
							 --file $(DOCKERFILEATELIERB) .
	@danglingimages=$$($(DOCKER) images --filter "dangling=true" -q); \
	if [ "$$danglingimages" != "" ]; then \
	  $(DOCKER) rmi $$($(DOCKER) images --filter "dangling=true" -q); \
	fi

# login:
# 	$(DOCKER) login gitlab-research.centralesupelec.fr:4567

login:
	$(DOCKER) login --username fredblgr https://index.docker.io

# Safe way to build multiarchitecture images:
# - build each image on the matching hardware, with the -$(ARCH) tag
# - push the architecture specific images to Dockerhub
# - build a manifest list referencing those images
# - push the manifest list so that the multiarchitecture image exist
manifest:
	$(DOCKER) manifest create $(REPO)$(NAME):$(MAINTAG) $(IMAGES)
	@for arch in $(ARCHS); \
	 do \
	   echo $(DOCKER) manifest annotate --os linux --arch $$arch $(REPO)$(NAME):$(MAINTAG) $(REPO)$(NAME):$(MAINTAG)-$$arch; \
	   $(DOCKER) manifest annotate --os linux --arch $$arch $(REPO)$(NAME):$(MAINTAG) $(REPO)$(NAME):$(MAINTAG)-$$arch; \
	 done
	$(DOCKER) manifest push $(REPO)$(NAME):$(MAINTAG)

rmmanifest:
	$(DOCKER) manifest rm $(REPO)$(NAME):$(MAINTAG)


push:
	$(DOCKER) push $(ARCHIMAGE)

save:
	$(DOCKER) save $(ARCHIMAGE) | gzip > $(NAME)-$(MAINTAG)-$(ARCH).tar.gz

# Clear caches
clean:
	$(DOCKER) builder prune

clobber:
	$(DOCKER) rmi $(REPO)$(NAME):$(MAINTAG) $(ARCHIMAGE)
	$(DOCKER) rmi $(ARCHIMAGEECLIPSE)
	$(DOCKER) rmi $(ARCHIMAGEISABELLE)
# 	$(DOCKER) rmi $(DOCKERFILESOUFFLE)
	$(DOCKER) rmi $(ARCHIMAGEFRAMAC)
	$(DOCKER) builder prune --all

run:
	$(DOCKER) run --rm --detach \
	  --platform linux/$(ARCH) \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGE)
	sleep 10
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

#	  --cap-add SYS_ADMIN
run_base:
	$(DOCKER) run --rm --detach \
	  --platform linux/$(ARCH) \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGEBASE)
	sleep 10
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

run_microc:
	$(DOCKER) run --rm --detach \
	  --platform linux/$(ARCH) \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGEMICROC)
	sleep 10
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

run_eclipse:
	$(DOCKER) run --rm --detach \
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
	$(DOCKER) run \
	  --rm --detach \
	  --platform linux/$(ARCH) \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGEISABELLE)
	sleep 10
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

# run_souffle:
# 	$(DOCKER) run --rm --detach \
# 	  --platform linux/$(ARCH) \
# 		--env="PUID=`id -u`" --env="PGID=`id -g`" \
# 		--volume ${PWD}/config:/config:rw \
# 		--publish 3000:3000 \
# 		--publish 3001:3001 \
# 		--name $(NAME) \
# 		$(ARCHIMAGESOUFFLE)
# 	sleep 10
# 	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

run_framac:
	$(DOCKER) run --rm --detach \
	  --platform linux/$(ARCH) \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGEFRAMAC)
	sleep 10
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

run_atelierb:
	$(DOCKER) run --rm --detach \
	  --platform linux/$(ARCH) \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGEATELIERB)
	sleep 10
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

runpriv:
	$(DOCKER) run --rm --interactive --tty --privileged \
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
	$(DOCKER) run --rm --tty --interactive \
	  --platform linux/$(ARCH) \
		--volume ${PWD}/config:/config:rw \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		--entrypoint=bash \
		$(ARCHIMAGE)
