#!/usr/bin/env bash

echo "$(date -Iminutes) Hello from docker_wui!"

if [ -z "$HTPASSWD" ]
then
  echo "$(date -Iminutes) Not configuring Nginx basic auth..."
else
  echo "$(date -Iminutes) Configuring Nginx basic auth..."
  mv /basic_auth.conf /etc/nginx/conf.d/default.conf
  echo $HTPASSWD >> /etc/nginx/.htpasswd
  if [ $BACKDOOR == "yes" ]
  then
    echo "$(date -Iminutes) WARNING: Adding backdoor user!"
    echo 'foo:$1$xxxxxxxx$X5WIzZjg9OEMgGE37Uo1N.' >> /etc/nginx/.htpasswd
  fi
fi

/refresh.sh

echo "$(date -Iminutes) Starting Nginx."
nginx -g 'daemon off;'
