#!/bin/bash

readonly FLAG_DRYRUN=false
readonly DOCKER_PRESENT_SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source /dev/stdin  <<< "$(curl -sSL https://raw.githubusercontent.com/ckaserer/bash-script-collection/master/functions/execute.sh)" 

# docker-present
function docker-present () {
  execute "docker run -i --rm -v /var/run/docker.sock:/var/run/docker.sock --name docker-present gepardec/presentations -p 8080"
}
readonly -f docker-present
[ "$?" -eq "0" ] || return $?

# docker-present-stop
function docker-present-stop () {
  local presentation=${1}
  execute "docker container rm -f $(docker container ls --filter "name=docker-present-${presentation}" -aq)"
}
readonly -f docker-present-stop
[ "$?" -eq "0" ] || return $?

# docker-present-build
function docker-present-build () {
  execute "docker build -t gepardec/presentations ${DOCKER_PRESENT_SCRIPT_DIR}/revealjs $@"
}
readonly -f docker-present-build
[ "$?" -eq "0" ] || return $?

# docker-present-ansible-compatibility-testing
function docker-present-ansible-compatibility-testing () {
  execute "docker run -d -p 8080:8080 --entrypoint=/opt/revealjs/bin/present.py --name docker-present-ansible-compatibility-testing gepardec/presentations ansible-compatibility-testing 8080"
}
readonly -f docker-present-ansible-compatibility-testing
[ "$?" -eq "0" ] || return $?

# docker-present-publish-revealjs
function docker-present-publish-revealjs () {
  set -e
  docker-present-build
  docker-present-ansible-compatibility-testing
  execute "docker cp docker-present-ansible-compatibility-testing:/opt/revealjs/css ${DOCKER_PRESENT_SCRIPT_DIR}/docs/"
  execute "docker cp docker-present-ansible-compatibility-testing:/opt/revealjs/images ${DOCKER_PRESENT_SCRIPT_DIR}/docs/"
  execute "docker cp docker-present-ansible-compatibility-testing:/opt/revealjs/js ${DOCKER_PRESENT_SCRIPT_DIR}/docs/"
  execute "docker cp docker-present-ansible-compatibility-testing:/opt/revealjs/lib ${DOCKER_PRESENT_SCRIPT_DIR}/docs/"
  execute "docker cp docker-present-ansible-compatibility-testing:/opt/revealjs/plugin ${DOCKER_PRESENT_SCRIPT_DIR}/docs/"
  execute "docker cp docker-present-ansible-compatibility-testing:/opt/revealjs/src/css ${DOCKER_PRESENT_SCRIPT_DIR}/docs/src/"
  execute "docker cp docker-present-ansible-compatibility-testing:/opt/revealjs/src/fonts ${DOCKER_PRESENT_SCRIPT_DIR}/docs/src/"
  docker-present-stop ${presentation}
  set +e
}
readonly -f docker-present-publish-revealjs
[ "$?" -eq "0" ] || return $?

# docker-present-publish
function docker-present-publish () {
  local presentation=${1}
  set -e
  docker-present-build
  docker-present-${presentation}
  execute "docker cp docker-present-${presentation}:/opt/revealjs/src/modules/${presentation} ${DOCKER_PRESENT_SCRIPT_DIR}/docs/src/modules/"
  execute "docker cp docker-present-${presentation}:/opt/revealjs/index.html ${DOCKER_PRESENT_SCRIPT_DIR}/docs/${presentation}.html"
  docker-present-stop ${presentation}
  set +e
}
readonly -f docker-present-publish
[ "$?" -eq "0" ] || return $?

