#!/bin/bash

remotes="$(git remote -v)"

if (( $? != 0 )); then
    echo "Exiting: Error during git remote command"
    exit 1
fi

origin_url="$(git remote get-url origin)"

# there might not be an origin
if (( $? != 0 )); then
    echo "Exiting: Error during git remote command"
    exit 1
fi

#echo "$origin_url"

origin_host="$(echo $origin_url | awk -F'[@:]' '{print $2}')"

#echo "$origin_host"

if [[ "$origin_host" == "github.com" ]]; then
    echo "Exiting: origin URL's hostname is already github.com"
    exit 1
fi

new_url="$(echo $origin_url | sed 's/@[^:]*:/@github.com:/')"

#echo "$new_url"

git remote set-url origin "$new_url"

if (( $? != 0 )); then
    echo "Exiting: Error while setting new URL"
    exit 1
fi

echo "Remotes are now:"
git remote -v
echo
echo "Old remotes were:"
echo "$remotes"
