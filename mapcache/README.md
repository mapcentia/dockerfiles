# MapCache
Run container

    sudo docker run \
        --rm \
        -p 8080:80 \
        -p 1337:1337 \
        -v /var/www/geocloud2:/var/www/geocloud2 \
        -i -t mapcentia/mapcache
        
        
    sudo docker run \
            --name mapcache \
            -p 8080:80 \
            -p 1337:1337 \
            -v /var/www/geocloud2:/var/www/geocloud2 \
            -d -t mapcentia/mapcache
            
    sudo docker run \
            --rm \
            --volumes-from=mapcache \
            -v /var/www/geocloud2:/var/www/geocloud2 \
            -i -t mapcentia/mapcache bash