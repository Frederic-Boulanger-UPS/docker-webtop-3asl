$version="2025-09"
$eclipse="eclipse-modeling-${version}-R-win32-x86_64.zip"
$client=new-object System.Net.WebClient

Write-Host "Downloading $eclipse ..."
$client.DownloadFile("https://mirror.ibcp.fr/pub/eclipse/technology/epp/downloads/release/${version}/R/${eclipse}", "${PWD}\${eclipse}")

Write-Host "Extracting eclipse to C:\eclipse ..."
Expand-Archive -Path "${PWD}\${eclipse}" -DestinationPath "C:\"

Remove-Item -Path "${PWD}\${eclipse}"

$env:Path += "; C:\eclipse"

Write-Host "Installing required plugins ..."
foreach ($feature in `
		"org.eclipse.acceleo.feature.group", `
		"org.eclipse.ocl.examples.feature.group", `
		"org.eclipse.m2m.qvt.oml.tools.coverage.feature.group", `
		"org.eclipse.m2m.qvt.oml.tools.coverage.source.feature.group", `
		"org.eclipse.m2m.qvt.oml.sdk.feature.group", `
		"org.eclipse.m2m.qvt.oml.sdk.source.feature.group", `
		"org.eclipse.xtext.sdk.feature.group", `
		"org.eclipse.cdt.feature.group", `
		"org.eclipse.linuxtools.cdt.libhover.feature.feature.group", `
		"org.eclipse.cdt.testsrunner.feature.feature.group", `
		"org.eclipse.wst.xml_ui.feature.feature.group", `
		"org.eclipse.wst.jsdt.feature.feature.group", `
		"org.eclipse.wildwebdeveloper.feature.feature.group", `
		"org.eclipse.xtend.sdk.feature.group", `
		"org.eclipse.wst.xsl.feature.feature.group") {
	Write-Host "    $feature"
	C:\eclipse\eclipse -nosplash `
				 -application org.eclipse.equinox.p2.director `
				 -repository https://download.eclipse.org/releases/$version/ `
				 -installIU $feature
	$proc=Get-Process eclipse
	Wait-Process -InputObject $proc
}
Write-Host "    fr.centralesupelec.infonum.sl.miniarm.feature.feature.group"
C:\eclipse\eclipse -nosplash `
			 -application org.eclipse.equinox.p2.director `
			 -repository https://wdi.centralesupelec.fr/boulanger/misc/mini-arm-update-site `
			 -installIU "fr.centralesupelec.infonum.sl.miniarm.feature.feature.group"
$proc=Get-Process eclipse
Wait-Process -InputObject $proc
Write-Host "Done."
