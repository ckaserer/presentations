#!/bin/bash

source bashrc

set -e

docker image ls
docker-present-build
docker image ls

docker container ls -a
echo 1 | docker-present
docker container ls -a
docker-present-stop
docker container ls -a

docker-present-ansible-compatibility-testing
docker container ls -a
docker-present-stop ansible-compatibility-testing
docker container ls -a

docker-present-redhat-forum-2020
docker container ls -a
docker-present-stop redhat-forum-2020
docker container ls -a

docker-present-publish-revealjs
docker container ls -a

docker-present-publish ansible-compatibility-testing
docker container ls -a

set +e