ARG PHP_ALPINE_IMAGE=php:8.2-alpine
FROM $PHP_ALPINE_IMAGE as zf1
ENV PHPUNIT_URI=${PHPUNIT_URI:-https://phar.phpunit.de/phpunit-9.6.phar}
RUN apk add --no-cache --update bzip2-dev libzip-dev gmp-dev; \
apk add --no-cache --virtual build-essentials \
icu-dev icu-libs zlib-dev g++ make automake autoconf libzip-dev \
libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev && \
docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp; \
docker-php-ext-install gd bcmath bz2 zip ctype gmp mysqli pdo_mysql; \
echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-ram-limit.ini; \
curl -L -o /usr/bin/phpunit ${PHPUNIT_URI} && chmod +x /usr/bin/phpunit
