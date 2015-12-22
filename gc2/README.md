# MapCentia GC2 Dockerfile

A complete platform for managing geospatial data, making map visualisations and creating applications. Built on the best open source and standard based software.

This image is not for production use. Use it for easy testing and evaluating of GC2. It allows anyone with a Docker host (on their laptop, on a VM in the cloud, etc.) to, with a single command, run a single node of GC2 technology.


For production use, check out the gc2core image.


## How to use this image

The Docker image comes with HTTP server, Elasticsearch and PostGreSQL including a template database. 

Just run a container like this:

    sudo docker run \
        --name gc2 \
        -p 80:80 \
        -t -d \
        mapcentia/gc2

You can map port 80 inside the container to any port on your local host. Here is host port 80 mapped to port 80 inside the container.

### Optional
#### Make changes to the configuration
You can edit the GC2 configuration by starting an other container with volumes mounted from the GC2 container like this:

    sudo docker run \
        --volumes-from=gc2 \
        --rm=true \
        -t -i \
        mapcentia/gc2 \
        /bin/bash
    
And when on the command line of the container, edit the file:
    
    /var/www/geocloud2/app/conf/App.php
    
#### PostGIS to Elasticsearch in real-time
Start a daemon that makes data flow from PostGIS to Elasticsearch in real-time. A daemon has to be started for every database:

	sudo docker run \
	    --name gc2_river \
	    --link gc2:gc2 \
	    -d -t mapcentia/gc2 \
	    nodejs /var/www/geocloud2/app/scripts/pg2es.js [database] --host gc2 --es-host gc2 --key [api key]

And tail the flow of data to Elasticsearch:

	sudo docker run \
	    --volumes-from gc2_river \
	    --rm=true \
	    -i -t mapcentia/gc2  \
	    tail -f /var/www/geocloud2/public/logs/pg2es.log

#### Manage the database
You can login to PostGreSQL from a command line like this:
    
    sudo docker run \
        --link gc2:gc2 \
        --rm=true \
        -i -t mapcentia/gc2 \
        psql --host gc2 --user postgres [database]
    

![MapCentia](https://geocloud.mapcentia.com/assets/images/MapCentia_geocloud_200.png)

[www.mapcentia.com/en/geocloud](http://www.mapcentia.com/en/geocloud/)