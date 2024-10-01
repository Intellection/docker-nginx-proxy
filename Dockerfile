FROM zappi/nginx:1.27.1 AS builder

USER root

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
      build-essential \
      ca-certificates \
      # headers-more
      libpcre3 \
      libpcre3-dev \
      wget \
      zlib1g \
      zlib1g-dev

WORKDIR /usr/src/

# Download nginx source
ARG NGINX_VERSION="1.27.1"
ARG NGINX_PKG="nginx-${NGINX_VERSION}.tar.gz"
ARG NGINX_SHA="bd7ba68a6ce1ea3768b771c7e2ab4955a59fb1b1ae8d554fedb6c2304104bdfc"
RUN wget "http://nginx.org/download/${NGINX_PKG}" && \
    echo "${NGINX_SHA} *${NGINX_PKG}" | sha256sum -c - && \
    tar --no-same-owner -xzf ${NGINX_PKG} --one-top-level=nginx --strip-components=1

# Download headers-more module source
ARG HEADERS_MORE_VERSION="0.37"
ARG HEADERS_MORE_PKG="v${HEADERS_MORE_VERSION}.tar.gz"
ARG HEADERS_MORE_SHA="cf6e169d6b350c06d0c730b0eaf4973394026ad40094cddd3b3a5b346577019d"
RUN wget "https://github.com/openresty/headers-more-nginx-module/archive/${HEADERS_MORE_PKG}" && \
    echo "${HEADERS_MORE_SHA} *${HEADERS_MORE_PKG}" | sha256sum -c - && \
    tar --no-same-owner -xzf ${HEADERS_MORE_PKG} --one-top-level=headers-more --strip-components=1

# Compile nginx with headers-more module using original configure arguments
RUN cd nginx && \
    ./configure --with-compat --add-dynamic-module=/usr/src/headers-more && \
    make modules

# Production container starts here
FROM zappi/nginx:1.27.1

USER root

# Set up official Nginx repository
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        gnupg2 \
        wget && \
    rm -rf /var/lib/apt/lists/* /tmp/* && \
    wget -q -O - https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /etc/apt/keyrings/nginx.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nginx.gpg] http://nginx.org/packages/mainline/debian bookworm nginx" | tee /etc/apt/sources.list.d/nginx.list && \
    apt-get purge --auto-remove -y \
        ca-certificates \
        gnupg2 \
        wget

# Module: OpenTelemetry (OTel)
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
      nginx-module-otel && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Copy compiled module
COPY --from=builder /usr/src/nginx/objs/*_module.so /etc/nginx/modules/

COPY ./config/ /etc/nginx/

STOPSIGNAL SIGQUIT
EXPOSE 8080
USER nginx:nginx

CMD ["nginx"]
