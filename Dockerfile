ARG UBUNTU_MAJOR=18
ARG UBUNTU_MINOR=04
FROM ubuntu:${UBUNTU_MAJOR}.${UBUNTU_MINOR}
ENV ROCRAIL_VERSION=621
ENV ROCRAIL_ZIP=/tmp/rocrail.zip
ENV ROCRAIL_BASE=/opt/rocrail
ENV ROCRAIL_URL https://launchpad.net/rocrail/trunk/2.1/+download/Rocrail-${ROCRAIL_VERSION}-Ubuntu${UBUNTU_MAJOR}${UBUNTU_MINOR}-AMD64.zip
# "https://launchpad.net/rocrail/trunk/2.1/+download/rocrail-${ROCRAIL_VERSION}-ubuntu${UBUNTU_MAJOR}${UBUNTO_MINOR}-amd64.deb"
# https://launchpad.net/rocrail/trunk/2.1/+download/Rocrail-621-Ubuntu1804-AMD64.zip
RUN apt-get update && apt-get install wget libwxgtk3.0-dev libusb-1.0-0-dev -y
RUN wget -O ${ROCRAIL_ZIP} ${ROCRAIL_URL}
RUN mkdir -pv ${ROCRAIL_BASE} && cd ${ROCRAIL_BASE} &&  unzip ${ROCRAIL_ZIP}

RUN mkdir -pv /rocrail
WORKDIR /rocrail
VOLUME /rocrail

ENTRYPOINT /opt/rocrail/rocview -sp /opt/rocrail
