# For which architecture to build (amd64 or arm64)
ARG arch
# Eclipse MicroCimage
ARG MICROCIMAGE
# Eclipse image
ARG ECLIPSEIMAGE
# Isabelle image
ARG ISABELLEIMAGE
# Souffle image
ARG SOUFFLEIMAGE
# Frama-C image
ARG FRAMACIMAGE

FROM ${MICROCIMAGE} AS microcimage

FROM ${ECLIPSEIMAGE} AS eclipseimage

FROM ${ISABELLEIMAGE} AS isabelleimage

FROM ${SOUFFLEIMAGE} AS souffleimage

FROM ${FRAMACIMAGE} AS framacimage

FROM lscr.io/linuxserver/webtop:ubuntu-icewm

ENV HOME="/config"
ENV TZ=Europe/Paris
ARG DEBIAN_FRONTEND=noninteractive

RUN \
	apt-get update ; \
	apt-get upgrade -y ; \
	apt-get install -y \
		nano \
		featherpad \
		pcmanfm \
		zip unzip

RUN \
	apt-get install -y \
		make \
		g++ \
		git \
		libncurses-dev \
		zlib1g-dev \
		libsqlite3-dev \
		sqlite3

RUN \
	apt-get install -y \
		yaru-theme-icon \
		adwaita-icon-theme-full \
		at-spi2-core

# Install dependencies for coq and why3
RUN \
	apt-get install -y \
	make ocaml menhir libnum-ocaml-dev libmenhir-ocaml-dev libzarith-ocaml-dev \
	libzip-ocaml-dev liblablgtk3-ocaml-dev liblablgtksourceview3-ocaml-dev \
	libocamlgraph-ocaml-dev libre-ocaml-dev libjs-of-ocaml-dev z3 cvc4 cvc5 \
	yaru-theme-icon \
	adwaita-icon-theme-full \
	coqide

# Install dependencies for frama-c
RUN \
	apt-get install -y \
		graphviz

# Install dependencies for Eclipse
RUN \
	apt-get install -y \
		libwebkit2gtk-4.1-0

# Install Logisim
RUN \
	apt-get install -y logisim \
	&& rm /usr/bin/logisim

RUN \
	apt-get autoremove ; \
	apt-get autoclean ; \
	apt-get clean ; \
	rm -rf \
    /tmp/* \
    /config/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# Copy Eclipse MicroC installation from MicroC image
COPY --from=microcimage /usr/local/eclipse_microc /usr/local/eclipse_microc
RUN ln -s /usr/local/eclipse_microc/eclipse /usr/local/bin/eclipse-microc

# Copy Eclipse installation from Eclipse image
COPY --from=eclipseimage /usr/local/eclipse /usr/local/eclipse
RUN ln -s /usr/local/eclipse/eclipse /usr/local/bin/eclipse

# Copy Isabelle installation from Isabelle image
COPY --from=isabelleimage /usr/local/Isabelle /usr/local/Isabelle
RUN ln -s /usr/local/Isabelle/bin/isabelle /usr/local/bin/isabelle

COPY --from=isabelleimage /usr/local/bin/why3 /usr/local/bin/why3
COPY --from=isabelleimage /usr/local/lib/why3 /usr/local/lib/why3
COPY --from=isabelleimage /usr/local/share/why3 /usr/local/share/why3


# Copy Soufflé installation from Soufflé image
COPY --from=souffleimage /usr/local/include/souffle /usr/local/include/souffle
COPY --from=souffleimage /usr/local/bin/souffle /usr/local/bin/souffle
COPY --from=souffleimage /usr/local/bin/souffleprof /usr/local/bin/souffleprof
COPY --from=souffleimage /usr/local/bin/souffle-compile.py /usr/local/bin/souffle-compile.py

# Copy Frama-C installation from Frama-C image
COPY --from=framacimage /opt/opam /opt/opam


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

# Clean up
RUN apt-get autoremove && apt-get autoclean && apt-get clean ; \
		rm -rf \
    /tmp/* \
    /config/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

ENTRYPOINT ["/bin/bash", "/usr/local/lib/wrapper_script.sh"]
