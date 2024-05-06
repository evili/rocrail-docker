ARG DEBIAN_MAJOR=11
ARG DEBIAN_MINOR=9
ARG ROCRAIL_VERSION=4558

FROM debian:${DEBIAN_MAJOR}.${DEBIAN_MINOR} AS rocrail-installer

ARG DEBIAN_MAJOR
ARG DEBIAN_MINOR

ENV DEBIAN_FRONTEND=noninteractive

# hadolint ignore=SC2046,DL3014,DL3015
RUN apt-get update && \
    apt-get install --no-install-recommends -qq -y bash wget unzip \
        ca-certificates libusb-1.0-0 libwxgtk3.0-gtk3-0v5 && \
    update-ca-certificates && \
    apt-get purge && apt-get autoclean && apt-get clean all && \
    rm -rf /var/lib/apt/lists/*


FROM rocrail-installer AS rocrail
ARG DEBIAN_MAJOR
ARG DEBIAN_MINOR
ARG ROCRAIL_VERSION

ENV ROCRAIL_ZIP=/tmp/rocrail.zip
ENV ROCRAIL_BASE=/opt/rocrail
ENV ROCRAIL_URL https://wiki.rocrail.net/rocrail-snapshot/history/Rocrail-${ROCRAIL_VERSION}-debian${DEBIAN_MAJOR}-i64.zip
# https://wiki.rocrail.net/rocrail-snapshot/history/Rocrail-4558-debian11-i64.zip

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

ENTRYPOINT ["/entrypoint.sh"]
