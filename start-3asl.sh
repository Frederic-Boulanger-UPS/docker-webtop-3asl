#!/bin/sh
# Ubuntu icewm webtop
# Connect to http://localhost:3000/

# REPO=gitlab-research.centralesupelec.fr:4567/boulange/mydocker-images/
REPO=fredblgr/
IMAGE=docker-webtop-3asl
TAG=2024
URL=localhost
PORT=3000
SPORT=3001

if [ -z "$SUDO_UID" ]
then
  # not in sudo
  USER_ID=`id -u`
  USER_NAME=`id -n -u`
  GROUP_ID=`id -g`
else
  # in a sudo script
  USER_ID=${SUDO_UID}
  USER_NAME=${SUDO_USER}
  GROUP_ID=${SUDO_GID}
fi

docker run --rm --detach \
  --publish ${PORT}:${PORT} \
  --publish ${SPORT}:${SPORT} \
  --volume ${PWD}/config:/config:rw \
  --env PUID=${USER_ID} --env PGID=${GROUP_ID} \
  --name ${IMAGE} \
  ${REPO}${IMAGE}:${TAG}

echo "Waiting for container to start..."
sleep 10
echo "... done!"

if [ -z "$SUDO_UID" ]
then
     open -a firefox http://${URL}:${PORT} \
  || xdg-open http://${URL}:${PORT} \
  || echo "Point your web browser at http://${URL}:${PORT}"
else
     su ${USER_NAME} -c "open -a firefox http://${URL}:${PORT}" \
  || su ${USER_NAME} -c "xdg-open http://${URL}:${PORT}" \
  || echo "Point your web browser at http://${URL}:${PORT}"
fi
