#!/bin/bash
set -x
export DOCKER=${DOCKER:-/usr/bin/docker}
export ROCRAIL_DIR=${ROCRAIL_DIR:-${HOME}/rocrail}
export ROCRAIL_VERSION=${ROCRAIL_VERSION:-latest}
export X11_SOCKET=${X11_SOCKET:-/tmp/.X11-unix}
export DISPLAY=${DISPLAY:-":0.0"}
# Create symlinks if needed
if [ ! -L ${ROCRAIL_DIR}/svg ]
then
	pushd ${ROCRAIL_DIR}
	ln -svi /opt/rocrail/svg .
	popd
fi

CONTAINER_ID=$(${DOCKER} container run --rm -d \
    --publish-all \
    --expose 4303 \
    --expose 8051 \
    --expose 8051/udp \
    --expose 8088 \
    --volume="${X11_SOCKET}:/tmp/.X11-unix:rw" \
    --volume="${ROCRAIL_DIR}:/rocrail:rw" \
    --env "DISPLAY=$DISPLAY" \
    --env "GDK_SYNCHRONIZE=1" \
    --env "GDK_BACKEND=x11" \
    --ipc=host \
    rocrail:${ROCRAIL_VERSION} $*)

echo "Waiting RocRail to start..."

${DOCKER} container exec -t -i  \
    --env "DISPLAY=$DISPLAY" \
    --env "GDK_SYNCHRONIZE=1" \
    --env "GDK_BACKEND=x11" \
    ${CONTAINER_ID} \
    /opt/rocrail/bin/rocview -sp /opt/rocrail/bin -dp /opt/rocrail/demo

${DOCKER} container stop $CONTAINER_ID
