#!/bin/bash
set -e
PG_MAJOR=16
IMAGE_NAME=pbear-neon
IMAGE_TAG=0.0.1-pg-${PG_MAJOR}

REGISTRY_ROOT=harbor.dh.ksyun.com

FULL_IMAGE_NAME=$REGISTRY_ROOT/bigdata/$IMAGE_NAME:${IMAGE_TAG}

docker build --network=host \
  -f Dockerfile -t $FULL_IMAGE_NAME ../..

docker images | grep ${IMAGE_NAME}

if [  "__"$1 == "__push" ]; then
	echo "Push image ..."
	docker push $FULL_IMAGE_NAME
	echo "Push done!"
fi
