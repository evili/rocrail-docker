#!/bin/bash
set -x
export ROCRAIL_DIR=${ROCRAIL_DIR:-${HOME}/rocrail}
docker run -it --rm \
    --env="DISPLAY" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="${HOME}/rocrail:/rocrail:rw" \
    rocrail $*
