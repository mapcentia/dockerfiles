#!/bin/bash
set -e

# Set time zone if passed
if [ -n "$TIMEZONE" ]; then
    echo $TIMEZONE | tee /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata
    echo "TimeZone = '$TIMEZONE'" >> /etc/postgresql/9.4/main/postgresql.conf
fi
exec "$@"