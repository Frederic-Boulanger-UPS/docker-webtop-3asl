cat - > /usr/share/applications/Isabelle.desktop << "==END=="
[Desktop Entry]
Version=1.0
Name=Isabelle
GenericName=Proof assistant
Exec=/usr/local/Isabelle/bin/isabelle jedit %F
StartupNotify=true
Terminal=false
Icon=/usr/local/Isabelle/lib/icons/isabelle.xpm
Type=Application
Categories=Proof;Development;Science;Math
MimeType=text/text;
==END==
