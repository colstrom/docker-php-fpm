FROM colstrom/ubuntu-standard

MAINTAINER chris@olstrom.com

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0x4f4ea0aae5267a6c \
    && echo 'deb http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main' >> /etc/apt/sources.list \
    && echo 'deb-src http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main' >> /etc/apt/sources.list \
    && apt-get update

RUN apt-get install -y php5-fpm php5-dev php-pear

# Install Build Dependencies
RUN apt-get install -y curl pkg-config

# Install Composer
RUN curl -Ss https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin \
    && mv /usr/local/bin/composer.phar /usr/local/bin/composer \
    && chmod 755 /usr/local/bin/composer

# Install PHPUnit
RUN curl -Sso /tmp/phpunit.phar https://phar.phpunit.de/phpunit.phar \
    && curl -Sso /tmp/phpunit.phar.asc https://phar.phpunit.de/phpunit.phar.asc \
    && gpg --keyserver keyserver.ubuntu.com --recv-keys 0x4aa394086372c20a \
    && gpg /tmp/phpunit.phar.asc \
    && mv /tmp/phpunit.phar /usr/local/bin/phpunit \
    && chmod 755 /usr/local/bin/phpunit

# Install libsodium extension
RUN pecl install libsodium-beta \
    && echo "extension = libsodium.so" > /etc/php5/mods-available/libsodium.ini \
    && php5enmod libsodium

# Install zeromq extension
RUN pecl install zmq-beta \
    && echo "extension = zmq.so" > /etc/php5/mods-available/zmq.ini \
    && php5enmod zmq

# Cleanup Build Dependencies
RUN apt-get -y remove --purge curl pkg-config

EXPOSE 9000

ENTRYPOINT ["php5-fpm", "--nodaemonize", "-d", "listen=9000"]
