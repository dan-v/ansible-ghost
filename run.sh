#!/bin/bash

echo -e "\n---"
echo -e "- Ghost Installer Script"
echo -e "---\n"

echo -e "\n--- Updating system packages\n"
command="sudo apt-get update"
run=$($command)
if [ $? -ne 0 ]; then
	echo "ERROR: Failed to update packages with command '$command' and exit code '$?'" && exit 1
fi

echo -e "\n--- Install ansible prereq packages\n"
command="sudo apt-get install python-pip python-dev git openssl -y"
run=$($command)
if [ $? -ne 0 ]; then
        echo "ERROR: Failed to install ansible prereqs with command '$command' and exit code '$?'" && exit 1
fi

echo -e "\n--- Installing ansible\n"
command="sudo pip install PyYAML jinja2 paramiko ansible"
run=$($command)
if [ $? -ne 0 ]; then
        echo "ERROR: Failed to install ansible with command '$command' and exit code '$?'" && exit 1
fi

key_file=roles/blog/files/server.key
encrypted_key_file="${key_file}.cast5"
if [ ! -f ${key_file} ]; then
	if [ ! -f ${encryptedkey_file} ]; then echo "ERROR: Could not find encrypted SSL key ${encrypted_key_file}."; exit 1; fi
	echo -e "\n--- Decrypting SSL file ${encrypted_key_file}\n"
	command="openssl cast5-cbc -d -in ${encrypted_key_file} -out ${key_file}"
	run=$($command)
	if [ $? -ne 0 ]; then
		echo "ERROR: Failed to decrypt key '${encrypted_key_file}' with command '$command'"
		rm -f $key_file
		exit 1
	else
		if [ ! -f ${key_file} ]; then echo "Could not find private SSL key ${key_file}. Exiting."; exit 1; fi
		echo -e "\n--- Successfully decrypted SSL file to ${key_file}\n"
	fi

	echo -e "\n--- Updating permissions for ${key_file}\n"
	command="chmod 600 ${key_file}"
	run=$($command)
	if [ $? -ne 0 ]; then
		echo "ERROR: Failed to update permissions for '${key_file}' with command '$command'" && exit 1
	fi
else
	echo -e "\n--- Found already decrypted SSL key file ${key_file}\n"
fi

echo -e "\n--- Running ansible playbook\n"
ansible-playbook -i hosts site.yml
