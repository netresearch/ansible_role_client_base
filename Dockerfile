FROM devture/ansible:latest

WORKDIR /ansible_role_client_base

COPY ./ /ansible_role_client_base/

RUN apk add --no-cache py3-pip && \
    python3 -m venv /ansible_env && \
    /ansible_env/bin/pip install --no-cache-dir passlib

ENV PATH="/ansible_env/bin:$PATH"