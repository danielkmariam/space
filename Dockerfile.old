FROM php:fpm-alpine3.13 as base
# docker pull php:fpm-alpine3.13

WORKDIR /var/www/html

# Use the default production configuration
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install dependencies
RUN set -xe \
    && apk add --no-cache bash icu-dev \
    && docker-php-ext-install pdo pdo_mysql intl pcntl

CMD ["php-fpm"]


FROM composer:latest as composer

RUN rm -rf /var/www/html && mkdir /var/www/html
WORKDIR /var/www/html

COPY composer.* /var/www/html/

ARG APP_ENV=prod

RUN set -xe \
    && if [ "$APP_ENV" = "prod" ]; then export ARGS="--no-dev"; fi \
    && composer install --prefer-dist --no-scripts --no-progress --no-suggest --no-interaction $ARGS

COPY . /var/www/html

RUN composer dump-autoload --classmap-authoritative


FROM base as phpfpm

ARG APP_ENV=prod
ARG APP_DEBUG=0

ENV APP_ENV $APP_ENV
ENV APP_DEBUG $APP_DEBUG

COPY --from=composer /var/www/html/ /var/www/html/

# Memory limit increase is required by the dev image
RUN php -d memory_limit=256M bin/console cache:clear
RUN bin/console assets:install
