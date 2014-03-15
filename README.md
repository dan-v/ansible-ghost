ansible-ghost
=============

#### Playbook to deploy Ghost blog on Ubuntu 12.04. Tested on DigitalOcean.
* nginx for web server with ssl configured
* supervisor configured for running ghost with basic sqlite database
* postfix configuration sending to external gmail account
* basic security with ufw, disabled root ssh access, logwatch, fail2ban, and automatic security updates



#### Running playbook

1. login to host where ghost will be deployed (playbook is run from local box)

```
apt-get install git -y
git clone https://github.com/dan-v/ansible-ghost.git && cd ansible-ghost
```

2. update vars.yml (explained below)
3. copy in your own ssl key as described below

```
./run.sh
```

#### Updating information

Replacing SSL private key and certificate file

* copy in your own crt file to roles/blog/files/server.crt
* copy in your own ssl key to roles/blog/files/server.key
* optionally if you want to be able to store the key encrypted in github: 

```
openssl cast5-cbc -e -in roles/blog/files/server.key -out roles/blog/files/server.key.cast5
```

#### vars.yml

    # common
    domain: example.com
    mailer_email: "info@{{ domain }}"

    # a new deploy user is used for dpeloyment
    deploy_user: deploy
    deploy_password: '<dan to update>'
    ssh_pub_key: 'ssh-key <this is your ssh public key that you would put in authorized keys>'

    # Updates from this release for secuity reasons
    ubuntu_release: 'precise'

    # blog
    blog_domain: "{{ domain }}"
    ghost_ver: 0.4.1
    ghost_zip_url: "https://ghost.org/zip/ghost-{{ ghost_ver }}.zip"
    ghost_user: ghost
    ghost_install_dir: /home/ghost


