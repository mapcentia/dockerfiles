#!/bin/bash
set -e

# If container is run without commando, then check if pgsql pw for gc2 is passed.
if [ $1 == "/usr/bin/supervisord" ]; then
    if [ -n "$GC2_PASSWORD" ]; then
      sed -i "s/YOUR_PASSWORD/$GC2_PASSWORD/g" /var/www/geocloud2/app/conf/Connection.php
      echo "
*************************************************************
Info:    PostgreSQL password set in
         geocloud2/app/conf/Connection.php
*************************************************************"
    else
      echo "
*************************************************************
WARNING: No PostgreSQL password has been set for the GC2 user.
         You set this in geocloud2/app/conf/Connection.php
*************************************************************"
    fi
fi

chown www-data:www-data /var/www/geocloud2/app/tmp/ &&\
chown www-data:www-data /var/www/geocloud2/app/wms/mapfiles/ &&\
chown www-data:www-data /var/www/geocloud2/app/wms/mapcache/ &&\
chown www-data:www-data /var/www/geocloud2/app/wms/files/ &&\
chown www-data:www-data /var/www/geocloud2/app/wms/qgsfiles/ &&\
chown www-data:www-data /var/www/geocloud2/public/logs/ &&\
chmod 737 /var/lib/php/sessions
chmod +t /var/lib/php/sessions # Sticky bit

# Set time zone if passed
if [ -n "$TIMEZONE" ]; then
    echo $TIMEZONE | tee /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata
fi

export CONTAINER_ID=$(cat /proc/1/cpuset | cut -c9-)

exec "$@"