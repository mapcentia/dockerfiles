# MapCache
Run container

    sudo docker run \
        --rm \
        --net=host \
        -v /var/www/geocloud2:/var/www/geocloud2 \
        -i -t mapcentia/mapcache