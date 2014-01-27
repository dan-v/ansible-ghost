ansible-ghost
=============

Playbook for Ubuntu 12.04 to deploy Ghost blog.

Running playbook
* apt-get install git -y
* git clone https://github.com/dan-v/ansible-ghost.git && cd ansible-ghost
* update vars.yml to your liking
* ./run.sh

Replacing SSL private key
* copy in your own ssl key to roles/blog/files/server.key
* encrypt ssl key with password: openssl cast5-cbc -e -in roles/blog/files/server.key -out roles/blog/files/server.key.cast5