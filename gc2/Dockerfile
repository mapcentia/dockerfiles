FROM ubuntu:trusty

RUN apt-get update

# Install packages
RUN apt-get -y install wget curl php5 postgis php5-pgsql php5-mapscript php5-curl libapache2-mod-python python-mapscript gdal-bin python-paste python-flup python-imaging git php5-gd python-boto php5-cli unzip postgresql-9.3-postgis-2.1 postgresql-contrib-9.3 python-software-properties rng-tools apache2-utils npm openjdk-7-jre-headless supervisor

# Fix install for openjdk-7-jre-headless
RUN apt-get -f install

# Enable Apache2 modules
RUN a2enmod rewrite headers expires include actions alias

# Install Node.js, Grunt and Forever
RUN npm install -g grunt-cli &&\
	npm install -g forever &&\
	ln -s /usr/bin/nodejs /usr/bin/node

# Get and install Elasticsearch
RUN cd ~ && wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.2.deb
RUN cd ~ && dpkg -i elasticsearch-1.4.2.deb
RUN update-rc.d elasticsearch defaults 95 10

# Clone GC2 from GitHub
RUN cd /var/www/ &&\
	git clone http://github.com/mapcentia/geocloud2.git

# Add config files from Docker repo
ADD conf/apache/000-default.conf /etc/apache2/sites-enabled/
ADD conf/apache/run-apache.sh /root/
ADD conf/postgresql/pg_hba.conf /etc/postgresql/9.3/main/
ADD conf/gc2/geometry_columns_join.sql /var/www/geocloud2/public/install/

# Script for starting Apache2 and removing incompletely-shutdown httpd pids
RUN chmod +x /root/run-apache.sh

# Copy GC2 config files from GIT repo
RUN cp /var/www/geocloud2/app/conf/App.php.dist /var/www/geocloud2/app/conf/App.php
RUN cp /var/www/geocloud2/app/conf/Connection.php.dist /var/www/geocloud2/app/conf/Connection.php

# Create template database and run migrations
RUN service postgresql start && \
    createdb template_geocloud -T template0 -E UTF8 -U postgres &&\
	psql template_geocloud -c "create extension postgis" -U postgres &&\
	psql template_geocloud -c "create extension pgcrypto" -U postgres &&\
	createdb mapcentia -U postgres &&\
	psql mapcentia -c "CREATE TABLE users\
		(screenname character varying(255),\
  		pw character varying(255),\
  		email character varying(255),\
  		zone character varying,\
  		parentdb varchar(255),\
  		created timestamp with time zone DEFAULT ('now'::text)::timestamp(0) with time zone)" -U postgres &&\
	psql template_geocloud -f /var/www/geocloud2/public/install/geometry_columns_join.sql -U postgres &&\
	cd /var/www/geocloud2/app/conf/migration/ && ./run

# Make dirs writeable for web server 
RUN chown www-data:www-data /var/www/geocloud2/app/tmp/ &&\
	chown www-data:www-data /var/www/geocloud2/app/wms/mapfiles/ &&\
	chown www-data:www-data /var/www/geocloud2/app/wms/cfgfiles/

# Add user for starting PostGreSQL
RUN mkdir /home/postgres && chown postgres:postgres /home/postgres

# Add the 900913 projection to Proj4
RUN echo "<900913> +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs <>" >> /usr/share/proj/epsg

# Install npm packages run Grunt
RUN	cd /var/www/geocloud2 &&\
	npm install &&\
	grunt

# Add the custom config files.  
ADD conf/gc2/App.php /var/www/geocloud2/app/conf/
ADD conf/gc2/Connection.php /var/www/geocloud2/app/conf/

# Make config in PostGreSQL
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Expose standard ports for HTTP, PostGreSQL and Elasticsearch
EXPOSE 80
EXPOSE 5432
EXPOSE 9200

VOLUME  ["/var/www/geocloud2/public/logs" ]

# Add Supervisor config and run the deamon
ADD conf/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]