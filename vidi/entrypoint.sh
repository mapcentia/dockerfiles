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

    if [ -n "$LOCALE" ]; then
            locale=$LOCALE
        else
            locale=en_US.UTF-8
            echo '
                ****************************************************
                WARNING: No locale has been set for Vidi.
                         Setting it to en_US.UTF-8.
                         Use "-e locale=your_locale" to set
                         it in "docker run".
                ****************************************************
            '
    fi
    locale-gen $LOCALE
    dpkg-reconfigure locales
fi
exec "$@"