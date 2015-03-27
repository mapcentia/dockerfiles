# MapCentia GC2 Dockerfile

A complete platform for managing geospatial data, making map visualisations and creating applications. Built on the best open source and standard based software.

## How to use this image

The Docker image comes with HTTP server, Elasticsearch and PostGreSQL including a template database. 


Just run a container like this.

    sudo docker run --name gc2 -p 80:80 -t -d mapcentia/gc2

You can map port 80 inside the container to any port on your local host. Here is host port 80 mapped to port 80 inside the container.

### Optional
Start a daemon that makes data flow from PostGIS to Elasticsearch in real-time.

	sudo docker run --name gc2_river --link gc2:gc2 -d -t mapcentia/gc2 nodejs /var/www/geocloud2/app/scripts/pg2es.js [database] --host gc2 --es-host gc2 --key [api key]

And tail the flow of data to Elasticsearch.

	sudo docker run --volumes-from gc2_river -i -t mapcentia/gc2  tail -f /var/www/geocloud2/public/logs/pg2es.log

You can login to PostGreSQL like this.
    
    sudo docker run --link gc2:gc2 -i -t mapcentia/gc2 psql --host gc2 --user postgres [database]

![MapCentia](https://geocloud.mapcentia.com/assets/images/MapCentia_geocloud_200.png)

http://www.mapcentia.com/en/geocloud/