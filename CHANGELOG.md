# Changelog

## 1.27.1

* Update base image to `zappi/nginx:1.27.1`.

## 1.25.4

* Add `X-Request-Start` header set to current time with millisecond precision.
* Update base image to `zappi/nginx:1.25.4`.

## 1.25.3-1

* Add OpenTelemetry (OTel) module i.e. `nginx-module-otel`.
* Update observability headers:
  * Add `X-Trace-ID`.
* Update logging fields:
  * Add `otel_trace_id`.

## 1.25.3

* Use `zappi/nginx:1.25.3` as the docker base image.
* Upgrade `headers-more-nginx-module` to `v0.37`.
* Update latency headers:
  * Add `X-Proxy-Request-Time`.
  * Add `X-Proxy-Backend-Response-Time`.
  * Remove `X-Proxy-Backend-Total-Time`.
* Update logging fields:
  * Add `http_x_proxy_backend_response_time`.
  * Remove `http_x_proxy_backend_total_time`.

## 1.25.2-3

* Log `X-Proxy-Backend` latency headers.

## 1.25.2-2

* Add `X-Proxy-Backend` latency headers.
* Remove incorrect `X-Server-Proxy-Time` configuration.

## 1.25.2-1

* Expose `$request_time` as `X-Server-Proxy-Time` response header.

## 1.25.2

* Upgrade to Nginx 1.25.2.
* Upgrade to Alpine 3.18.

## 1.23.3-1

* Enable gzip compression globally.

## 1.23.3

* Upgrade Nginx to 1.23.3.
* Upgrade headers-more to 0.34.

## 1.19.5-8

* Allow passing through `X-Forwarded-Host` header if it's set.

## 1.19.5-7

* Set `daemon` to `off`.
* Set `multi_accept` to `on`.
* Set `use` to `epoll`.
* Set `aio` to `threads`.
* Set `aio_write` to `on`.
* Set `tcp_nodelay` to `on`.
* Set `reset_timedout_connection` to `on`.
* Set `port_in_redirect` to `off`.
* Add `http_upgrade` and `proxy_connection` to log format.
* Remove setting of `sendfile` (turns it off).
* Remove setting of `client_max_body_size` (defaults to `1m`).
* Remove setting of `client_body_buffer_size` (defaults to `16k`).
* Reduce `client_body_timeout` to `60s` (same as default).
* Reduce `client_header_timeout` to `60s` (same as default).
* Reduce `keepalive_timeout` to `75s` (same as default).
* Reduce `proxy_connect_timeout` to `5s`.
* Reduce `proxy_read_timeout` to `60s` (same as default).
* Reduce `worker_shutdown_timeout` to `240s`.
* Set `Proxy` header to `""` to mitigate httpoxy vulnerability.
* Disable keep-alive on healthcheck server.
* Enable support for websockets.

## 1.19.5-6

* Set `client_body_buffer_size` to `128k`.
* Set `client_header_timeout` to `605s`.
* Set `client_max_body_size` to `500m`.
* Set `keepalive_timeout` to `605s`.
* Set `proxy_connect_timeout` to `60s` (same as default).
* Set `proxy_send_timeout` to `60s` (same as default).
* Set `send_timeout` to `60s` (same as default).

## 1.19.5-5

* Add `http_x_amzn_trace_id` to json logging (for `X-Amzn-Trace-Id` header).
* Add `http_connection` to json logging (for `Connection` header).
* Fix "incorrect" spelling of header.

## 1.19.5-4

* Renamed `main` logging format to `main_default`.
* Remove unnecessary double space between `$time_local` & `$status` from
  `main_default` logging format.
* Add `main_json` logging format and configure it on `access_log`.

## 1.19.5-3

* Set or forward `X-Request-ID`.
* Add computed `X-Request-ID` to the access logs.

## 1.19.5-2

* Forward `X-Forwarded-*` headers to upstream correctly.

## 1.19.5-1

* Change health check port from `18080` to `18081`.

## 1.19.5

* Initial release.
