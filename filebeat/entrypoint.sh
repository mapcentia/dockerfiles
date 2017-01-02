#!/bin/bash
set -e

if [ -n "$MASTER" ]; then
  sed -i "s/MASTER/$MASTER/g" /etc/filebeat/filebeat.yml
  exec "$@"
else
  echo "MASTER env var must be set."
  exit 1
fi