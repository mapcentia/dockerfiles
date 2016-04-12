#CKAN

    sudo docker run \
        --rm -i \
        -v $PWD:/tmp mapcentia/ckan cp /etc/ckan /tmp -R

        
    sudo docker run \
        --name ckan \
        --restart=always \
        --link solr:solr \
        --link postgis:postgres \
        -e PGUSER=gc2 \
        -e PGPASSWORD=1234 \
        -e LOCALE=da_DK.UTF-8 \
        -v $PWD/ckan:/etc/ckan \
        -p 7777:8080 \
        -d -t mapcentia/ckan
      
      
      
    docker run \
        --name ckan_river \
        -e PGPASSWORD=1234 \
        --link gc2core:gc2core \
        --link postgis:postgis \
        --volumes-from gc2core \
        -d -t mapcentia/gc2core \
        nodejs /var/www/geocloud2/app/scripts/meta2ckan.js [db] --host postgis --user gc2 --ckan-host gc2core --gc2-host "http://example.com" --key [apikey]