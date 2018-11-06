#!/bin/bash
inotify-hookable --no-r -d --watch-directories /var/www/geocloud2/app/wms/mapcache -c '/usr/bin/node reload.js'
