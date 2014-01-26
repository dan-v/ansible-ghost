ansible-ghost
=============

Playbook for Ubuntu 12.04.

Running playbook
* apt-get install git make -y
* git clone https://github.com/dan-v/ansible-ghost.git && cd ansible-ghost
* update vars.yml
* ./run.sh

Replacing SSL private key
* copy in your own ssl key to roles/blog/files/server.key
* run 'make encrypt_ssl' and set password