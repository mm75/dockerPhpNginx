FROM debian

MAINTAINER Mario Mendonça <mario.mendonca@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN export TERM=xterm
RUN echo "export TERM=xterm" >> /root/.bashrc

RUN apt-get update && apt-get install -y \
    curl \
    git \
    php5-dev \
    php5-cli \
    php5-intl \
    php-soap \
    php5-json \
    php5-curl \
    php5-fpm \
    php-pear \
    php5-gd \
    php5-pgsql \
    php5-mcrypt \
    php5-memcached \
    php5-memcache \
    php5-xdebug \
    nginx \
    net-tools \
    nano

RUN apt-get clean

#RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN rm /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-enabled/default

ADD default /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

ADD dev.ini /etc/php5/mods-available/dev.ini
RUN php5enmod dev

RUN mkdir /etc/nginx/ssl/

ADD nginx.crt /etc/nginx/ssl/
ADD nginx.key /etc/nginx/ssl/

RUN adduser --disabled-password --gecos '' www 

EXPOSE 80

# Find the line, cgi.fix_pathinfo=1, and change the 1 to 0.
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini
RUN sed -i "s/;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 0.0.0.0/" /etc/php5/fpm/pool.d/www.conf