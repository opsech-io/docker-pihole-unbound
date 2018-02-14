#!/bin/sh
set -e

/usr/sbin/unbound-checkconf

/usr/sbin/unbound-control-setup -d /etc/unbound/

# This won't work if --dns=127.0.0.1 (bootstrapping problems)
# /etc/periodic/monthly/update-unbound-root-hints

# From CentOS but not sure how to do on alpine..
/usr/sbin/unbound-anchor -v4 \
    -a /usr/share/dnssec-root/trusted-key.key \
    -r /etc/unbound/root.hints

exec "$@"
