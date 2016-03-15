#CKAN

    sudo docker run \
        --rm -i \
        -v ~:/tmp mapcentia/ckan cp /etc/ckan /tmp -R

        
    sudo docker run \
        --name ckan \
        --restart=always \
        --link solr:solr \
        --link postgis:postgres \
        -v $PWD/ckan:/etc/ckan \
        -p 7777:8080 \
        -d -t mapcentia/ckan
        
    docker run \
        --rm \
        --link solr:solr \
        --link postgis:postgres \
        --volumes-from ckan \
        -i -t mapcentia/ckan bash