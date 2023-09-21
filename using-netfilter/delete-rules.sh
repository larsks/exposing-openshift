#!/bin/sh

iptables -D FORWARD -j openshift-forward
iptables -F openshift-forward
iptables -X openshift-forward

iptables -t nat -D PREROUTING -j openshift-prerouting
iptables -t nat -F openshift-prerouting
iptables -t nat -X openshift-prerouting
