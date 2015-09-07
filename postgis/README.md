# PostGIS for use with GC2
This image is for decoupled setup of GC2. Chech out our GC2core image. When a container is started, the GC2 template and user databases are created.

PostGreSQL 9.4 and PostGIS 2.1

## How to use this image
Run a container. The GC2_PASSWORD is the password you want to assign to the PostGreSQL user "gc2", which has access from all hosts.

Leave -e TIMEZONE="..." to default to CEST and -e LOCALE= to default to en_US.UTF-8.

    sudo docker run \
        --name postgis \
        -p 5432:5432 \
        -e GC2_PASSWORD=xxxxxx \
        -e LOCALE=da_DK.UTF-8 \
        -e TIMEZONE="Europe/Copenhagen" \
        -t -d mapcentia/postgis
        
### Optional     
Accsess a database with psql.
    
    sudo docker run \
        --rm \
        --volumes-from=postgis \
        --link postgis:postgis \
        -t -i \
        mapcentia/postgis psql gc2scheduler -U [database] -h postgis