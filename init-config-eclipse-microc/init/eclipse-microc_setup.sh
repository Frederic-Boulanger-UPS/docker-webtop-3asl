cp microc.xpm /usr/local/eclipse_microc/

cat - > /usr/share/applications/EclipseMicroC.desktop << "==END=="
[Desktop Entry]
Version=1.0
Name=EclipseMicroC
GenericName=Integrated Development Environment
Exec=/usr/local/eclipse_microc/eclipse %F
StartupNotify=true
Terminal=false
Icon=/usr/local/eclipse_microc/microc.xpm
Type=Application
Categories=Development;IDE;
MimeType=text/text;
==END==
