FROM php:7-apache

ENV GRAV_URL "https://getgrav.org/download/skeletons/woo-site/1.0.1"

RUN mkdir -p /usr/src/grav \
    && curl -fSL -o /usr/src/grav/grav.zip "$GRAV_URL"
       
RUN set -xe \
    && buildDeps=" \
          unzip \
          libpng12-dev \
    " \
    && apt-get update && apt-get install -y libpng12-0 git ssh-client $buildDeps --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install gd zip \
    && ln -s /usr/src/grav /usr/src/grav/grav \
    && unzip /usr/src/grav/grav.zip -d /usr/src/grav \
    && rm /usr/src/grav/grav.zip /usr/src/grav/grav \
    && chown -R www-data:www-data /usr/src/grav \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps \
    && a2enmod rewrite \
    && cd /usr/src/grav && bin/gpm install -y admin git-sync

COPY ./docker-entrypoint.sh /entrypoint.sh

VOLUME /var/www/html

ENTRYPOINT [ "/bin/sh", "/entrypoint.sh" ]
CMD [ "apache2-foreground" ]
