FROM dunglas/frankenphp:latest-php8.4 AS base

# Extensions PHP requises
RUN install-php-extensions \
    intl \
    zip \
    opcache \
    pdo_pgsql \
    @composer

COPY --link docker/frankenphp/Caddyfile /etc/caddy/Caddyfile

WORKDIR /app

FROM base AS dev

# En dev, le code est monté via volume — pas de COPY
# vendor est dans un volume séparé pour isolation
COPY --link composer.json composer.lock ./
RUN composer install --no-scripts --no-autoloader

COPY --link . .
RUN composer dump-autoload --optimize

FROM base AS production

COPY --link docker/frankenphp/Caddyfile.prod /etc/caddy/Caddyfile

COPY --link . .

RUN composer install \
    --no-dev \
    --optimize-autoloader \
    --classmap-authoritative \
    --no-scripts

RUN setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/frankenphp
RUN mkdir -p /app/var /app/var/cache /app/var/log && \
    chown -R www-data:www-data /app/var
