FROM mapcentia/gc2core:gdal
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN export DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Set php session timeout to one day
RUN sed -i "s/session.gc_maxlifetime = 1440/session.gc_maxlifetime = 86400/g" /etc/php/7.0/fpm/php.ini

# Install MapServer 7.4 from source
RUN git clone https://github.com/mapserver/mapserver.git --branch branch-7-4 &&\
    cd mapserver &&\
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

RUN cp /mapserver/build/mapserv /usr/lib/cgi-bin/mapserv.fcgi

# Install QGIS-server
RUN echo "deb http://qgis.org/debian stretch main" >> /etc/apt/sources.list &&\
    wget -O - https://qgis.org/downloads/qgis-2019.gpg.key | gpg --import --batch &&\
    gpg --fingerprint 51F523511C7028C3 &&\
    gpg --export --armor 51F523511C7028C3 | apt-key add - &&\
    apt-get update &&\
    apt-get -y install qgis-server

# Symlink font for QGIS Server
RUN ln -s /usr/share/fonts directory /usr/lib/x86_64-linux-gnu

# Add some projections to Proj4
RUN echo "<900913> +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs <>" >> /usr/share/proj/epsg && \
	echo "<34004> +proj=omerc +lonc=11.81 +lat_0=55.3333332 +x_0=-118947.024 +y_0=101112.545 +k=0.9999855 +alpha=1.190005 +gamma=0.0 +datum=WGS84" >> /usr/share/proj/epsg && \
	echo "<34005> +proj=omerc +lonc=11.81 +lat_0=55.3333332 +x_0=-118947.024 +y_0=101112.545 +k=0.9999855 +alpha=1.190005 +gamma=0.0 +datum=WGS84" >> /usr/share/proj/epsg

# Instal MapCache
RUN cd ~ && \
    git clone http://github.com/mapserver/mapcache.git

RUN apt-get -y update  --fix-missing

RUN apt-get -y install apache2-dev

RUN cd ~ && \
    cd mapcache &&\
    mkdir build &&\
    cd build &&\
    cmake .. &&\
    make &&\
    make install &&\
    ldconfig

# Add the watch_mapcache_changes.sh
COPY watch_mapcache_changes.sh /watch_mapcache_changes.sh
RUN chmod +x /watch_mapcache_changes.sh

# Add the reload.js
COPY reload.js /reload.js

RUN curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh &&\
    bash nodesource_setup.sh &&\
    apt-get install -y nodejs

RUN mkdir /mapcache
RUN cp /root/mapcache/mapcache.xml /mapcache/

# Clone GC2 from GitHub
RUN cd /var/www/ &&\
	git clone http://github.com/mapcentia/geocloud2.git

# Install npm packages run Grunt
RUN	cd /var/www/geocloud2 &&\
	npm install &&\
	grunt production --force

RUN	mkdir -p /var/www/geocloud2/public/dashboard && mkdir /dashboardtmp && cd /dashboardtmp &&\
    git clone http://github.com/mapcentia/dashboard.git && cd /dashboardtmp/dashboard &&\
    npm install && cp ./app/config.js.sample ./app/config.js && cp ./.env.production ./.env &&\
    npm run build && cp -R ./build/* /var/www/geocloud2/public/dashboard/ &&\
    rm -R /dashboardtmp

# Add the custom config files from the Docker repo.
ADD conf/gc2/App.php /var/www/geocloud2/app/conf/
ADD conf/gc2/Connection.php /var/www/geocloud2/app/conf/

# Add apache config file from Docker repo
ADD conf/apache/000-default.conf /etc/apache2/sites-enabled/
ADD conf/apache/mapcache.conf /etc/apache2/sites-enabled/

# Add php-fpm config file from Docker repo
ADD conf/fpm/www.conf /etc/php/7.0/fpm/pool.d/www.conf

# Add the check-if-fpm-is-alive script
COPY check-fpm.sh /check-fpm.sh
RUN chmod +x /check-fpm.sh

ADD conf/apache/run-apache.sh /
RUN chmod +x /run-apache.sh

ADD conf/apache/run-fpm.sh /
RUN chmod +x /run-fpm.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Share dirs
VOLUME  ["/var/www/geocloud2","/etc/apache2","/etc/php/7.0/fpm","/var/log", "/usr/share/proj"]

# Expose standard ports for HTTP and HTTPS
EXPOSE 80
EXPOSE 443

# Add Supervisor config and run the deamon
ADD conf/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
