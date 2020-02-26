#!/bin/bash -e
# Entrypoint for Docker Container

# Check if already present
if [ -f /var/www/index.html ]; then
    echo 'Info: index.html already present'
else
    echo 'Info: Generating index.html ...'

    cp /var/www/index.default.html /var/www/index.html

    if [ ! -z "$WEBSOCKET_URL" ]; then
        sed -i "s#websocket_url: undefined#websocket_url: '$WEBSOCKET_URL'#" /var/www/index.html
    fi

    if [ ! -z "$BOSH_SERVICE_URL" ]; then
        sed -i "s#bosh_service_url: undefined#bosh_service_url: '$BOSH_SERVICE_URL'#" /var/www/index.html
    fi
fi

echo "Running $@ ..."
exec "$@"
