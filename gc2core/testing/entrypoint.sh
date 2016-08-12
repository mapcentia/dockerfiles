#!/bin/bash
set -e

if [ -n "$NR_INSTALL_KEY" ]; then
    echo "Enabling APM metrics for ${NR_APP_NAME}"
    newrelic-install install

    # Update the application name
    sed -i "s/newrelic.appname = \"PHP Application\"/newrelic.appname = \"${NR_APP_NAME}\"/" /etc/php5/fpm/conf.d/newrelic.ini
fi

# If container is run without commando, then check if pgsql pw for gc2 is passed.
if [ $1 == "/usr/bin/supervisord" ]; then
    if [ -n "$GC2_PASSWORD" ]; then
      sed -i "s/YOUR_PASSWORD/$GC2_PASSWORD/g" /var/www/geocloud2/app/conf/Connection.php
    else
      echo '
            ****************************************************
            ERROR:   No password has been set for the GC2 user.
                     Use "-e GC2_PASSWORD=password" to set
                     it in "docker run".
            ****************************************************
            '
        exit 1
    fi
fi

chown www-data:www-data /var/www/geocloud2/app/tmp/ &&\
chown www-data:www-data /var/www/geocloud2/app/wms/mapfiles/ &&\
chown www-data:www-data /var/www/geocloud2/app/wms/cfgfiles/ &&\
chown www-data:www-data /var/www/geocloud2/app/wms/mapcache/ &&\
chown www-data:www-data /var/www/geocloud2/app/wms/sqlitefiles/ &&\
chown www-data:www-data /var/www/geocloud2/app/wms/files/ &&\
chown www-data:www-data /var/www/geocloud2/public/logs/

# Set time zone if passed
if [ -n "$TIMEZONE" ]; then
    echo $TIMEZONE | tee /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata
fi
exec "$@"