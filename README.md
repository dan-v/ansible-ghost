ansible-ghost
=============

Playbook for Ubuntu 12.04 to deploy Ghost blog.

Replacing SSL private key
* copy in your own ssl key to roles/blog/files/server.key
* run 'make encrypt_ssl' and set password

Running playbook
* su root
* apt-get install git make -y
* git clone https://github.com/dan-v/ansible-ghost.git && cd ansible-ghost
* update vars.yml to your liking
* ./run.sh
