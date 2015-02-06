# MapCentia GC2 Dockerfile

A complete platform for managing geospatial data, making map visualisations and creating applications. Built on the best open source and standard based software.

## How to use this image

The Docker image comes with Elasticsearch and PostGreSQL with a template database. 

First start PostGreSQL and Elasticsearch.

PostGreSQL:

    sudo docker run --name gc2_postgres -d mapcentia/gc2 sudo -u postgres /usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf -D FOREGROUND

Elasticsearch:

    sudo docker run --name gc2_elasticsearch -d -t mapcentia/gc2 /usr/share/elasticsearch/bin/elasticsearch -D FOREGROUND

When start the HTTP server with links to the PostGreSQL and Elasticsearch containers. You can map port 80 inside the container to any port on your local host. Here is local post 80 mapped to port 80 inside the container.

    sudo docker run --name gc2_apache2 --link gc2_elasticsearch:gc2_elasticsearch --link gc2_postgres:gc2_postgres -p 80:80 -d -t mapcentia/gc2 /root/run-apache.sh -D FOREGROUND

Then browse to 127.0.0.1

Enjoy!

![MapCentia](http://www.mapcentia.com/images/__od/863/mapcentialogo.png)

http://www.mapcentia.com/en/geocloud/