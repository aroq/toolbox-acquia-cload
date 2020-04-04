FROM aroq/toolbox-secrets:0.1.16

ENV ACAPI_VERSION=0.9.0

COPY Dockerfile.packages.txt /etc/apk/packages.txt
RUN apk add --no-cache --update $(grep -v '^#' /etc/apk/packages.txt)

# This hack is widely applied to avoid python printing issues in docker containers.
ENV PYTHONUNBUFFERED=1

# Install Python, pip & Ansible
RUN apk --update add --virtual .build-deps \
      python3-dev \
      libffi-dev \
      openssl-dev \
      build-base && \
    python3 -m ensurepip && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip \
      setuptools \
      wheel \
      acapi==${ACAPI_VERSION} && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/*
