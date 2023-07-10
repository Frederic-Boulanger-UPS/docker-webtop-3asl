FROM lscr.io/linuxserver/webtop:ubuntu-icewm

# For which architecture to build (amd64 or arm64)
ARG arch

ENV HOME="/config"
ENV TZ=Europe/Paris
ARG DEBIAN_FRONTEND=noninteractive

RUN  \
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

# Install Eclipse and the required features/plugins
RUN \
	case ${arch} in \
		arm64) eclipsetgz=eclipse-modeling-2023-06-R-linux-gtk-aarch64.tar.gz ;; \
		amd64) eclipsetgz=eclipse-modeling-2023-06-R-linux-gtk-x86_64.tar.gz ;; \
		*) echo "Unsupported architecture ${arch}" ;; \
	esac ; \
	curl --remote-name "https://rhlx01.hs-esslingen.de/pub/Mirrors/eclipse/technology/epp/downloads/release/2023-06/R/${eclipsetgz}" ; \
	tar zxf ${eclipsetgz} && rm ${eclipsetgz} ; \
	mv eclipse /usr/local/eclipse ; \
	for feature in \
		"org.eclipse.acceleo.feature.group" \
		"org.eclipse.ocl.examples.feature.group" \
		"org.eclipse.m2m.qvt.oml.tools.coverage.feature.group" \
		"org.eclipse.m2m.qvt.oml.tools.coverage.source.feature.group" \
		"org.eclipse.m2m.qvt.oml.sdk.feature.group" \
		"org.eclipse.m2m.qvt.oml.sdk.source.feature.group" \
		"org.eclipse.xtext.sdk.feature.group" \
		"org.eclipse.cdt.feature.group" \
		"org.eclipse.linuxtools.cdt.libhover.feature.feature.group" \
		"org.eclipse.cdt.testsrunner.feature.feature.group" \
		"org.eclipse.wst.xml_ui.feature.feature.group" \
		"org.eclipse.wst.jsdt.feature.feature.group" \
		"org.eclipse.wildwebdeveloper.feature.feature.group" \
		"org.eclipse.xtend.sdk.feature.group" \
		"org.eclipse.wst.xsl.feature.feature.group" ; \
	do /usr/local/eclipse/eclipse -nosplash \
			-application org.eclipse.equinox.p2.director \
			-repository https://download.eclipse.org/releases/2023-06/ \
			-installIU "${feature}" ; \
	done


# Install Isabelle
RUN \
	case ${arch} in \
		arm64) isabelletgz=Isabelle2022_linux_arm.tar.gz ;; \
		amd64) isabelletgz=Isabelle2022_linux.tar.gz ;; \
		*) echo "Unsupported architecture ${arch}" ;; \
	esac ; \
	curl --remote-name "https://isabelle.in.tum.de/dist/${isabelletgz}" ; \
	tar zxf ${isabelletgz} && rm ${isabelletgz} ; \
	mv Isabelle2022 /usr/local/Isabelle

RUN mkdir /init-config && \
		echo "/usr/bin/icewmbg" >> /init-config/.bashrc && \
		chmod +x /init-config/.bashrc

COPY mydocker_startup/wrapper_script.sh /usr/local/lib/wrapper_script.sh
COPY init-config/icewm/startup /init-config/.icewm/startup
COPY init-config/icewm/preferences /init-config/.icewm/preferences
COPY init-config/icewm/menu /init-config/.icewm/menu
COPY init-config/icewm/programs /init-config/.icewm/programs
COPY init-config/icewm/toolbar /init-config/.icewm/toolbar
COPY init-config/icewm/theme /init-config/.icewm/theme
COPY init-config/icewm/prefoverride /init-config/.icewm/prefoverride
COPY init-config/desktop-background.png /init-config/desktop-background.png
COPY root/usr/share/applications/Eclipse.desktop /usr/share/applications/Eclipse.desktop
COPY root/usr/share/applications/Isabelle.desktop /usr/share/applications/Isabelle.desktop

ENTRYPOINT ["/bin/bash", "/usr/local/lib/wrapper_script.sh"]
