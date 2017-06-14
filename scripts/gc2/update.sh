#!/bin/bash

docker run \
        --rm \
        --net gc2net \
        --volumes-from=gc2core \
        --link postgis:postgis \
        -t -i mapcentia/gc2core grunt --gruntfile /var/www/geocloud2/Gruntfile.js production