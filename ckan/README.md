#CKAN

    sudo docker create --name ckan-data mapcentia/ckan
    
    sudo docker run \
        --rm -i \
        -v $PWD:/tmp mapcentia/ckan cp /etc/ckan /tmp -R

        
    sudo docker run \
        --rm \
        --link solr:solr \
        --link postgis:postgres \
        -e PGUSER=gc2 \
        -e PGPASSWORD=1234 \
        -e LOCALE=da_DK.UTF-8 \
        --volumes-from ckan-data \
        -v $PWD/ckan:/etc/ckan \
        -p 7777:8080 \
        -i -t mapcentia/ckan
      
