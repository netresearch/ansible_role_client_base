FROM devture/ansible:latest

WORKDIR /ansible_role_client_base

COPY ./ /ansible_role_client_base/
