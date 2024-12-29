#!/bin/bash

set -e

/etc/init.d/urbackupclientbackend start

urbackupclientctl wait-for-backend

if [ -n "$INTERNET_ONLY" ]; then
  echo "Configuring INTERNET_ONLY=${INTERNET_ONLY}"
  sed -i 's/INTERNET_ONLY=.*/INTERNET_ONLY=$INTERNET_ONLY/' /etc/default/urbackupclient
fi

if [ -n "$NAME" ]; then
  echo "Setting Name: $NAME"
  urbackupclientctl set-settings --name $NAME
fi

if [ -n "$SERVER_URL" ]; then
  echo "Setting Server-URL: $SERVER_URL"
  urbackupclientctl set-settings --server-url $SERVER_URL
fi

if [ -n "$AUTHKEY" ]; then
  echo "Setting Authkey: $AUTHKEY"
  urbackupclientctl set-settings --name $AUTHKEY
fi

# add source dirs
for srcvar in ${!SOURCE_*}; do
  source=${!srcvar}
  echo "Adding backup source: $source"
  urbackupclientctl add-backupdir -d "$source"
done

# list sources
echo ""
urbackupclientctl list-backupdir
echo ""

tail -f /var/log/urbackupclient.log