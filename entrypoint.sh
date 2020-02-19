#!/bin/bash
# Entrypoint for Docker Container

# Check if already provisioned
if [ -f application/config/config.php ]; then
    echo 'Info: index.html already present'
else
    echo 'Info: Generating index.html'

    cp /var/www/index.default.html /var/www/index.html

    sed -i "s#\('username' => \).*,\$#\\1'${DB_USERNAME}',#g" application/config/config.php
    sed -i "s#\('password' => \).*,\$#\\1'${DB_PASSWORD}',#g" application/config/config.php
    sed -i "s#\('charset' => \).*,\$#\\1'${DB_CHARSET}',#g" application/config/config.php
    sed -i "s#\('tablePrefix' => \).*,\$#\\1'${DB_TABLE_PREFIX}',#g" application/config/config.php

    if [ ! -z "$WEBSOCKET_URL" ]; then
        sed -i "s/websocket_url: undefined/websocket_url: '$WEBSOCKET_URL'/" /var/www/index.html
    fi
fi

echo 'Info: Using the following index.html'
cat /var/www/index.html

exec "$@"
