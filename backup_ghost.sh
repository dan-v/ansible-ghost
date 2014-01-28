#!/bin/bash
#description  simple backup script for ghost blog
#notes        edit variables section before running

# variables
cookie_file=/tmp/cookie.txt
base_url="https://vittegleo.com"
signin_url="$base_url/ghost/signin/"
signin_user=""
signin_pass=""
export_url="$base_url/ghost/api/v0.1/db/"
export_file="ghost-backup-$(date +%m-%d-%y).json"

# check variables have been set
if [[ -z "$signin_user" ]]; then
  echo "Need to set 'signin_user' in this script. Exiting."
  exit 1
fi
if [[ -z "$signin_pass" ]]; then
  echo "Need to set 'signin_pass' in this script. Exiting."
  exit 1
fi

# clear cookies and gather csrf_token from login page
> $cookie_file
csrf_token=$(curl -s -k $signin_url --cookie-jar $cookie_file | awk -F\" '/csrf/{print $4}')
if [[ -z "$csrf_token" ]]; then
  echo "Failed to get csrf_token from $signin_url. Exiting."
  exit 1
fi

# login 
login_response=$(curl -k -s -o /dev/null -w "%{http_code}" --data "email=$signin_user&password=$signin_pass" $signin_url -c $cookie_file -b $cookie_file --header "X-CSRF-Token: $csrf_token")
if [ "$login_response" != "200" ]; then
  echo "Failed to login with provided credentials. Received HTTP response code $login_response. Exiting."
  exit 1
fi

# export data
export_response=$(curl -k -s -w "%{http_code}" $export_url -c $cookie_file -b $cookie_file -o $export_file)
if [ "$export_response" != "200" ]; then
  echo "Failed to export data. Received HTTP response code $export_response. Exiting."
  exit 1
fi

echo "Successfully backed up to $export_file"