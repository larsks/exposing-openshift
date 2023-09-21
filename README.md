This repository shows two ways of exposing OpenShift (or any Kubernetes environment) when it has been installed on a private network.

## Using netfilter

If you have a Linux system sitting between the private network and the public network you can arrange to forward traffic using [netfilter] rules. The configuration is relatively:

- We need to ensure that packet forwarding is enabled by setting the [`net.ipv4.ip_forward`][ip_forward] sysctl.
- We need to add rules to the `nat` `PREROUTING` table to rewrite the destination of incoming traffic to ports 80, 443, and 6443.
- We need to ensure that traffic forwarded is permitted by the `filter` `FORWARD` table.

[ip_forward]: https://sysctl-explorer.net/net/ipv4/ip_forward/
[netfilter]: https://www.netfilter.org/index.html

The [create_rules.sh](using-netfilter/create-rules.sh) script implements the necessary configuration.

## Using haproxy

We can configure [haproxy] as a TCP proxy to forward traffic to the private network. When haproxy is configured as a TCP proxy, it acts as a simple forwarder between the outside and inside networks. All http related logic -- such as SSL termination -- continues to be handled by OpenShift.

The files in [`using-haproxy-tcp`](using-haproxy-tcp) implement the necessary configuration. We're using [Podman] to run haproxy rather than installing the package onto the system.

[podman]: https://podman.io
[haproxy]: https://www.haproxy.org/

## What about haproxy in http mode?

It is also possible to configure haproxy in HTTP mode, but this introduces some complications:

- haproxy becomes responsible for SSL termination, which means we need to generate certificates that are different from those in use by OpenShift.
- We can no longer use certificate-based authentication to connect to the cluster; we can only use bearer tokens (because client certificates will be presented to and processed by haproxy; they will not be available to OpenShift).
