# Rocrail Docker

Run [rocrail](https://wiki.rocrail.net) on a Docker containter.

This Docker image will help run rocrail on linux distibutions and
environments not relased by rocrail.

## How to use it

*  Build the image (first time, or if there is a new rocrail version).
```
   docker build -t rocrail .
```
*  You can choose the base OS distribution release and rocrail version:
```
  docker build --build-arg=ROCRAIL_VERSION=1234 --build-arg=DEBIAN_VERSION=12 -t rocrail .
```
*  Create rocrail directory (if needed):
```
   export ROCRAIL_DIR=${HOME}/rocrail
   mkdir -pv ${ROCRAIL_DIR}
```

* Get fun!:
```
   ./rocker.sh
```
