#!/bin/sh
# Ubuntu Xfce webtop
# Connect to http://localhost:3000/

# REPO=gitlab-research.centralesupelec.fr:4567/boulange/mydocker-images/
REPO=fredblgr/
IMAGE=docker-webtop-3asl
TAG=2025
URL=localhost
PORT=3000
SPORT=3001

debug=0
while [ $# -gt 0 ]
do
	case $1 in
	"-debug" )
		debug=1
	;;
	* )
		echo "# Unrecognized option: $1"
		echo "# Known options are: -debug"
		exit 1
	esac
	shift
done

# Get real user name and group
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

# Make sure we have the latest version of the image
docker pull ${REPO}${IMAGE}:${TAG} # > /dev/null 2>&1

if [ $debug -gt 0 ]
then
docker run --rm --tty --interactive \
  --publish ${PORT}:${PORT} \
  --publish ${SPORT}:${SPORT} \
  --volume ${PWD}/config:/config:rw \
  --name ${IMAGE} \
  --entrypoint=bash \
  ${REPO}${IMAGE}:${TAG}
else
docker run --rm --detach \
  --publish ${PORT}:${PORT} \
  --publish ${SPORT}:${SPORT} \
  --volume ${PWD}/config:/config:rw \
  --name ${IMAGE} \
  ${REPO}${IMAGE}:${TAG}

	echo "Waiting for container to start..."
	sleep 10
	echo "... done!"
	
	if [ -z "$SUDO_UID" ]
	then
		if [ `uname` == "Darwin" ]
		then
			# on MacOS, use open
			open -a firefox http://${URL}:${PORT}
		else
			# elsewhere, try xdg-open
			# and just write what to do if it fails
			xdg-open http://${URL}:${PORT} \
			|| echo "Point your web browser at http://${URL}:${PORT}"
		fi
	else
		if [ `uname` == "Darwin" ]
		then
			su ${USER_NAME} -c "open -a firefox http://${URL}:${PORT}"
		else
			su ${USER_NAME} -c "xdg-open http://${URL}:${PORT}" \
			|| echo "Point your web browser at http://${URL}:${PORT}"
		fi
	fi
fi
