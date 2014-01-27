#!/bin/bash

# install required packages
apt-get update
apt-get install python-pip python-dev git openssl -y
pip install PyYAML jinja2 paramiko ansible

# if decrypted key does not exists.. decrypt
key_file=roles/blog/files/server.key
if [ ! -f ${key_file} ]; then
	openssl cast5-cbc -d -in ${key_file}.cast5 -out ${key_file}
	chmod 600 ${key_file}
	if [ ! -f ${key_file} ]; then echo "Could not find private SSL key ${key_file}. Exiting."; exit 1; fi
fi

# run playbook
ansible-playbook -i hosts site.yml