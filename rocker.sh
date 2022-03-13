#!/bin/bash
set -x
export DOCKER=${DOCKER:-/usr/bin/docker}
export ROCRAIL_DIR=${ROCRAIL_DIR:-${HOME}/rocrail}
export ROCRAIL_VERSION=${ROCRAIL_VERSION:-latest}
export X11_SOCKET=${X11_SOCKET:-/tmp/.X11-unix}
# Create symlinks if needed
if [ ! -L ${ROCRAIL_DIR}/svg ]
then
	pushd ${ROCRAIL_DIR}
	ln -svi /opt/rocrail/svg .
	popd
fi

CONTAINER_ID=$(${DOCKER} container run --rm -d \
    --publish-all \
    --volume="${X11_SOCKET}:/tmp/.X11-unix:rw" \
    --volume="${ROCRAIL_DIR}:/rocrail:rw" \
    rocrail:${ROCRAIL_VERSION} $*)

${DOCKER} container exec \
    --env="DISPLAY=$DISPLAY" \
    ${CONTAINER_ID} \
    /opt/rocrail/bin/rocview -sp /opt/rocrail/bin -dp /opt/rocrail/demo

${DOCKER} container stop $CONTAINER_ID
