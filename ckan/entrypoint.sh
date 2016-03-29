#!/bin/bash
set -e

PWD=$(apg -a 0 -n 1)
sed -i "s/gc2:1234/ckan_default:$PWD/g" /etc/ckan/default/production.ini
psql postgres --host postgres -c "CREATE USER ckan_default PASSWORD '$PWD'"
createdb --host postgres -O ckan_default ckan_default -T template0 --encoding UTF-8 --locale da_DK.UTF-8
ckan db init

exec "$@"