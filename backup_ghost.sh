#!/bin/bash
# desc: backup ghost settings and data through web ui and backup content folder through ssh
# note: need to setup public/private key configuration for cron usage

echo -e "\n---"
echo -e "- Ghost Backup Script"
echo -e "---\n"

# change these
dns="vittegleo.com"
signin_user=""
signin_pass=""

# variables
base_url="https://${dns}"
signin_url="$base_url/ghost/signin/"
export_url="$base_url/ghost/api/v0.1/db/"
export_file="ghost-backup-$(date +%m-%d-%y).json"
content_backup_file="ghost-backup-content-$(date +%m-%d-%y).tar.gz"
ssh_user="deploy"
ssh_host="${dns}"
remote_backup_path="/home/ghost/content"
cookie_file=/tmp/cookie.txt

# checks
if [[ -z "$signin_user" ]]; then
  echo "Need to set 'signin_user' in this script. Exiting."
  exit 1
fi
if [[ -z "$signin_pass" ]]; then
  echo "Need to set 'signin_pass' in this script. Exiting."
  exit 1
fi

# first backup data and settings through UI
echo -e "\n--- Gather CSRF token from login page\n"
> $cookie_file
csrf_token=$(curl -s -k $signin_url --cookie-jar $cookie_file | awk -F\" '/csrf/{print $4}')
if [[ -z "$csrf_token" ]]; then
  echo "Failed to get csrf_token from $signin_url. Exiting."
  exit 1
fi

echo -e "\n--- Login to Ghost blog\n"
login_response=$(curl -k -s -o /dev/null -w "%{http_code}" --data "email=$signin_user&password=$signin_pass" $signin_url -c $cookie_file -b $cookie_file --header "X-CSRF-Token: $csrf_token")
if [ "$login_response" != "200" ]; then
  echo "Failed to login with provided credentials. Received HTTP response code $login_response. Exiting."
  exit 1
fi

echo -e "\n--- Export blog settings and data\n"
export_response=$(curl -k -s -w "%{http_code}" $export_url -c $cookie_file -b $cookie_file -o $export_file)
if [ "$export_response" != "200" ]; then
  echo "Failed to export data. Received HTTP response code $export_response. Exiting."
  exit 1
fi
echo -e "\n--- Successfully backed up settings and data to file '${export_file}'\n"

# second backup content folder (need to figure out ssh escaping)
echo -e "\n--- Backing up content folder over SSH\n"
backup=$(ssh ${ssh_user}@${ssh_host} \\"tar -zcvf - $remote_backup_path 2>/tmp/sshbackup\\" > ${content_backup_file})
if [ $? -ne 0 ]; then
	echo "ERROR: Failed to backup content folder over SSH."
	exit 1
fi
echo -e "\n--- Successfully backed up content folder to '${content_backup_file}'\n"

echo -e "\n--- Backup Finished\n"
