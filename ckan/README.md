#CKAN

    sudo docker create --name ckan-data mapcentia/ckan
    
    sudo docker run \
        --rm -i \
        -v $PWD:/tmp mapcentia/ckan cp /etc/ckan /tmp -R

        
    sudo docker create \
        --name ckan \
        --link solr:solr \
        --link postgis:postgres \
        -e PGUSER=gc2 \
        -e PGPASSWORD=xxxxx \
        -e LOCALE=da_DK.UTF-8 \
        --volumes-from ckan-data \
        -v $PWD/ckan:/etc/ckan \
        -e "VIRTUAL_HOST=" \
        -e "LETSENCRYPT_HOST=" \
        -e "LETSENCRYPT_EMAIL=" \
        -t mapcentia/ckan
        
paster sysadmin add $CKANADMINUSERNAME email=$CKANADMINUSEREMAIL name=$CKANADMINUSERNAME -c /etc/ckan/default/production.ini

      
