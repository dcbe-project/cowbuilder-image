FROM debian:sid-slim

ARG ARCH=arm64
ARG DIST=testing

USER root

ENV DEBIAN_FRONTEND noninteractive

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        wget \
        curl \
        gnupg2 \
        qemu-user-static \
        binfmt-support \
        kmod \
        cowbuilder \
        cowdancer \
        eatmydata \
        git-buildpackage \
        dpkg-dev \
        debhelper \
        dh-python \
        python3-setuptools \
        pkg-kde-tools \
        sudo \
        procps \
        locales && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

RUN echo "root:root" | chpasswd

RUN mkdir -p /usr/lib/pbuilder/hooks
RUN chmod 755 /usr/lib/pbuilder/hooks/*

RUN cowbuilder create --basepath /var/cache/pbuilder/base-$DIST-$ARCH.cow \
                      --architecture $ARCH --distribution $DIST
