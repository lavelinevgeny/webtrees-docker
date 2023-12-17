FROM nginx:latest

RUN apt-get clean && apt-get update && apt-get install -y \
  spawn-fcgi \
  fcgiwrap \
  less vim \
  unzip \
  certbot python3-certbot-nginx \ # for Let's encrypt certs
  && sed -i 's/www-data/nginx/g' /etc/init.d/fcgiwrap \
  && chown nginx:nginx /etc/init.d/fcgiwrap

COPY vhost.conf /etc/nginx/conf.d/default.conf
ADD https://github.com/fisharebest/webtrees/releases/download/2.1.18/webtrees-2.1.18.zip  /var/www/webtrees.zip

RUN cd /var/www \
  && unzip /var/www/webtrees.zip \
  && mv webtrees/* . \
  && rmdir webtrees \
  && rm webtrees.zip

CMD /etc/init.d/fcgiwrap start \
    && nginx -g 'daemon off;'
