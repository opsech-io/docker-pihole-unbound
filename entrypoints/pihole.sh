#!/bin/bash

# Translate DNS names in DNS1 and DNS2 vars to their IPs
DNS_VARS=( ${!DNS*} )
for ip_ref in "${DNS_VARS[@]}"; do
    echo ip_ref "${!ip_ref}"
    if [[ ! "${!ip_ref}" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        eval export "${ip_ref}"="$( getent hosts "${!ip_ref}" | cut -d' ' -f1 )"
    fi
done

export ServerIP="${ServerIP:-0.0.0.0}"
printf "%s\n" "DNS1: ${DNS1}"  "DNS2: ${DNS2}" "ServerIP: ${ServerIP}"

#Add some stuff to setupVars.conf
cat <<EOF >> /etc/pihole/setupVars.conf
TEMPERATUREUNIT=F
EOF

# Force dnsmasq to not read /etc/hosts, otherwise pi.hole resolves to docker container IP
cat <<EOF >> /etc/dnsmasq.d/02-no-hosts.conf
no-hosts
EOF


# Original ENTRYPOINT
if [[ -f /s6-init ]]; then
    exec /s6-init
else
    exec /init # old entrypoint
fi
