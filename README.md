# Rocrail Docker
Run rocrail on a Docker containter

## How to use it

*  Build the image (first time, or if ther is a new rocrail version).
```
   docker build -t rocrail .
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
