#!/bin/bash
set -e

if [ $1 == "/run-apache.sh" ]; then
    # But first we check if they are created. I.e. if the container is restarted
    if echo 'SELECT 1' | psql ckan_default --host postgres  >/dev/null 2>&1; then
        echo '
                ****************************************************
                INFO:   ckan_default db already initiated.
                        Doing nothing else than start the service.
                ****************************************************
            '
    else
        PWD=$(apg -a 0 -n 1)
        sed -i "s/ckan_default:1234/ckan_default:$PWD/g" /etc/ckan/default/production.ini
        psql postgres --host postgres -c "CREATE USER ckan_default PASSWORD '$PWD'"
        createdb --host postgres -O ckan_default ckan_default -T template0 --encoding UTF-8 --locale $LOCALE
    fi
    . /usr/lib/ckan/default/bin/activate &&\
            pip install ckanext-geoview
    ckan db init
fi
exec "$@"