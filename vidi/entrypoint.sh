#!/bin/bash
set -e

# If container is run without commando, then check if config settings is passed.
if [ $1 == "/usr/bin/supervisord" ]; then
    if [ -n "$BACKEND" ]; then
      sed -i "s/WHAT_BACKEND/$BACKEND/g" /root/vidi/config/config.js
      echo '
            ****************************************************
            INFO:    Backend set to $BACKEND.
            ****************************************************
            '
    fi
fi
exec "$@"