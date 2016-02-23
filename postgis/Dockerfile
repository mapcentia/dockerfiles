FROM ubuntu:xenial
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update --fix-missing
RUN apt-get -y install vim git php5-pgsql php5-cli wget curl postgis postgresql-9.5-postgis-2.2 postgresql-contrib-9.5 postgresql-9.5-pgrouting

# Clone GC2 from GitHub
RUN mkdir /var/www &&\
	cd /var/www/ &&\
	git clone http://github.com/mapcentia/geocloud2.git

# Add config files from Docker repo
ADD conf/postgresql/pg_hba.conf /etc/postgresql/9.5/main/
ADD conf/gc2/geometry_columns_join.sql /var/www/geocloud2/public/install/

# Copy GC2 config files from GIT repo, so we can create the template database and run migrations
RUN cp /var/www/geocloud2/app/conf/App.php.dist /var/www/geocloud2/app/conf/App.php
RUN cp /var/www/geocloud2/app/conf/Connection.php.dist /var/www/geocloud2/app/conf/Connection.php

# Make config in PostGreSQL
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.5/main/postgresql.conf

# Expose standard for PostGreSQL
EXPOSE 5432

# Share volumes
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Use wrapper scripts to start Postgres
ADD start.sh /root/
RUN chmod 755 /root/start.sh
CMD ["/root/start.sh"]