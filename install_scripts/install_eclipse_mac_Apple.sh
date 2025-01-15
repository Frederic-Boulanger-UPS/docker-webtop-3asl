eclipseversion="2024-12"
eclipsename="Eclipse-Modeling-${eclipseversion}"
platform="macosx-cocoa"
arch=$(uname -m)
if [ "$arch" = "arm64" -o "$arch" = "aarch64" ]
then
	# For Macs with Apple silicon (M1, M2)
	eclipsedmg="eclipse-modeling-${eclipseversion}-R-${platform}-aarch64.dmg"
else
	# For Macs with Intel silicon
	eclipsedmg="eclipse-modeling-${eclipseversion}-R-${platform}-x86_64.dmg"
fi
mirror="https://mirror.ibcp.fr/pub/eclipse/technology/epp/downloads/release/${eclipseversion}/R/"

echo "Downloading ${mirror}${eclipsedmg} ..."
curl --remote-name "${mirror}${eclipsedmg}"

echo "Moving eclipse to /Applications ..."
diskutil image attach "$eclipsedmg" || diskutil mount  "$eclipsedmg"
cp -r /Volumes/Eclipse/Eclipse.app /Applications/${eclipsename}.app
diskutil unmount /Volumes/Eclipse
rm "${eclipsedmg}"

eclipsebin="/Applications/${eclipsename}.app/Contents/MacOS/eclipse"

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
	${eclipsebin} \
			-nosplash \
			-application org.eclipse.equinox.p2.director \
			-repository https://download.eclipse.org/releases/${eclipseversion}/ \
			-installIU "${feature}" ; \
done

# Install MiniARM assembler plugin
echo "   fr.centralesupelec.infonum.sl.miniarm.feature.feature.group"
${eclipsebin} \
		-nosplash \
		-application org.eclipse.equinox.p2.director \
		-repository https://wdi.centralesupelec.fr/boulanger/misc/mini-arm-update-site \
		-installIU "fr.centralesupelec.infonum.sl.miniarm.feature.feature.group"
