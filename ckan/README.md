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
      