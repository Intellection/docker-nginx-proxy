FROM zappi/nginx:1.19.5 as builder

USER root

# Install build dependencies
RUN  apk add --no-cache \
      alpine-sdk \
      bash \
      findutils \
      gcc \
      gd-dev \
      geoip-dev \
      libc-dev \
      libedit-dev \
      libxslt-dev \
      linux-headers \
      make \
      mercurial \
      openssl-dev \
      pcre-dev \
      perl-dev \
      zlib-dev

WORKDIR /usr/src/

# Download nginx source
ARG NGINX_VERSION="1.19.5"
ARG NGINX_PKG="nginx-${NGINX_VERSION}.tar.gz"
ARG NGINX_SHA="5c0a46afd6c452d4443f6ec0767f4d5c3e7c499e55a60cd6542b35a61eda799c"

RUN wget "http://nginx.org/download/${NGINX_PKG}" && \
    echo "${NGINX_SHA} *${NGINX_PKG}" | sha256sum -c - && \
    tar --no-same-owner -xzf ${NGINX_PKG} --one-top-level=nginx --strip-components=1

# Download headers-more module source
ARG HEADERS_MORE_VERSION="0.33"
ARG HEADERS_MORE_PKG="v${HEADERS_MORE_VERSION}.tar.gz"
ARG HEADERS_MORE_SHA="a3dcbab117a9c103bc1ea5200fc00a7b7d2af97ff7fd525f16f8ac2632e30fbf"

RUN wget "https://github.com/openresty/headers-more-nginx-module/archive/${HEADERS_MORE_PKG}" && \
    echo "${HEADERS_MORE_SHA} *${HEADERS_MORE_PKG}" | sha256sum -c - && \
    tar --no-same-owner -xzf ${HEADERS_MORE_PKG} --one-top-level=headers-more --strip-components=1

# Compile nginx with headers-more module using original configure arguments
RUN cd nginx && \
    CONFIGURATION_ARGUMENTS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') && \
    sh -c "./configure --with-compat ${CONFIGURATION_ARGUMENTS} --add-dynamic-module=/usr/src/headers-more" && \
    make modules

# Production container starts here
FROM zappi/nginx:1.19.5

# Copy compiled module
COPY --from=builder /usr/src/nginx/objs/*_module.so /etc/nginx/modules/

COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/mime.types /etc/nginx/mime.types
COPY ./config/robots.txt /etc/nginx/robots.txt

STOPSIGNAL SIGQUIT
EXPOSE 8080
USER nginx:nginx
