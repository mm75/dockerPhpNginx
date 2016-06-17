FROM debian

MAINTAINER Jackson Veroneze <jackson@jacksonveroneze.com>

ENV DEBIAN_FRONTEND noninteractive

RUN export TERM=xterm
RUN echo "export TERM=xterm" >> /root/.bashrc

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get dist-upgrade -y

RUN apt-get install -y \
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
    php5-mysql \
    php5-mcrypt \
    php5-memcached \
    php5-memcache \
    php5-xdebug \
    php5-ldap \
    php5-imagick \
    nginx \
    net-tools \
    nano \
    locales

RUN locale-gen pt_BR && locale-gen pt_BR.UTF-8 && dpkg-reconfigure locales
ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR.UTF-8
ENV LC_ALL pt_BR


RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean

#RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN sed -i "s/;date.timezone =/date.timezone = America\/Sao_Paulo/" /etc/php5/cli/php.ini \
    && sed -i "s/;date.timezone =/date.timezone = America\/Sao_Paulo/" /etc/php5/fpm/php.ini \
    && sed -i "s/short_open_tag = On/short_open_tag = Off/" /etc/php5/cli/php.ini \
    && sed -i "s/short_open_tag = On/short_open_tag = Off/" /etc/php5/fpm/php.ini \
    && sed -i "s/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/" /etc/php5/cli/php.ini \
    && sed -i "s/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/" /etc/php5/fpm/php.ini \
    && sed -i "s/display_errors = Off/display_errors = On/" /etc/php5/cli/php.ini \
    && sed -i "s/display_errors = Off/display_errors = On/" /etc/php5/fpm/php.ini \
    && sed -i "s/display_startup_errors = Off/display_startup_errors = On/" /etc/php5/cli/php.ini \
    && sed -i "s/display_startup_errors = Off/display_startup_errors = On/" /etc/php5/fpm/php.ini \
    && sed -i "s/www-data;/www-data;\\ndaemon off;/g" /etc/nginx/nginx.conf

RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini
RUN sed -i "s/;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 0.0.0.0/" /etc/php5/fpm/pool.d/www.conf

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
EXPOSE 443
