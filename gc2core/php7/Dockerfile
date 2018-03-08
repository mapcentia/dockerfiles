FROM mapcentia/gc2core:gdal
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN export DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Install MapServer 7.0.6 from source
RUN wget http://download.osgeo.org/mapserver/mapserver-7.0.6.tar.gz &&\
	tar -zxvf mapserver-7.0.6.tar.gz &&\
	cd mapserver-7.0.6 &&\
	mkdir build &&\
	cd build &&\
	cmake -DCMAKE_INSTALL_PREFIX=/opt \
    -DCMAKE_PREFIX_PATH=/usr/local/pgsql/94:/usr/local:/opt:/usr/include \
    -DWITH_CLIENT_WFS=ON \
    -DWITH_CLIENT_WMS=ON \
    -DWITH_CURL=ON \
    -DWITH_SOS=ON \
    -DWITH_PHP=OFF \
    -DWITH_PYTHON=ON \
    -DWITH_ORACLESPATIAL=0 \
    -DWITH_RSVG=ON \
    -DWITH_SVGCAIRO=0 .. &&\
    make && make install

RUN cp /mapserver-7.0.6/build/mapserv /usr/lib/cgi-bin/mapserv.fcgi

# Install rar
RUN pecl install rar &&\
	echo "extension=rar.so" >> /etc/php/7.0/fpm/php.ini

# Add some projections to Proj4
RUN echo "<900913> +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs <>" >> /usr/share/proj/epsg && \
	echo "<34004> +proj=omerc +lonc=11.81 +lat_0=55.3333332 +x_0=-118947.024 +y_0=101112.545 +k=0.9999855 +alpha=1.190005 +gamma=0.0 +datum=WGS84" >> /usr/share/proj/epsg && \
	echo "<34005> +proj=omerc +lonc=11.81 +lat_0=55.3333332 +x_0=-118947.024 +y_0=101112.545 +k=0.9999855 +alpha=1.190005 +gamma=0.0 +datum=WGS84" >> /usr/share/proj/epsg

# Install Node.js, Grunt and Forever
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install -y nodejs

RUN npm install -g grunt-cli

# Clone GC2 from GitHub
RUN cd /var/www/ &&\
	git clone http://github.com/mapcentia/geocloud2.git --branch php7

# Install npm packages run Grunt
RUN	cd /var/www/geocloud2 &&\
	npm install &&\
	grunt production --force

# Add the custom config files from the Docker repo.
ADD conf/gc2/App.php /var/www/geocloud2/app/conf/
ADD conf/gc2/Connection.php /var/www/geocloud2/app/conf/

# Make php-fpm run in the foreground
RUN sed 's/;daemonize = yes/daemonize = no/' -i /etc/php/7.0/fpm/php-fpm.conf

# Add apache config file from Docker repo
ADD conf/apache/000-default.conf /etc/apache2/sites-enabled/
ADD conf/apache/gc2 /etc/apache2/sites-enabled/gc2
ADD conf/apache/000-default-le-ssl.conf /etc/apache2/sites-available/
ADD conf/apache/options-ssl-apache.conf /etc/apache2/ssl/

# Add php-fpm config file from Docker repo
ADD conf/fpm/www.conf /etc/php/7.0/fpm/pool.d/www.conf

# Enable Apache2 modules
RUN a2enmod rewrite headers expires include actions alias cgid fcgid ssl proxy proxy_http proxy_ajp proxy_balancer proxy_connect proxy_html xml2enc proxy_wstunnel proxy_fcgi http2
RUN a2enconf serve-cgi-bin

# Share dirs
VOLUME  ["/var/www/geocloud2","/etc/apache2","/etc/php/7.0/fpm","/var/log", "/usr/share/proj"]

# Expose standard ports for HTTP and HTTPS
EXPOSE 80
EXPOSE 443

# Add the check-if-fpm-is-alive script
COPY check-fpm.sh /check-fpm.sh
RUN chmod +x /check-fpm.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

ADD conf/apache/run-apache.sh /
RUN chmod +x /run-apache.sh

ADD conf/apache/run-fpm.sh /
RUN chmod +x /run-fpm.sh

# Startrt fpm, so dirs are created
RUN service php7.0-fpm start

# Add Supervisor config and run the deamon
ADD conf/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]