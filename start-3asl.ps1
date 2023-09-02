# Has to be authorized using:
# Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
#
# $REPO="gitlab-research.centralesupelec.fr:4567/boulange/mydocker-images/"
$REPO="fredblgr/"
$IMAGE="docker-webtop-3asl"
$TAG="2023"
$URL="localhost"
$PORT="3000"
$SPORT="3001"
docker run --rm -d -p ${PORT}:${PORT} -v ${PWD}:/config:rw --name ${IMAGE}-run ${REPO}${IMAGE}:${TAG}
Start-Sleep -s 5
Start http://${URL}:${PORT}
