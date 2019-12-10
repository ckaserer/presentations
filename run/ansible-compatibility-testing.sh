#!/bin/bash

docker run -d --expose=8080 \
             -p 8080:8080 \
             --entrypoint="/opt/revealjs/present.py" \
             gepardec/docker-present ansible-compatibility-testing 8080