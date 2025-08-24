# Base webtop image
ARG BASEIMAGE
# # Eclipse MicroCimage
# ARG MICROCIMAGE
# Eclipse image
ARG ECLIPSEIMAGE
# Isabelle image
ARG ISABELLEIMAGE
# Frama-C image
ARG FRAMACIMAGE

# For which architecture to build (amd64 or arm64)
ARG arch

# FROM ${MICROCIMAGE} AS microcimage

FROM ${ECLIPSEIMAGE} AS eclipseimage

FROM ${ISABELLEIMAGE} AS isabelleimage

FROM ${FRAMACIMAGE} AS framacimage

FROM ${BASEIMAGE}

ENV HOME="/config"
ENV TZ=Europe/Paris
ARG DEBIAN_FRONTEND=noninteractive

RUN \
	apt-get update ; \
	apt-get upgrade -y ;

RUN \
	apt-get install -y \
		at-spi2-core \
		mesa-utils \
		libgl1-mesa-dri

# Install dependencies for coq and why3
RUN \
	apt-get install -y \
		make \
		ocaml \
		menhir \
		libnum-ocaml-dev \
		libmenhir-ocaml-dev \
		libzarith-ocaml-dev \
		libzip-ocaml-dev \
		liblablgtk3-ocaml-dev \
		liblablgtksourceview3-ocaml-dev \
		libocamlgraph-ocaml-dev \
		libre-ocaml-dev \
		libjs-of-ocaml-dev \
		yaru-theme-icon \
		adwaita-icon-theme-full \
		coqide

# Install dependencies for frama-c
RUN \
	apt-get install -y \
		graphviz \
		python3-pip \
		python3-all-venv


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

# # Copy Eclipse MicroC installation from MicroC image
# COPY --from=microcimage /usr/local/eclipse_microc /usr/local/eclipse_microc
# RUN ln -s /usr/local/eclipse_microc/eclipse /usr/local/bin/eclipse-microc

# Copy Eclipse installation from Eclipse image
COPY --from=eclipseimage /usr/local/eclipse /usr/local/eclipse
RUN ln -s /usr/local/eclipse/eclipse /usr/local/bin/eclipse

# Copy Isabelle installation from Isabelle image
COPY --from=isabelleimage /usr/local/Isabelle /usr/local/Isabelle
RUN ln -s /usr/local/Isabelle/bin/isabelle /usr/local/bin/isabelle
COPY --from=isabelleimage /usr/local/IsabelleLatest /usr/local/IsabelleLatest
RUN ln -s /usr/local/IsabelleLatest/bin/isabelle /usr/local/bin/isabelle-latest

COPY --from=isabelleimage /usr/local/bin/why3 /usr/local/bin/why3
COPY --from=isabelleimage /usr/local/lib/why3 /usr/local/lib/why3
COPY --from=isabelleimage /usr/local/share/why3 /usr/local/share/why3

# !!!!! Copy Z3, cvc4 and cvc5
COPY --from=isabelleimage /usr/bin/z3 /usr/bin/z3
COPY --from=isabelleimage /usr/bin/cvc4 /usr/bin/cvc4
COPY --from=isabelleimage /usr/lib/*/libcvc4* /usr/lib/
COPY --from=isabelleimage /usr/lib/*/libcln* /usr/lib/
COPY --from=isabelleimage /usr/lib/*/libantlr3c* /usr/lib/
COPY --from=isabelleimage /usr/local/bin/cvc5 /usr/local/bin/cvc5
COPY --from=isabelleimage /usr/local/lib/libcvc5* /usr/local/lib/
COPY --from=isabelleimage /usr/local/lib/libpoly* /usr/local/lib/

# Copy Frama-C installation from Frama-C image
COPY --from=framacimage /opt/opam /opt/opam

RUN mkdir -p /init-config/init

COPY init-config/init/* /init-config/init/
COPY init-config-eclipse/init/eclipse_setup.sh /init-config/init/
# COPY init-config-eclipse-microc/init/* /init-config/init/
COPY init-config-frama-c/init/global_setup.sh /init-config/init/
COPY init-config-isabelle/init/isabelle_setup.sh /init-config/init/

RUN \
	cd /init-config/init ; \
	for script in *.sh ; \
	do \
		chmod +x $script ; \
		./$script ; \
	done ; \
	cd .. ; rm -r init

# Clean up
RUN apt-get autoremove && apt-get autoclean && apt-get clean ; \
		rm -rf \
    /tmp/* \
    /config/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

ENTRYPOINT ["/bin/bash", "/usr/local/lib/wrapper_script.sh"]
