#!/bin/sh
set -e

export HOSTNAME=$(echo "$VCAP_APPLICATION" | jq '.application_uris|@csv' | tr -d '"' | tr -d '\\')

if [ -z $HOSTNAME ]; then
  export HOSTNAME="localhost"
fi

echo "Amending configuration for ${HOSTNAME}..."

echo "http_port 80 accel defaultsite=${HOSTNAME} no-vhost" >> /etc/squid/squid.conf \
 && echo "cache_peer ${DESTINATION} parent 80 0 no-query originserver name=myAccel" >> /etc/squid/squid.conf \
 && echo "acl our_sites dstdomain ${HOSTNAME}" >> /etc/squid/squid.conf \
 && echo "http_access allow our_sites" >> /etc/squid/squid.conf \
 && echo "cache_peer_access myAccel allow our_sites" >> /etc/squid/squid.conf \
 && echo "cache_peer_access myAccel deny all" >> /etc/squid/squid.conf \
 && echo "pid_filename /var/run/squid/squid.pid" >> /etc/squid/squid.conf

echo "Initializing cache..."
$(which squid) -N -f /etc/squid/squid.conf -z

echo "Starting squid..."
exec $(which squid) -f /etc/squid/squid.conf -NYCd 1 ${EXTRA_ARGS}
