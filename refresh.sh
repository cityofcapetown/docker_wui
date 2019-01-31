#!/usr/bin/env bash

echo "$(date -Iseconds) Refreshing content"

URL=${1:-$CONTENT_URL}
DIR=${2:-$CONTENT_DIR}

# Getting the list of keys in this bucket
QUERY_URL="$URL"
while true; do
    CONTENT_LIST_XML=$(curl -s $QUERY_URL)
    CONTENT_LIST=$(echo $CONTENT_LIST_XML | xpath -q -e "ListBucketResult/Contents/Key" | grep -oP '(?<=Key>)[^<]+')

    if [[ $? != 0 ]]; then
        echo "$(date -Iseconds) No more content found at '$URL'"
        break
    fi

    # Retrieving the contents in the bucket
    echo "$(date -Iseconds) Fetching "$(echo "$CONTENT_LIST" | wc -l)" files..."

    for file in $CONTENT_LIST; do
        file_url=$URL/$file
        wget -q -N $file_url -P "$DIR"/"$(dirname $file)"
    done

    NEXT_MARKER=$(echo $CONTENT_LIST_XML | xpath -q -e "ListBucketResult/NextMarker" | grep -oP '(?<=NextMarker>)[^<]+')
    QUERY_URL=""$URL"?marker=$NEXT_MARKER"
done

echo "$(date -Iseconds) Finished refreshing content"
