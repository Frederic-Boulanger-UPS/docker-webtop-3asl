# For which architecture to build (amd64 or arm64)
ARG arch
# Eclipse image
ARG ECLIPSEIMAGE
# Isabelle image
ARG ISABELLEIMAGE
# Souffle image
ARG SOUFFLEIMAGE

FROM ${ECLIPSEIMAGE} as eclipseimage

FROM ${ISABELLEIMAGE} as isabelleimage

FROM ${SOUFFLEIMAGE} as souffleimage

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
	apt-get install -y \
		g++ \
		git \
		libncurses-dev \
		zlib1g-dev \
		libsqlite3-dev \
		sqlite

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

# Copy Soufflé installation from Soufflé image
COPY --from=souffleimage /usr/local/include/souffle /usr/local/include/souffle
COPY --from=souffleimage /usr/local/bin/souffle /usr/local/bin/souffle
COPY --from=souffleimage /usr/local/bin/souffleprof /usr/local/bin/souffleprof
COPY --from=souffleimage /usr/local/bin/souffle-compile.py /usr/local/bin/souffle-compile.py

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
