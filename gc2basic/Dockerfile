FROM ubuntu:trusty
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

RUN echo "deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ trusty main multiverse" >> /etc/apt/sources.list

# Install packages
RUN apt-get -y update
RUN apt-get -y install wget php5-mapscript g++ build-essential apache2-mpm-worker libapache2-mod-fastcgi libapache2-mod-python php5-fpm php5 php5-pgsql php5-curl gdal-bin python-paste python-flup python-imaging git php5-gd python-boto php5-cli unzip python-software-properties rng-tools apache2-utils npm postgresql-client supervisor

# Add some projections to Proj4
RUN echo "<900913> +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs <>" >> /usr/share/proj/epsg && \
	echo "<34004> +proj=omerc +lonc=11.81 +lat_0=55.3333332 +x_0=-118947.024 +y_0=101112.545 +k=0.9999855 +alpha=1.190005 +gamma=0.0 +datum=WGS84" >> /usr/share/proj/epsg && \
	echo "<34005> +proj=omerc +lonc=11.81 +lat_0=55.3333332 +x_0=-118947.024 +y_0=101112.545 +k=0.9999855 +alpha=1.190005 +gamma=0.0 +datum=WGS84" >> /usr/share/proj/epsg

# Install Node.js and Grunt
RUN npm install -g grunt-cli &&\
	ln -s /usr/bin/nodejs /usr/bin/node

# Clone GC2 from GitHub
RUN cd /var/www/ &&\
	git clone http://github.com/mapcentia/geocloud2.git

# Make dirs writeable for web server
RUN chown www-data:www-data /var/www/geocloud2/app/tmp/ &&\
	chown www-data:www-data /var/www/geocloud2/app/wms/mapfiles/ &&\
	chown www-data:www-data /var/www/geocloud2/app/wms/cfgfiles/ &&\
	chown www-data:www-data /var/www/geocloud2/public/logs/

# Install npm packages run Grunt
RUN	cd /var/www/geocloud2 &&\
	npm install &&\
	grunt production

# Add the custom config files from the Docker repo.
ADD conf/gc2/App.php /var/www/geocloud2/app/conf/
ADD conf/gc2/Connection.php /var/www/geocloud2/app/conf/

# Add custom front-controller
ADD index.php /var/www/geocloud2/public/

# Make php-fpm run in the foreground
RUN sed 's/;daemonize = yes/daemonize = no/' -i /etc/php5/fpm/php-fpm.conf

# Add MapScript module to php.ini
RUN echo "extension=php_mapscript.so" >> /etc/php5/fpm/php.ini

# Add apache config file from Docker repo
ADD conf/apache/000-default.conf /etc/apache2/sites-enabled/

# Enable Apache2 modules
RUN a2enmod rewrite headers expires include actions fastcgi alias cgid ssl

# create dir for certs
RUN mkdir /etc/apache2/ssl

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Share dirs
VOLUME  ["/var/www/geocloud2", "/var/log", "/etc/apache2/ssl", "/etc/apache2/sites-enabled/", "/usr/share/proj"]

# Expose standard ports for HTTP and HTTPS
EXPOSE 80
EXPOSE 443

# Add Supervisor config and run the deamon
ADD conf/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]