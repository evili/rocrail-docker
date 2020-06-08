#!/bin/bash
set -x
export ROCRAIL_DIR=${ROCRAIL_DIR:-${HOME}/rocrail}
# Create symlinks if needed
if [ ! -e ${ROCRAIL_DIR}/svg ]
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
docker run -it --rm \
    --env="DISPLAY" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="${HOME}/rocrail:/rocrail:rw" \
    rocrail $*
