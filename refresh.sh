#!/usr/bin/env bash

echo "$(date -Iseconds) Refreshing content"

URL=${1:-$CONTENT_URL}
DIR=${2:-$CONTENT_DIR}

# Download the content
wget -O site.zip $URL
unzip site.zip -d $DIR

ls -l $DIR

echo "$(date -Iseconds) Finished refreshing content"
