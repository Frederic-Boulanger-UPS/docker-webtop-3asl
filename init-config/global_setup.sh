mkdir -p /init-config/.icewm

cat - > /init-config/.bashrc << "==END=="
/usr/bin/icewmbg
==END==
chmod +x /init-config/.bashrc

cat - > /init-config/.icewm/preferences << "==END=="
ConfirmLogout=1
TimeFormat="%T"
TerminalCommand="uxterm"
LogoutCommand="sudo kill 1"
==END==

cat - > /init-config/.icewm/prefoverride << "==END=="
DesktopBackgroundCenter=1
DesktopBackgroundScaled=0
DesktopBackgroundImage=~/desktop-background.png
DesktopBackgroundColor=black
==END==

# If "menu" is not created empty, a default one is generated by icewm from the installed applications
cat - > /init-config/.icewm/menu << "==END=="
==END==

# prog "ROX Filer" system-file-manager /usr/bin/rox-filer
cat - > /init-config/.icewm/programs << "==END=="
prog "Firefox Web Browser" firefox firefox
prog "PCMan file manager" system-file-manager /usr/bin/pcmanfm
prog "Eclipse Modeling" /usr/local/eclipse/icon.xpm /usr/local/eclipse/eclipse
prog "Isabelle" /usr/local/IsabelleLatest/lib/icons/isabelle.xpm /usr/local/IsabelleLatest/bin/isabelle jedit
prog "Eclipse MicroC" /usr/local/eclipse_microc/microc.xpm /usr/local/eclipse_microc/eclipse
prog "Logisim" /usr/share/logisim/icon.xpm /usr/local/bin/logisim
prog "Coq IDE" coq.xpm coqide
prog "FeatherPad" featherpad featherpad
prog "UXTerm" mini.xterm uxterm
==END==

# prog "File browser (Rox)" /usr/share/rox/images/application.png /usr/bin/rox-filer
cat - > /init-config/.icewm/toolbar << "==END=="
prog "Terminal" mini.xterm /usr/bin/uxterm
prog "FeatherPad" featherpad featherpad
prog "Firefox" firefox /usr/bin/firefox
prog "File browser (PCMan)" /usr/share/icons/Humanity/apps/32/system-file-manager.svg /usr/bin/pcmanfm
prog "Eclipse Modeling" /usr/local/eclipse/icon.xpm /usr/local/eclipse/eclipse
prog "Isabelle" /usr/local/IsabelleLatest/lib/icons/isabelle.xpm /usr/local/IsabelleLatest/bin/isabelle jedit
prog "Eclipse MicroC" /usr/local/eclipse_microc/microc.xpm /usr/local/eclipse_microc/eclipse
prog "Logisim" /usr/share/logisim/icon.xpm /usr/local/bin/logisim
prog "Coq IDE" coq.xpm coqide
==END==

cat - > /init-config/.icewm/startup << "==END=="
/usr/bin/icewmbg
==END==

cat - > /init-config/.icewm/theme << "==END=="
Theme="motif/default.theme"
==END==

cat - >> /init-config/.bashrc << "==END=="
# Set base directory for XDG files
export XDG_RUNTIME_DIR='/config'
# Fix spurious Gtk error messages about accessibility bus
export NO_AT_BRIDGE=1
# Fix "MESA: error: ZINK: failed to choose pdev"
export LIBGL_ALWAYS_SOFTWARE=1

# Prefix of the current opam switch
OPAM_SWITCH_PREFIX='/opt/opam/default'; export OPAM_SWITCH_PREFIX;
# Updated by package ocaml
CAML_LD_LIBRARY_PATH='/usr/local/lib/ocaml/4.13.1/stublibs:/usr/lib/ocaml/stublibs'; export CAML_LD_LIBRARY_PATH;
# Updated by package ocaml
CAML_LD_LIBRARY_PATH='/opt/opam/default/lib/stublibs':"$CAML_LD_LIBRARY_PATH"; export CAML_LD_LIBRARY_PATH;
# Updated by package ocaml
OCAML_TOPLEVEL_PATH='/opt/opam/default/lib/toplevel'; export OCAML_TOPLEVEL_PATH;
# Current opam switch man dir
MANPATH="$MANPATH":'/opt/opam/default/man'; export MANPATH;
# Binary dir for opam switch default
PATH="$PATH":'/opt/opam/default/bin'; export PATH;
==END==
