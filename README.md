ansible-ghost
=============

Playbook to deploy Ghost blog on Ubuntu 12.04. Tested on DigitalOcean.
* nginx for web server with ssl configured
* supervisor configured for running ghost with basic sqlite database
* postfix configuration sending to external gmail account
* basic security with ufw, disabled root ssh access, logwatch, fail2ban, and automatic security updates

Running playbook
* login to host where ghost will be deployed (playbook is run from local box)
* apt-get install git -y
* git clone https://github.com/dan-v/ansible-ghost.git && cd ansible-ghost
* update vars.yml to your liking and copy in your own ssl key as mentioned below
* ./run.sh

Replacing SSL private key and certificate file
* copy in your own crt file to roles/blog/files/server.crt
* copy in your own ssl key to roles/blog/files/server.key
* optionally if you want to be able to store the key encrypted in github: openssl cast5-cbc -e -in roles/blog/files/server.key -out roles/blog/files/server.key.cast5
