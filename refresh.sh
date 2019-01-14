#!/usr/bin/env bash

echo "$(date -Iminutes) Refreshing content"

URL=${1:-$CONTENT_URL}
DIR=${2:-$CONTENT_DIR}

# Getting the list of keys in this bucket
CONTENT_LIST_RAW=$(curl -s "\"$URL\"")
echo curl -s "\"$URL\""

if [[ "$CONTENT_LIST_RAW" == "" ]]; then
  echo "$(date -Iminutes) No content found at '$URL'"
  exit 1
elif [[ $(echo "$CONTENT_LIST_RAW" | grep "Key") == "" ]]; then
  echo "$(date -Iminutes) No Keys found at '$URL'"
  exit 1
fi

CONTENT_LIST=$(echo $CONTENT_LIST_RAW | grep -oP '(?<=Key>)[^<]+')

# Retrieving the contents in the bucket
for file in $CONTENT_LIST; do
    file_url=$URL/$file
    wget -q -N $file_url -P $file
done

echo "$(date -Iminutes) Finished refreshing content"
