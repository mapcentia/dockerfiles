sudo docker run \
    --name gc2core \
    --link postgis:postgis \
    --link elasticsearch:elasticsearch \
    --link geoserver:geoserver \
    -v ~/ssl:/etc/apache2/ssl \
    -v ~/sites-enabled:/etc/apache2/sites-enabled/ \
    -v ~/conf:/var/www/geocloud2/app/conf \
    -v ~/tmp:/var/www/geocloud2/app/tmp \
    -e GC2_PASSWORD=xxxxxx \
    -e TIMEZONE="Europe/Copenhagen" \
    -p 80:80 -p 443:443 \
    -d -t \
    mapcentia/gc2core

docker run --rm=true --volumes-from=gc2core --link postgis:postgis -t -i mapcentia/gc2core /bin/bash


/path/to/openssl rsa -in /path/to/originalkeywithpass.key -out /path/to/newkeywithnopass.key


docker run --rm -i -v ~/:/tmp mapcentia/gc2core cp /etc/apache2/sites-enabled /tmp -R
docker run --rm -i -v ~/:/tmp mapcentia/gc2core cp /var/www/geocloud2/app/conf /tmp -R

sudo docker run \
        --name gc2river \
        -e PGPASSWORD=naTH7crU \
        --link gc2core:gc2core \
        --link postgis:postgis \
        -i -t mapcentia/gc2core \
        nodejs /var/www/geocloud2/app/scripts/pg2es.js furesoe --host postgis --user gc2 --es-host gc2core --key cdde733d7eec8e37492ab242f155b3c8