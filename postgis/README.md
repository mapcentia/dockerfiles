sudo docker run \
    --name postgis \
    -p 5432:5432 \
    -e GC2_PASSWORD=T5uHenuc \
    -e LOCALE=da_DK.UTF-8 \
    -e TIMEZONE="Europe/London" \
    -t -d \
    mapcentia/postgis
    
sudo docker run \
    --rm \
    --volumes-from=postgis \
    --link postgis:postgis \
    -t -i \
    mapcentia/postgis psql gc2scheduler -U gc2 -h postgis