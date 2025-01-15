release="2024-12"
arch=$(uname -m)
if [ "$arch" = "arm64" -o "$arch" = "aarch64" ]
then
  # For computers with ARM chips
  eclipsetgz="eclipse-modeling-${release}-R-linux-gtk-aarch64.tar.gz"
else
  # For computers with Intel chips
  eclipsetgz="eclipse-modeling-${release}-R-linux-gtk-x86_64.tar.gz"
fi
mirror="https://mirror.ibcp.fr/pub/eclipse/technology/epp/downloads/release/${release}/R/"

echo "Downloading ${eclipsetgz} ..."
wget "${mirror}${eclipsetgz}" ; \

echo "Moving eclipse to /usr/local/ ..."
tar zxf ${eclipsetgz} && rm ${eclipsetgz} ; \
mv eclipse /usr/local/eclipse ; \

echo "Installing required plugins ..."
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
do
	echo "   ${feature}"
	/usr/local/eclipse/eclipse -nosplash \
				   -application org.eclipse.equinox.p2.director \
				   -repository https://download.eclipse.org/releases/${release}/ \
				   -installIU "${feature}" ; \
done

# Install MiniARM assembler plugin
echo "   fr.centralesupelec.infonum.sl.miniarm.feature.feature.group"
/usr/local/eclipse/eclipse -nosplash \
			   -application org.eclipse.equinox.p2.director \
			   -repository https://wdi.centralesupelec.fr/boulanger/misc/mini-arm-update-site \
			   -installIU "fr.centralesupelec.infonum.sl.miniarm.feature.feature.group"

(
printf "[Desktop Entry]\n"
printf "Version=1.0\n"
printf "Name=Eclipse\n"
printf "GenericName=Integrated Development Environment\n"
printf "Exec=/usr/local/eclipse/eclipse %%F\n"
printf "StartupNotify=true\n"
printf "Terminal=false\n"
printf "Icon=/usr/local/eclipse/icon.xpm\n"
printf "Type=Application\n"
printf "Categories=Development;IDE;\n"
printf "MimeType=text/text;\n"
) > /usr/share/applications/Eclipse.desktop

echo "Done."

