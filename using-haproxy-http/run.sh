#!/bin/sh

[[ -f server.crt ]] || sh makecert.sh

exec podman run -d --rm --name haproxy \
	-v $PWD/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg \
	-v $PWD:/certs \
	-p 6443:6443 -p 80:8080 -p 443:8443 docker.io/haproxy:2.8
