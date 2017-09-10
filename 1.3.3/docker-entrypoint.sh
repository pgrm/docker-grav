#!/bin/sh
set -e

if [ -z "$(ls -A /var/www/html)"]; then
	cp -a /usr/src/grav/. /var/www/html/
	/var/www/html/bin/gpm install admin
	if [ "$GRAV_REVERSE_PROXY" = "true" ]; then
		sed -i "s/reverse_proxy_setup:\sfalse/reverse_proxy_setup: true/g" \
		        system/config/system.yaml
	fi
fi

exec "$@"
