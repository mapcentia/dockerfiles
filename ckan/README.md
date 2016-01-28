#CKAN

    sudo docker run \
        --rm -i \
        -v ~:/tmp mapcentia/ckan cp /etc/ckan /tmp -R

        
    sudo docker run \
        --name ckan \
        --restart=always \
        -v ~/ckan:/etc/ckan \
        -p 80:80 \
        -d -t mapcentia/ckan