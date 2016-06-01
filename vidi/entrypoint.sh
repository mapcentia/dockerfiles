#!/bin/bash
set -e

# Set time zone if passed
if [ -n "$TIMEZONE" ]; then
    echo $TIMEZONE | tee /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata
fi
exec "$@"