# Changelog

## 1.19.5-6

* Set `client_body_buffer_size` to `128k`.
* Set `client_header_timeout` to `65s`.
* Set `client_max_body_size` to `500m`.
* Set `keepalive_timeout` to `65s`.
* Set `send_timeout` to `60s`.

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
