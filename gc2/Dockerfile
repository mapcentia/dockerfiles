FROM ubuntu:trusty

RUN apt-get update

RUN apt-get -y install wget curl php5 postgis php5-pgsql php5-mapscript php5-curl libapache2-mod-python python-mapscript gdal-bin python-paste python-flup python-imaging git php5-gd python-boto php5-cli unzip postgresql-9.3-postgis-2.1 postgresql-contrib-9.3 python-software-properties rng-tools apache2-utils npm openjdk-7-jre-headless

RUN apt-get -f install

RUN a2enmod rewrite headers expires include actions alias

RUN cd /var/www/ &&\
	git clone http://github.com/mapcentia/geocloud2.git

RUN cd ~ && wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.deb
RUN cd ~ && dpkg -i elasticsearch-1.1.1.deb
RUN update-rc.d elasticsearch defaults 95 10

ADD conf/apache/000-default.conf /etc/apache2/sites-enabled/
ADD conf/apache/run-apache.sh /root/
ADD conf/postgresql/pg_hba.conf /etc/postgresql/9.3/main/
ADD conf/gc2/geometry_columns_join.sql /var/www/geocloud2/public/install/
ADD conf/gc2/Connection.php /var/www/geocloud2/app/conf/

RUN chmod +x /root/run-apache.sh

RUN cp /var/www/geocloud2/app/conf/App.php.dist /var/www/geocloud2/app/conf/App.php
RUN cp /var/www/geocloud2/app/conf/Connection.php.dist /var/www/geocloud2/app/conf/Connection.php


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

RUN chown www-data:www-data /var/www/geocloud2/app/tmp/ &&\
	chown www-data:www-data /var/www/geocloud2/app/wms/mapfiles/ &&\
	chown www-data:www-data /var/www/geocloud2/app/wms/cfgfiles/

RUN mkdir /home/postgres && chown postgres:postgres /home/postgres

RUN echo "<900913> +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs <>" >> /usr/share/proj/epsg

#RUN npm install -g grunt-cli &&\
#	ln -s /usr/bin/nodejs /usr/bin/node &&\
#	cd /var/www/geocloud2 &&\
#	npm install &&\
#	grunt

ADD conf/gc2/App.php /var/www/geocloud2/app/conf/
ADD conf/gc2/Connection.php /var/www/geocloud2/app/conf/
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

EXPOSE 80
EXPOSE 5432
EXPOSE 9200

#VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
VOLUME  ["/var/lib/postgresql"]

#CMD service apache2 start && service postgresql start && service elasticsearch start && curl http://127.0.0.1/install/installmy.php?db=template_geocloud && cd /var/www/geocloud2/app/conf/migration/ && ./run && tail -f /var/log/apache2/access.log
