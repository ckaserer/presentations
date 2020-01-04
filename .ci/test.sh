#!/bin/bash

source bashrc

set -e

docker-present-build
echo 1 | docker-present
docker rm -f $(docker ps -aq)

docker-present-ansible-compatibility-testing
docker rm -f $(docker ps -aq)

set +e