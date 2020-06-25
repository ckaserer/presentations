#!/bin/bash

readonly FLAG_DRYRUN=false
readonly DOCKER_PRESENT_SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

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

# docker-present-redhat-forum-2020
function docker-present-redhat-forum-2020 () {
  execute "docker run -d -p 8080:8080 --entrypoint=/opt/revealjs/bin/present.py --name docker-present-redhat-forum-2020 gepardec/presentations redhat-forum-2020 8080"
}
readonly -f docker-present-redhat-forum-2020
[ "$?" -eq "0" ] || return $?

# docker-present-202002-iaam
function docker-present-202002-iaam () {
  execute "docker run -d -p 8080:8080 --entrypoint=/opt/revealjs/bin/present.py --name docker-present-202002-iaam gepardec/presentations 202002-iaam 8080"
}
readonly -f docker-present-202002-iaam
[ "$?" -eq "0" ] || return $?

# docker-present-Training-for-Containerization
function docker-present-Training-for-Containerization () {
  execute "docker run -d -p 8080:8080 --entrypoint=/opt/revealjs/bin/present.py --name docker-present-Training-for-Containerization gepardec/presentations Training-for-Containerization 8080"
}
readonly -f docker-present-Training-for-Containerization
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
  execute "rm -rf ${DOCKER_PRESENT_SCRIPT_DIR}/docs/plugins/menu/.git"
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
  local name=${2:-${1}}
  set -e
  docker-present-build
  docker run -d -p 8080:8080 --entrypoint=/opt/revealjs/bin/present.py --name docker-present-${presentation} gepardec/presentations ${presentation} 8080
  execute "docker cp docker-present-${presentation}:/opt/revealjs/src/modules/${presentation} ${DOCKER_PRESENT_SCRIPT_DIR}/docs/src/modules/"
  execute "docker cp docker-present-${presentation}:/opt/revealjs/index.html ${DOCKER_PRESENT_SCRIPT_DIR}/docs/${name}.html"
  # execute "docker run --rm --net=host -t -v ${DOCKER_PRESENT_SCRIPT_DIR}:/slides astefanutti/decktape --size=3840x2160 http://localhost:8080 ${DOCKER_PRESENT_SCRIPT_DIR}/docs/${name}.pdf"
  docker-present-stop ${presentation}
  set +e
}
readonly -f docker-present-publish
[ "$?" -eq "0" ] || return $?


# docker-present-export
function docker-present-export () {
  local presentation=${1}
  local decktape_opts=${2}

  set -e
  docker-present-build
  docker-present-${presentation}
  execute "docker run --rm --net=host -t -v ${DOCKER_PRESENT_SCRIPT_DIR}:/slides astefanutti/decktape ${decktape_opts} --size=1920x1080 http://localhost:8080 ${presentation}.pdf"
  execute "docker run --rm -it -v ${DOCKER_PRESENT_SCRIPT_DIR}:/slides --entrypoint bash woahbase/alpine-libreoffice:x86_64 -c 'soffice --headless --infilter=\"impress_pdf_import\" --convert-to odp --outdir /slides/ /slides/docs/${presentation}.pdf'"
  docker-present-stop ${presentation}
  set +e
}
readonly -f docker-present-export
[ "$?" -eq "0" ] || return $?

