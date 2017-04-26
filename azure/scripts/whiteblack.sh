#!/bin/bash

WHITELIST=whitelist
BLACKLIST=blacklist
REST_ADDR="ajp://$restIp:8009"
HTTPD_CONFIGFILE="/etc/httpd/conf/httpd.conf"

process_endpoints () {
  FILE=$1
  PROXY_STRING=$2
  
  while read -r || [ -n "$REPLY" ]
  do
    endpoint="/rest"$REPLY
    sudo su -c "echo \"ProxyPass $endpoint $(eval echo $PROXY_STRING)\" >>  $HTTPD_CONFIGFILE"
  done < $FILE
}

process_endpoints $WHITELIST "\$REST_ADDR\$endpoint"
process_endpoints $BLACKLIST "!"