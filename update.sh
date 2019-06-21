#!/usr/bin/env bash

VERSION=$1

if [ -z "$VERSION" ]; then
  echo "Missing version"
  exit;
fi

TEMPLATE=docker.template
rm -rf $VERSION
mkdir -p $VERSION
DOCKERFILE=$VERSION/Dockerfile
eval "echo \"$(cat "${TEMPLATE}")\"" > $DOCKERFILE

docker build -f ./$VERSION/Dockerfile -t bitsler/docker-dashcoind:latest -t bitsler/docker-dashcoind:$VERSION .

docker push bitsler/docker-dashcoind:latest
docker push bitsler/docker-dashcoind:$VERSION