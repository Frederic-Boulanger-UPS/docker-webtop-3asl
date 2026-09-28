#!/bin/bash

# A command given as an absolute path is run instead of the webtop.
# distrobox needs this: `distrobox create` checks the image by running
# `<image> /bin/true`, which would never return if the webtop started.
case "$1" in
    /*) exec "$@" ;;
esac

cp    -TRn /init-config/ /config
chown -R   abc:abc       /config

# MyDocker sends a username in $1 and a password in $2
if [ "$2" ]; then
    export CUSTOM_USER=$1
    export PASSWORD=$2
fi

exec /init
