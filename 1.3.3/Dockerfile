FROM php:7-apache

ENV GRAV_VERSION 1.3.3

RUN mkdir -p /usr/src/grav \
    && curl -fSL -o /usr/src/grav/grav.zip \
       "https://getgrav.org/download/core/grav/$GRAV_VERSION"

RUN set -xe \
    && buildDeps=" \
          unzip \
          libpng12-dev \
    " \
    && apt-get update && apt-get install -y libpng12-0 $buildDeps --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install gd zip \
    && ln -s /usr/src/grav /usr/src/grav/grav \
    && unzip /usr/src/grav/grav.zip -d /usr/src/grav \
    && rm /usr/src/grav/grav.zip /usr/src/grav/grav \
    && chown -R www-data:www-data /usr/src/grav \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps

RUN a2enmod rewrite

COPY ./docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/bin/sh", "/entrypoint.sh" ]
CMD [ "apache2-foreground" ]
