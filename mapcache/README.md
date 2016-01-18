# MapCache
Run container
        
    sudo docker run \
            --name mapcache \
            -p 8080:80 \
            -p 1337:1337 \
            --volumes-from=gc2core \
            --link gc2core:gc2core \
            -d -t mapcentia/mapcache
    
   sudo docker run \
           --rm \
           --volumes-from=gc2core \
           --link gc2core:gc2core \
           -i -t mapcentia/mapcache bash
            
                
    sudo docker run \
            --name mapcache \
            -p 8080:80 \
            -p 1337:1337 \
            -v /var/www/geocloud2/app:/var/www/geocloud2/app \
            -d -t mapcentia/mapcache
            
    sudo docker run \
            --rm \
            --volumes-from=mapcache \
            -v /var/www/geocloud2:/var/www/geocloud2 \
            -i -t mapcentia/mapcache bash