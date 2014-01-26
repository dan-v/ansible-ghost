#!/bin/bash

apt-get update
apt-get install python-pip python-dev git -y
pip install PyYAML jinja2 paramiko ansible
make decrypt_ssl
ansible-playbook -i hosts site.yml
