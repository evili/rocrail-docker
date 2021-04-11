ARG UBUNTU_MAJOR=20
ARG UBUNTU_MINOR=04
ARG ROCRAIL_VERSION=1527
FROM ubuntu:${UBUNTU_MAJOR}.${UBUNTU_MINOR}
ARG UBUNTU_MAJOR
ARG UBUNTU_MINOR
ARG ROCRAIL_VERSION
ENV DEBIAN_FRONTEND=noninteractive
ENV APT_OPTS="--no-install-recommends --quiet -y"
RUN apt-get update && apt-get install ${APT_OPTS}  wget unzip ca-certificates
RUN apt-get install ${APT_OPTS} $(apt-cache search libusb-1 | egrep -v '(dev|doc|perl|ocaml)' | awk '{print $1}')
RUN apt-get install ${APT_OPTS} $(apt-cache search libwxgtk3 | grep -v dev | awk '{print $1}')
ENV ROCRAIL_ZIP=/tmp/rocrail.zip
ENV ROCRAIL_BASE=/opt/rocrail
ENV ROCRAIL_URL https://launchpad.net/rocrail/trunk/2.1/+download/Rocrail-${ROCRAIL_VERSION}-Ubuntu${UBUNTU_MAJOR}${UBUNTU_MINOR}-AMD64.zip
RUN update-ca-certificates
RUN apt-get purge
RUN apt-get autoclean
RUN apt-get clean all
RUN wget -O ${ROCRAIL_ZIP} ${ROCRAIL_URL}
RUN mkdir -pv ${ROCRAIL_BASE} && cd ${ROCRAIL_BASE} &&  unzip ${ROCRAIL_ZIP}

COPY entrypoint.sh /

RUN mkdir -pv /rocrail
WORKDIR /rocrail
VOLUME /rocrail
EXPOSE 8051
ENTRYPOINT /entrypoint.sh
