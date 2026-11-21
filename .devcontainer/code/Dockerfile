# Toolchain for building and testing Blackburn. The iOS Simulator stays on the host.
FROM golang:1.23.12-bookworm

ARG DART_VERSION=3.14.1
ARG DART_SHA256=759bed01e0aeb50e1a0b0a19474ba5c80c6087ce1d37b3214e475c81a44430e8

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        bash \
        build-essential \
        ca-certificates \
        curl \
        git \
        openssh-client \
        python3 \
        sudo \
        unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL -o /tmp/dartsdk.zip \
        "https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk/dartsdk-linux-x64-release.zip" \
    && echo "${DART_SHA256}  /tmp/dartsdk.zip" | sha256sum -c - \
    && unzip -q /tmp/dartsdk.zip -d /usr/lib \
    && rm /tmp/dartsdk.zip \
    && /usr/lib/dart-sdk/bin/dart --version

ARG INSTALL_DOCKER_CLI=0
ARG DOCKER_VERSION=29.10.0
ARG DOCKER_SHA256=7c1ebadc65c716cdc6d35fc78759ed0e4317debf43c21dd12f066f2006999def
RUN if [ "$INSTALL_DOCKER_CLI" = "1" ]; then \
        curl -fsSL -o /tmp/docker.tgz \
            "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" \
        && echo "${DOCKER_SHA256}  /tmp/docker.tgz" | sha256sum -c - \
        && tar -xzf /tmp/docker.tgz -C /tmp docker/docker \
        && install -m 755 /tmp/docker/docker /usr/local/bin/docker \
        && rm -rf /tmp/docker /tmp/docker.tgz; \
    fi

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd --gid "${USER_GID}" "${USERNAME}" \
    && useradd --uid "${USER_UID}" --gid "${USER_GID}" -m -s /bin/bash "${USERNAME}" \
    && mkdir -p /go/pkg/mod "/home/${USERNAME}/.cache/go-build" "/home/${USERNAME}/.cache/blackburn" "/home/${USERNAME}/.pub-cache" \
    && chown -R "${USERNAME}:${USERNAME}" /go "/home/${USERNAME}"

COPY dev-init.sh /usr/local/bin/blackburn-dev-init
RUN chmod 755 /usr/local/bin/blackburn-dev-init \
    && printf '%s ALL=(root) NOPASSWD: /usr/local/bin/blackburn-dev-init\n' "${USERNAME}" > /etc/sudoers.d/blackburn-dev-init \
    && chmod 440 /etc/sudoers.d/blackburn-dev-init

ENV GOPATH=/go \
    GOMODCACHE=/go/pkg/mod \
    GOCACHE=/home/vscode/.cache/go-build \
    PUB_CACHE=/home/vscode/.pub-cache \
    PATH=/usr/lib/dart-sdk/bin:/usr/local/go/bin:/go/bin:${PATH}

USER vscode
WORKDIR /workspaces
