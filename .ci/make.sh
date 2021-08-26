#!/bin/bash

####################### 
# READ ONLY VARIABLES #
#######################

readonly PROG_NAME=`basename "$0"`
readonly SCRIPT_HOME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly TOP_LEVEL_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd)

#################### 
# GLOBAL VARIABLES #
####################

########## 
# SOURCE #
##########

docker build -t presentations ${TOP_LEVEL_DIR}/revealjs
docker container rm -f presentation >/dev/null
docker run -d --entrypoint=/opt/revealjs/bin/present.py --name presentation presentations Training-for-Containerization 8080
docker cp presentation:/opt/revealjs ${TOP_LEVEL_DIR}/docs

for presentation in ${TOP_LEVEL_DIR}/revealjs/src/presentations/*; do
    echo $(basename $presentation)
    docker container rm -f presentation >/dev/null
    docker run -d --entrypoint=/opt/revealjs/bin/present.py --name presentation presentations $(basename $presentation) 8080
    docker cp presentation:/opt/revealjs/index.html ${TOP_LEVEL_DIR}/docs/$(basename $presentation).html
done

docker container rm -f presentation >/dev/null
docker run -d --entrypoint=/opt/revealjs/bin/present.py --name presentation presentations index 8080
docker cp presentation:/opt/revealjs/index.html ${TOP_LEVEL_DIR}/docs/index.html