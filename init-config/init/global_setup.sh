desktop_background="desktop-background.png"

cat - >> /init-config/.bashrc << "==END=="
export OPAMROOT=/opt/opam
# Current opam switch man dir
MANPATH="$MANPATH":'/opt/opam/default/man'; export MANPATH;
# Binary dir for opam switch default
PATH="$PATH":'/opt/opam/default/bin'; export PATH;
==END==
chmod +x /init-config/.bashrc

mkdir -p /init-config/.config/xfce4/xfconf/xfce-perchannel-xml
sed -e "s/\${desktop_background}/${desktop_background}/" - \
	> /init-config/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml \
	<< "==END=="
<?xml version="1.1" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitorscreen" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/config/${desktop_background}"/>
        </property>
        <property name="workspace1" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/config/${desktop_background}"/>
        </property>
        <property name="workspace2" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/config/${desktop_background}"/>
        </property>
        <property name="workspace3" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/config/${desktop_background}"/>
        </property>
      </property>
      <property name="monitorselkies-primary" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="4"/>
          <property name="last-image" type="string" value="/config/${desktop_background}"/>
          <property name="rgba1" type="array">
            <value type="double" value="0.23921568627450981"/>
            <value type="double" value="0.2196078431372549"/>
            <value type="double" value="0.27450980392156865"/>
            <value type="double" value="1"/>
          </property>
        </property>
      </property>
    </property>
  </property>
  <property name="last" type="empty">
    <property name="window-width" type="int" value="596"/>
    <property name="window-height" type="int" value="541"/>
  </property>
  <property name="desktop-icons" type="empty">
    <property name="file-icons" type="empty">
      <property name="show-filesystem" type="bool" value="false"/>
    </property>
  </property>
  <property name="last-settings-migration-version" type="uint" value="1"/>
</channel>
==END==
