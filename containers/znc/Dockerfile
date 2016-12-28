FROM alpine:3.4

RUN adduser -S znc && addgroup -S znc

RUN mkdir -p /opt/znc/src /opt/znc/build
WORKDIR /opt/znc/build
ADD . /opt/znc/src

ARG CONFIGUREFLAGS="--enable-perl --enable-python 3.5"
ARG CLEANCMD="apk del build-dependencies && rm -Rf /opt/znc/build /opt/znc/src"
ARG MAKEFLAGS=""

RUN apk add --no-cache --virtual runtime-dependencies \
        icu \
        openssl \
        boost \
        python3 \
        perl \
        cyrus-sasl

# TODO compile modules in modules folder
RUN apk add --no-cache --virtual build-dependencies \
        build-base \
        cmake \
        git \
        icu-dev \
        openssl-dev \
        cyrus-sasl-dev \
        perl-dev \
        python3-dev \
        swig \
        gettext-dev \
        boost-dev \
    && /opt/znc/src/configure.sh $CONFIGUREFLAGS \
    && make $MAKEFLAGS \
    && make install \
    && sh -c "$CLEANCMD"

USER znc
WORKDIR /opt/znc
VOLUME /opt/znc/data

EXPOSE 6667

ENTRYPOINT ["/usr/local/bin/znc", "-f", "-d", "/opt/znc/data"]
