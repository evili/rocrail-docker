#!/bin/bash
set -x
export DOCKER=${/usr/bin/docker:${DOCKER}}
export ROCRAIL_DIR=${ROCRAIL_DIR:-${HOME}/rocrail}
export X11_SOCKET=${X11_SOCKER:-/tmp/.X11-unix}
# Create symlinks if needed
if [ ! -h ${ROCRAIL_DIR}/svg ]
then
	pushd ${ROCRAIL_DIR}
	ln -svi /opt/rocrail/svg .
	popd
fi
if [ ! -e ${ROCRAIL_DIR}/rocrail  ]
then
	pushd ${ROCRAIL_DIR}
	ln -svi /opt/rocrail/bin/rocrail .
	popd
fi
${DOCKER} run -it --rm \
    --env="DISPLAY" \
    --publish-all \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="${ROCRAIL_DIR}:/rocrail:rw" \
    rocrail $*
