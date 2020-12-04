FROM zappi/nginx:1.19.5

COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/mime.types /etc/nginx/mime.types
COPY ./config/robots.txt /etc/nginx/robots.txt

STOPSIGNAL SIGQUIT
EXPOSE 8080
USER nginx:nginx
