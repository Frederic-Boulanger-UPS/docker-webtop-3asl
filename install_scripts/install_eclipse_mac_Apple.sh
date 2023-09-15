eclipseversion="2023-09"
eclipsename="Eclipse-Modeling-${eclipseversion}"
# For Macs with Apple silicon (M1, M2)
eclipsedmg="eclipse-modeling-${eclipseversion}-R-macosx-cocoa-aarch64.dmg"
# For Macs with Intel silicon
# eclipsedmg="eclipse-modeling-${eclipseversion}-R-macosx-cocoa-x86_64.dmg"
mirror="https://laotzu.ftp.acc.umu.se/mirror/eclipse.org/technology/epp/downloads/release/${eclipseversion}/R/"

echo "Downloading ${eclipsetgz} ..."
curl --remote-name "${mirror}${eclipsedmg}"

echo "Moving eclipse to /Applications ..."
diskutil image attach "$eclipsedmg"
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
			-repository https://download.eclipse.org/releases/2023-06/ \
			-installIU "${feature}" ; \
done

# Install MiniARM assembler plugin
echo "   fr.centralesupelec.infonum.sl.miniarm.feature.feature.group"
${eclipsebin} \
		-nosplash \
		-application org.eclipse.equinox.p2.director \
		-repository https://wdi.centralesupelec.fr/boulanger/misc/mini-arm-update-site \
		-installIU "fr.centralesupelec.infonum.sl.miniarm.feature.feature.group"
