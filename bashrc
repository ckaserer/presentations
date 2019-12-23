#!/bin/bash

readonly DOCKER_PRESENT_SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# docker-present
function docker-present () {
  local command="docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock gepardec/docker-present -p 8080"
   echo "+ ${command} $@" && ${command} $@
}
readonly -f docker-present
[ "$?" -eq "0" ] || return $?

# docker-present-build
function docker-present-build () {
  local command="docker build -t gepardec/docker-present ${DOCKER_PRESENT_SCRIPT_DIR}"
   echo "+ ${command} $@" && ${command} $@
}
readonly -f docker-present-build
[ "$?" -eq "0" ] || return $?
