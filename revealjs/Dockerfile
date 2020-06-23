FROM node:6

RUN apt-get update && \
    apt-get install -y --no-install-recommends tree git bzip2 bsdmainutils && \
    curl -sSL https://get.docker.com | sh

WORKDIR /opt/revealjs

RUN ln -s /usr/bin/nodejs /usr/bin/node && \
    git clone --shallow-submodules --recurse-submodules --branch 3.9.2 https://github.com/hakimel/reveal.js.git /opt/revealjs && \
    git clone https://github.com/denehyg/reveal.js-menu.git /opt/revealjs/plugin/menu && \
    npm cache clean --force && \
    npm install -f 

ENTRYPOINT ["/opt/revealjs/bin/prompt"]

ARG BREAK=no
COPY . /opt/revealjs/