cat - >> /init-config/.bashrc << "==END=="
# Binary dir for AtelierB
PATH="$PATH":'/opt/atelierb-cssp-24.04/bin'; export PATH;
==END==
chmod +x /init-config/.bashrc
