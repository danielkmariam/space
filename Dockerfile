# Install php dependencies
FROM php:7-fpm AS base

RUN apt update \
    && apt install -y zlib1g-dev libpng-dev git zip \
    && docker-php-ext-install exif gd pdo_mysql

# Dev image
FROM base AS dev

RUN apt update && apt install -y vim nodejs npm
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Install composer dependencies
FROM base AS build-fpm-composer

WORKDIR /var/www/html

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY ./composer.json /var/www/html/composer.json
RUN composer install --no-dev --no-scripts --no-autoloader

COPY . /var/www/html
RUN composer install --no-dev \
    && composer dump-autoload -o

# Build production image
FROM base AS build-fpm

WORKDIR /var/www/html
COPY --from=build-fpm-composer /var/www/html /var/www/html

# Build test image
FROM build-fpm AS test

RUN make test

# # Build asset image
# FROM node:10 AS assets-build

# WORKDIR /code
# COPY . /code/
# RUN npm ci
# RUN npm run production

# Build nginx
FROM nginx AS nginx

COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf
# COPY --from=assets-build /code/public /var/www/html/
