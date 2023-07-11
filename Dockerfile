# For which architecture to build (amd64 or arm64)
ARG arch
# Eclipse image
ARG ECLIPSEIMAGE
# Isabelle image
ARG ISABELLEIMAGE

FROM ${ECLIPSEIMAGE} as eclipseimage

FROM ${ISABELLEIMAGE} as isabelleimage

FROM lscr.io/linuxserver/webtop:ubuntu-icewm

ENV HOME="/config"
ENV TZ=Europe/Paris
ARG DEBIAN_FRONTEND=noninteractive

RUN \
	apt-get update ; \
	apt-get upgrade -y ; \
	apt-get install -y nano ; \
	apt-get install -y featherpad ; \
	apt-get install -y rox-filer ; \
	apt-get install -y zip unzip

RUN \
  apt-get clean ; \
  rm -rf \
    /tmp/* \
    /config/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# Copy Eclipse installation from Eclipse image
COPY --from=eclipseimage /usr/local/eclipse /usr/local/eclipse

# Copy Isabelle installation from Isabelle image
COPY --from=isabelleimage /usr/local/Isabelle /usr/local/Isabelle

COPY mydocker_startup/wrapper_script.sh /usr/local/lib/wrapper_script.sh

COPY init-config/* /init-config/

RUN \
	cd /init-config ; \
	for script in *.sh ; \
	do \
		chmod +x $script ; \
		./$script ; \
		rm $script ; \
	done

ENTRYPOINT ["/bin/bash", "/usr/local/lib/wrapper_script.sh"]
