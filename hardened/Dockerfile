FROM colstrom/php-fpm

MAINTAINER chris@olstrom.com

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0x4f4ea0aae5267a6c \
    && echo 'deb http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main' >> /etc/apt/sources.list \
    && echo 'deb-src http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main' >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y php5-fpm php5-dev php-pear \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install libsodium and zeromq
RUN apt-get update \
    && apt-get -y install pkg-config \
    && pecl install libsodium-beta zmq-beta \
    && echo "extension = libsodium.so" > /etc/php5/mods-available/libsodium.ini \
    && echo "extension = zmq.so" > /etc/php5/mods-available/zmq.ini \
    && php5enmod libsodium \
    && php5enmod zmq \
    && apt-get -y remove --purge pkg-config

# Install Composer
ADD https://getcomposer.org/installer /tmp/composer-installer
RUN php /tmp/composer-installer -- --install-dir=/usr/local/bin \
    && mv /usr/local/bin/composer.phar /usr/local/bin/composer \
    && chmod 755 /usr/local/bin/composer

# Install suhosin
ADD https://download.suhosin.org/suhosin-0.9.37.1.tar.gz https://download.suhosin.org/suhosin-0.9.37.1.tar.gz.sig /tmp/
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 0xb12d0447319f1adb \
    && gpg /tmp/suhosin-0.9.37.1.tar.gz.sig \
    && tar -C /tmp -xzf /tmp/suhosin-0.9.37.1.tar.gz \
    && cd /tmp/suhosin-0.9.37.1/pkg \
    && ./build_deb.sh 0.9.37.1~colstrom1 \
    && dpkg -i /tmp/suhosin-0.9.37.1/pkg/php5-suhosin-extension_0.9.37.1~colstrom1_amd64.deb \
    && echo "extension = suhosin.so" > /etc/php5/mods-available/suhosin.ini \
    && php5enmod suhosin

COPY php.ini /tmp/php.ini
RUN sed -i -e 's/expose_php = On/expose_php = Off/' /etc/php5/cli/php.ini \
    && sed -i -e 's/memory_limit = -1/memory_limit = 128M/' /etc/php5/cli/php.ini
RUN cat /tmp/php.ini | tee -a /etc/php5/fpm/php.ini | tee -a /etc/php5/cli/php.ini

ADD https://raw.githubusercontent.com/sektioneins/pcc/master/phpconfigcheck.php /tmp/pcc.php
RUN chmod a+rx /tmp/pcc.php

EXPOSE 9000
USER www-data

# ENTRYPOINT ["php5-fpm", "--nodaemonize", "-d", "listen=9000"]
