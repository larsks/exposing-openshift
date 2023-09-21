#!/bin/sh

HOST_ADDRESS=10.30.8.83
API_ADDRESS=192.168.122.250
INGRESS_ADDRESS=192.168.122.250

# This will probably already be set but it's best to be sure.
sysctl net.ipv4.ip_forward=1

iptables -N openshift-forward
iptables -A openshift-forward -d "$API_ADDRESS" -j ACCEPT
iptables -A openshift-forward -d "$INGRESS_ADDRESS" -j ACCEPT
iptables -I FORWARD -j openshift-forward

iptables -t nat -N openshift-prerouting
iptables -t nat -A openshift-prerouting -p tcp -d "$HOST_ADDRESS" --dport 6443 -j DNAT --to-destination 192.168.122.250:6443
iptables -t nat -A openshift-prerouting -p tcp -d "$HOST_ADDRESS" --dport 80 -j DNAT --to-destination 192.168.122.251:80
iptables -t nat -A openshift-prerouting -p tcp -d "$HOST_ADDRESS" --dport 443 -j DNAT --to-destination 192.168.122.251:443
iptables -t nat -A PREROUTING -j openshift-prerouting
