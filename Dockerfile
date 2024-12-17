ARG ANSIBLE_VERSION="<11>"

FROM python:3.12 AS base

RUN apt-get update -y \
 && apt-get full-upgrade -y \
 && apt-get install -y \
    sshpass \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    "ansible${ANSIBLE_VERSION}" \
    passlib

ENV PATH="/root/.local/bin:${PATH}"

COPY ./ /ansible_role_client_base/

WORKDIR /ansible_role_client_base