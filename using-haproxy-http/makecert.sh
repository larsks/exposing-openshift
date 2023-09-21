#!/bin/sh

[[ -f server.crt.key ]] || openssl genpkey -out server.crt.key -quiet -algorithm rsa -pkeyopt rsa_keygen_bits:4096

openssl req -x509 -new -nodes -key server.crt.key \
	-days 3650 -sha256 \
	-subj /CN=api.tajcluster.openshift.virt \
	-addext 'subjectAltName = DNS:api.tajcluster.openshift.virt,DNS:*.tajcluster.openshift.virt' \
	-out server.crt
