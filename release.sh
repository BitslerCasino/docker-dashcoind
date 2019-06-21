#!/usr/bin/env bash

# this is used along side github-release. install it via go get github.com/aktau/github-release
VERSION=$1

if [ -z "$VERSION" ]; then
  echo "Missing version"
  exit;
fi

github-release release \
    --user bitslercasino \
    --repo docker-dashcoind \
    --tag v$VERSION \
    --name "v$VERSION Stable Release" \
    --description "Dashcoin"

github-release upload \
    --user bitslercasino \
    --repo docker-dashcoind \
    --tag v$VERSION \
    --name "dash_install.sh" \
    --file dash_install.sh

github-release upload \
    --user bitslercasino \
    --repo docker-dashcoind \
    --tag v$VERSION \
    --name "dash_utils.sh" \
    --file dash_utils.sh

sed -i "s/docker-dashcoind\/releases\/download\/.*\/dash_install\.sh/docker-dashcoind\/releases\/download\/v$VERSION\/dash_install\.sh/g" README.md
sed -i "s/docker-dashcoind\/releases\/download\/.*\/dash_utils\.sh/docker-dashcoind\/releases\/download\/v$VERSION\/dash_utils\.sh/g" README.md
