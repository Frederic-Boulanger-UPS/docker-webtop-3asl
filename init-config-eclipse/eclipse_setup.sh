cat - > /usr/share/applications/Eclipse.desktop << "==END=="
[Desktop Entry]
Version=1.0
Name=Eclipse
GenericName=Integrated Development Environment
Exec=/usr/local/eclipse/eclipse %F
StartupNotify=true
Terminal=false
Icon=/usr/local/eclipse/icon.xpm
Type=Application
Categories=Development;IDE;
MimeType=text/text;
==END==
