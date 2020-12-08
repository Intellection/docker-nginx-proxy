# Docker Nginx Proxy

A basic reverse proxy designed to simplify header manipulation.

## Usage

To configure the upstream, create an `app.conf` with a `server` block:

```nginx
server {
    listen 8080;

    location / {
        proxy_pass http://app:80;
    }
}
```

The file must be placed in `/etc/nginx`.

## Header manipulation

Within the `server` block you can maniplate headers using the [`headers-more`](https://github.com/openresty/headers-more-nginx-module) module:

```nginx
server {
    ...

    # Remove a header
    more_clear_headers "Server";

    # Set a header
    more_set_headers 'X-Robots-Tag: "noindex, nofollow"';

    ...
}
```

## Further customisation

Since you're defining a standard `server` block, you can configure it however you like over and above just header manipulation. For example, you can add a custom `location`:

```nginx
server {
    ...

    # Use the default robots.txt to disallow all bots
    location /robots.txt {
        alias /etc/nginx/robots.txt;
    }

    ...
}
```

## Logging

To change how logging is configured, mount a file at `/etc/nginx/log.conf`:
```nginx 
access_log off;
error_log off;
```

## Core configuration

It's also possible to modify [core configuration](http://nginx.org/en/docs/ngx_core_module.html) such as those in the `main` section by mounting a file at `/etc/nginx/main.conf`:
```nginx
worker_processes auto;
worker_shutdown_timeout 300s;
```

It's important to note that overriding this file will remove the current defaults hence it's always a good idea to start with a copy of the defaults.

## Health check

A health check is available on port `18080` at `/healthz`.
