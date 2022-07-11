#!/bin/bash

# show the version
/opt/duoauthproxy/usr/local/bin/authproxy --version

CONFIG="/opt/duoauthproxy/conf/authproxy.cfg"

# create config file from env vars
env | grep -q DUO_CLOUD && echo '[cloud]' > $CONFIG
test ! -z "$DUO_CLOUD_IKEY" && echo "ikey=$DUO_CLOUD_IKEY" >> $CONFIG
test ! -z "$DUO_CLOUD_SKEY" && echo "skey=$DUO_CLOUD_SKEY" >> $CONFIG
test ! -z "$DUO_CLOUD_SKEY_FILE" && echo "skey=$(cat "$DUO_CLOUD_SKEY_FILE")" >> $CONFIG
test ! -z "$DUO_CLOUD_API_HOST" && echo "api_host=$DUO_CLOUD_API_HOST" >> $CONFIG
env | grep -q DUO_CLOUD && echo >> $CONFIG # add a new line
test ! -z "$SERVICE_ACCOUNT_USERNAME" && echo "service_account_username=$SERVICE_ACCOUNT_USERNAME" >> $CONFIG
test ! -z "$SERVICE_ACCOUNT_PASSWORD" && echo "service_account_password=$SERVICE_ACCOUNT_PASSWORD" >> $CONFIG
test ! -z "$SERVICE_ACCOUNT_PASSWORD_FILE" && echo "service_account_password=$(cat "$SERVICE_ACCOUNT_PASSWORD_FILE")" >> $CONFIG

# start duo stuff
/etc/init.d/duoauthproxy start

# check the duo process every 30 seconds
while true
do
  pgrep python3 > /dev/null || kill 1
  sleep 30
done &

# tail all the logs files
tail -f $(find /opt/duoauthproxy/log/ -type f)
