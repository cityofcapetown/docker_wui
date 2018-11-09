#!/usr/bin/env bash

echo "$(date -Iminutes) Hello from docker_wui!"

# Setting up db-utils
TIMEOUT=10
DB_UTILS_GIT="https://172.29.100.53:8580/OPM/db-utils.git"
DB_UTILS_DIR="/usr/share/nginx/db-utils"

echo "$(date -Iminutes) Trying to get db-utils."
timeout "$TIMEOUT" /usr/bin/git clone "$DB_UTILS_GIT" "$DB_UTILS_DIR"

if [ $? -eq 124 ]; then
  echo "$(date -Iminutes) Pull of db-utils timed out!"
fi

echo "$(date -Iminutes) Starting Nginx."
nginx -g 'daemon off;' 
