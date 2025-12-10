#!/bin/env bash
source ./.env

echo "Building jenkins..."
docker build -t ${DOCKER_REGISTRY}/${JENKINS_SERVER_IMAGE}:${JENKINS_SERVER_TAG} .

echo "Pushing jenkins..."
docker login -u $DOCKER_REGISTRY_USER -p $DOCKER_REGISTRY_PAT
docker push ${DOCKER_REGISTRY}/${JENKINS_SERVER_IMAGE}:${JENKINS_SERVER_TAG}