ARG UBUNTU_MAJOR=20
ARG UBUNTU_MINOR=04
ARG ROCRAIL_VERSION=2310

FROM ubuntu:${UBUNTU_MAJOR}.${UBUNTU_MINOR} AS rocrail-installer

ARG UBUNTU_MAJOR
ARG UBUNTU_MINOR

ENV DEBIAN_FRONTEND=noninteractive

# hadolint ignore=SC2046,DL3014,DL3015
RUN apt-get update && \
    apt-get install --no-install-recommends -qq -y bash tini wget=1.20.3-1ubuntu1 unzip=6.0-25ubuntu1 \
        ca-certificates=20210119~20.04.2 libusb-1.0-0=2:1.0.23-2build1 libwxgtk3.0-gtk3-0v5=3.0.4+dfsg-15build1 && \
    update-ca-certificates && \
    apt-get purge && apt-get autoclean && apt-get clean all && \
    rm -rf /var/lib/apt/lists/*


FROM rocrail-installer AS rocrail
ARG UBUNTU_MAJOR
ARG UBUNTU_MINOR
ARG ROCRAIL_VERSION

ENV ROCRAIL_ZIP=/tmp/rocrail.zip
ENV ROCRAIL_BASE=/opt/rocrail
ENV ROCRAIL_URL https://wiki.rocrail.net/rocrail-snapshot/history/Rocrail-${ROCRAIL_VERSION}-ubuntu${UBUNTU_MAJOR}${UBUNTU_MINOR}-AMD64.zip
# https://wiki.rocrail.net/rocrail-snapshot/history/Rocrail-2228-ubuntu2004-AMD64.zip

RUN wget --no-verbose -O ${ROCRAIL_ZIP} ${ROCRAIL_URL}
RUN mkdir -pv ${ROCRAIL_BASE}
WORKDIR    ${ROCRAIL_BASE}
RUN unzip -q ${ROCRAIL_ZIP}
# Unzip all themes from rocrail
WORKDIR ${ROCRAIL_BASE}/svg/themes
RUN /usr/bin/unzip -q -n ../\*.zip

RUN mkdir -pv /rocrail
VOLUME /rocrail
WORKDIR /rocrail

COPY entrypoint.sh /

# SNMP
EXPOSE 161/tcp
EXPOSE 161/udp
# SRCP
EXPOSE 4303/tcp
# Rocrail
EXPOSE 8051/tcp
EXPOSE 8051/udp
# RocWeb
EXPOSE 8088/tcp

ENTRYPOINT ["/usr/bin/tini", "--",  "/entrypoint.sh"]
