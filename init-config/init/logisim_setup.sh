cat - > /usr/local/bin/logisim << "==END=="
#!/bin/sh
java -jar /usr/share/logisim/logisim.jar "$@"
==END==
chmod +x /usr/local/bin/logisim

# mv LogisimApp.xpm /usr/share/logisim/icon.xpm
# 
# cat - > /usr/share/applications/Logisim.desktop << "==END=="
# [Desktop Entry]
# Version=1.0
# Name=Logisim
# GenericName=Logic circuit simulator
# Exec=/usr/local/bin/logisim %F
# StartupNotify=true
# Terminal=false
# Icon=/usr/share/logisim/icon.xpm
# Type=Application
# Categories=Education;Simulators;
# MimeType=text/text;
# ==END==
