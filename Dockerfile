FROM node:16

RUN apt update && \
    apt install -y --no-install-recommends \
    tree \
    git \
    bzip2 \
    bsdmainutils \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo \
        "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt update && \
    apt install -y docker-ce docker-ce-cli containerd.io

WORKDIR /opt/revealjs

RUN ln -s /usr/bin/nodejs /usr/bin/node && \
    git clone --shallow-submodules --recurse-submodules --branch 4.1.2 https://github.com/hakimel/reveal.js.git /opt/revealjs && \
    git clone https://github.com/denehyg/reveal.js-menu.git /opt/revealjs/plugin/menu && \
    npm cache clean --force && \
    npm install -f 

ENTRYPOINT ["/opt/revealjs/bin/prompt"]

ARG BREAK=no
COPY . /opt/revealjs/