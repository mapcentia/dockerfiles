#!/bin/bash
set -e

if [ -n "$MASTER" ]; then
  sed -i "s/MASTER/$MASTER/g" /root/logstash-forwarder.conf
  exec "$@"
else
  echo "MASTER env var must be set."
  exit 1
fi