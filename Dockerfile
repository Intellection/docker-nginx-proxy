FROM zappi/nginx:1.23.3 as builder

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
ARG NGINX_VERSION="1.23.3"
ARG NGINX_PKG="nginx-${NGINX_VERSION}.tar.gz"
ARG NGINX_SHA="75cb5787dbb9fae18b14810f91cc4343f64ce4c24e27302136fb52498042ba54"

RUN wget "http://nginx.org/download/${NGINX_PKG}" && \
    echo "${NGINX_SHA} *${NGINX_PKG}" | sha256sum -c - && \
    tar --no-same-owner -xzf ${NGINX_PKG} --one-top-level=nginx --strip-components=1

# Download headers-more module source
ARG HEADERS_MORE_VERSION="0.34"
ARG HEADERS_MORE_PKG="v${HEADERS_MORE_VERSION}.tar.gz"
ARG HEADERS_MORE_SHA="0c0d2ced2ce895b3f45eb2b230cd90508ab2a773299f153de14a43e44c1209b3"

RUN wget "https://github.com/openresty/headers-more-nginx-module/archive/${HEADERS_MORE_PKG}" && \
    echo "${HEADERS_MORE_SHA} *${HEADERS_MORE_PKG}" | sha256sum -c - && \
    tar --no-same-owner -xzf ${HEADERS_MORE_PKG} --one-top-level=headers-more --strip-components=1

# Compile nginx with headers-more module using original configure arguments
RUN cd nginx && \
    CONFIGURATION_ARGUMENTS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') && \
    sh -c "./configure --with-compat ${CONFIGURATION_ARGUMENTS} --add-dynamic-module=/usr/src/headers-more" && \
    make modules

# Production container starts here
FROM zappi/nginx:1.23.3

# Copy compiled module
COPY --from=builder /usr/src/nginx/objs/*_module.so /etc/nginx/modules/

COPY ./config/ /etc/nginx/

STOPSIGNAL SIGQUIT
EXPOSE 8080
USER nginx:nginx

CMD ["nginx"]
