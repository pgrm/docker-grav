FROM php:7-apache

RUN set -xe \
    && mkdir -p /usr/src/grav/.unpacked \
    && apt-get update && apt-get install -y libpng16-16 git unzip libpng-dev libjpeg62-turbo libjpeg62-turbo-dev --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd zip opcache \
    && a2enmod rewrite

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini

ENV GRAV_URL "https://getgrav.org/download/skeletons/notepad-site/1.0.3"

RUN set -xe \
    && curl -fSL -o /usr/src/grav/grav.zip "$GRAV_URL" \
    && unzip /usr/src/grav/grav.zip -d /usr/src/grav/.unpacked \
    && rm /usr/src/grav/grav.zip \
    && mv /usr/src/grav/.unpacked/*/* /usr/src/grav \
    && mv /usr/src/grav/.unpacked/*/.[!.]* /usr/src/grav \
    && rm -rf /usr/src/grav/.unpacked \
    && chown -R www-data:www-data /usr/src/grav \
    && cd /usr/src/grav \
        && bin/gpm selfupgrade -y \
        && bin/gpm install -y admin git-sync

COPY ./docker-entrypoint.sh /entrypoint.sh

VOLUME /var/www/html

ENTRYPOINT [ "/bin/sh", "/entrypoint.sh" ]
CMD [ "apache2-foreground" ]
