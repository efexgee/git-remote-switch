#!/bin/bash

# This assumes you want to change the hostname in your
# origin's remote from github.com to an alias you specified
# in your .ssh/config file of the form "github-something"

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

# some of my remote URLs are prefixed with 'ssh://' and have no colons
origin_host="$(echo $origin_url | sed 's/^ssh:\/\///' | awk -F'[@:/]' '{print $2}')"

if [[ "$origin_host" == "github.com" ]]; then
    echo "Exiting: origin URL's hostname is already github.com: $origin_url"
    exit 1
fi

new_url="$(echo $origin_url | sed "s/$origin_host/github.com/")"

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
