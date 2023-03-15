ARG PHP_ALPINE_IMAGE=php:8.2-alpine
FROM $PHP_ALPINE_IMAGE as zf1
RUN apk add --no-cache --update bzip2-dev libzip-dev gmp-dev; \
apk add --no-cache --virtual build-essentials \
icu-dev icu-libs zlib-dev g++ make automake autoconf libzip-dev \
libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev && \
docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp; \
docker-php-ext-install gd bcmath bz2 zip ctype gmp mysqli pdo_mysql; \
\
apk add --no-cache libmcrypt-dev && pecl install mcrypt && docker-php-ext-enable mcrypt;\
\
apk add --no-cache libmemcached-dev && pecl install memcached && docker-php-ext-enable memcached;\
\
apk add --no-cache libmemcached-dev zlib-dev && pecl install memcache && docker-php-ext-enable memcache;\
\
pecl install lzf && docker-php-ext-enable lzf;\
\
echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-ram-limit.ini;
