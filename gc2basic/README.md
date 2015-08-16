sudo docker run \
    --name gc2min \
    --link postgis:postgis \
    -v ~/conf:/var/www/geocloud2/app/conf \
    -e TIMEZONE="Europe/Copenhagen" \
    -p 80:80 \
    -d -t \
    mapcentia/gc2min

docker run --rm --volumes-from=gc2core -t -i mapcentia/gc2core /bin/bash

docker run --rm -i -v ~/:/tmp mapcentia/gc2core cp /var/www/geocloud2/app/conf /tmp -R


docker run --rm --volumes-from=gc2core --link postgis:postgis -t -i mapcentia/gc2core grunt --gruntfile /var/www/geocloud2/Gruntfile.js production