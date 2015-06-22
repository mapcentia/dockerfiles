#!/bin/bash
set -e

if [ -n "$LOGSTASH_IP" ]; then
  openssl req -x509 -batch -nodes -newkey rsa:2048 -days 3650 \
      -keyout /certs/logstash.key \
      -out /certs/logstash.crt \
      -reqexts SAN \
      -config <(cat /etc/ssl/openssl.cnf \
          <(printf "[SAN]\nsubjectAltName=IP:$LOGSTASH_IP"))

  exec "$@"
elif [ -n "$LOGSTASH_DOMAIN" ]; then
  openssl req -x509 -batch -nodes -newkey rsa:2048 -days 3650 \
      -keyout /certs/logstash.key \
      -out /certs/logstash.crt \
      -subj /CN=$LOGSTASH_DOMAIN

  exec "$@"
else
  echo "Need to set IP or DOMAIN env var"
  exit 1
fi