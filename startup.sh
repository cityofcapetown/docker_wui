#!/usr/bin/env bash

echo "$(date -Iminutes) Hello from docker_wui!"

/refresh.sh

echo "$(date -Iminutes) Starting Nginx."
nginx -g 'daemon off;' 
