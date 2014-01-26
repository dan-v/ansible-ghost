.PHONY: _pwd_prompt decrypt_ssl encrypt_ssl

KEY_FILE=roles/blog/files/server.key

# 'private' task for echoing instructions
_pwd_prompt:
	@echo "Contact me for the password."

# to create 
decrypt_ssl: _pwd_prompt
	openssl cast5-cbc -d -in ${KEY_FILE}.cast5 -out ${KEY_FILE}
	chmod 600 ${KEY_FILE}

# for updating 
encrypt_ssl: _pwd_prompt
	openssl cast5-cbc -e -in ${KEY_FILE} -out ${KEY_FILE}.cast5