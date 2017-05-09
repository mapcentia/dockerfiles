FROM debian:stretch
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN export DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update  --fix-missing
RUN apt-get -y install cron vim wget  g++ build-essential git memcached unzip rng-tools apache2-utils postgresql-client supervisor netcat
RUN apt-get -y install apache2 php php-pgsql php-curl php-sqlite3 php-mbstring php-gd php-cli php-mbstring php-pear php-dev
RUN apt-get -y install cmake libgdal-dev librsvg2-dev libpng++-dev libjpeg-dev libfreetype6-dev libproj-dev libfribidi-dev libharfbuzz-dev libcairo2-dev
RUN apt-get -y install libgeos++-dev libpython-all-dev curl libapache2-mod-fcgid libfcgi-dev xvfb wkhtmltopdf qgis-server

# Add SQLite3 module to php.ini
RUN echo "extension=sqlite3.so" >> /etc/php/7.0/fpm/php.ini

# Install SWIG
RUN wget https://downloads.sourceforge.net/project/swig/swig/swig-3.0.12/swig-3.0.12.tar.gz &&\
    tar -zxvf swig-3.0.12.tar.gz &&\
    cd swig-3.0.12 &&\
    ./configure &&\
    make && make install

# Install ECW 3.3
RUN wget http://www.kyngchaos.com/files/macosxport/libecwj2-3.3-2006-09-06.zip &&\
	unzip libecwj2-3.3-2006-09-06.zip &&\
	wget http://trac.osgeo.org/gdal/raw-attachment/ticket/3162/libecwj2-3.3-msvc90-fixes.patch &&\
	patch -p0< libecwj2-3.3-msvc90-fixes.patch &&\
	wget http://osgeo-org.1560.x6.nabble.com/attachment/5001530/0/libecwj2-3.3-wcharfix.patch &&\
	wget http://trac.osgeo.org/gdal/raw-attachment/ticket/3366/libecwj2-3.3-NCSPhysicalMemorySize-Linux.patch &&\
	cd libecwj2-3.3/ &&\
	patch -p0< ../libecwj2-3.3-NCSPhysicalMemorySize-Linux.patch &&\
	patch -p1< ../libecwj2-3.3-wcharfix.patch &&\
	./configure &&\
	make &&\
	make install

# Install GDAL 2.1.3 from source
RUN wget http://download.osgeo.org/gdal/2.1.3/gdal213.zip && \
    unzip gdal213.zip &&\
    cd gdal-2.1.3 &&\
    ./configure --with-python=yes --with-ecw=/usr/local &&\
    make &&\
    make install &&\
    ldconfig &&\
    ln -s /usr/local/bin/ogr2ogr /usr/bin/ogr2ogr

RUN cp /usr/include/php/20151012/main/php.h /usr/include

# Install MapServer 7.0.4 from source
RUN cp /usr/include/php/20151012/* /usr/include/php -R

RUN wget https://github.com/jmckenna/mapserver/archive/phpmapscript-swig.zip &&\
	unzip phpmapscript-swig.zip &&\
	cd mapserver-phpmapscript-swig &&\
	mkdir build &&\
	cd build &&\
	cmake -DCMAKE_INSTALL_PREFIX=/opt \
    -DWITH_CLIENT_WFS=ON \
    -DWITH_CLIENT_WMS=ON \
    -DWITH_CURL=ON \
    -DWITH_SOS=ON \
    -DWITH_PHP=ON \
    -DWITH_PYTHON=ON \
    -DWITH_ORACLESPATIAL=0 \
    -DPHP_EXTENSION_DIR=/opt \
    -DWITH_RSVG=ON \
    -DWITH_SVGCAIRO=0 .. &&\
    make && make install

RUN cp /mapserver-phpmapscript-swig/build/mapserv /usr/lib/cgi-bin/mapserv.fcgi

# Install rar
RUN pecl install rar &&\
	echo "extension=rar.so" >> /etc/php/7.0/fpm/php.ini

# Add some projections to Proj4
RUN echo "<900913> +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs <>" >> /usr/share/proj/epsg && \
	echo "<34004> +proj=omerc +lonc=11.81 +lat_0=55.3333332 +x_0=-118947.024 +y_0=101112.545 +k=0.9999855 +alpha=1.190005 +gamma=0.0 +datum=WGS84" >> /usr/share/proj/epsg && \
	echo "<34005> +proj=omerc +lonc=11.81 +lat_0=55.3333332 +x_0=-118947.024 +y_0=101112.545 +k=0.9999855 +alpha=1.190005 +gamma=0.0 +datum=WGS84" >> /usr/share/proj/epsg

# Install Node.js, Grunt and Forever
#RUN curl -sL https://deb.nodesource.com/setup_4.x |  bash - &&\
#    apt-get install -y nodejs

#RUN npm install -g grunt-cli &&\
#	npm install -g forever

# Clone GC2 from GitHub
RUN cd /var/www/ &&\
	 git clone http://github.com/mapcentia/geocloud2.git

# Install npm packages run Grunt
#RUN	cd /var/www/geocloud2 &&\
#	npm install &&\
#	grunt production --force

# Add the custom config files from the Docker repo.
ADD conf/gc2/App.php /var/www/geocloud2/app/conf/
ADD conf/gc2/Connection.php /var/www/geocloud2/app/conf/

# Make php-fpm run in the foreground
RUN sed 's/;daemonize = yes/daemonize = no/' -i /etc/php/7.0/fpm/php-fpm.conf

# Add MapScript module to php.ini
#RUN echo "extension=php_mapscript.so" >> /etc/php/fpm/php.ini

# Add apache config file from Docker repo
ADD conf/apache/000-default.conf /etc/apache2/sites-enabled/
ADD conf/apache/gc2 /etc/apache2/sites-enabled/gc2
ADD conf/apache/000-default-le-ssl.conf /etc/apache2/sites-available/
ADD conf/apache/options-ssl-apache.conf /etc/apache2/ssl/

# Add php-fpm config file from Docker repo
ADD conf/fpm/www.conf /etc/php/7.0/fpm/pool.d/www.conf

# Enable Apache2 modules
RUN a2enmod rewrite headers expires include actions alias cgid fcgid ssl proxy proxy_http proxy_ajp proxy_balancer proxy_connect proxy_html xml2enc proxy_wstunnel proxy_fcgi
RUN a2enconf serve-cgi-bin

# Install letsencrypt
RUN cd ~ && git clone https://github.com/Neilpang/acme.sh.git

# Share dirs
VOLUME  ["/var/www/geocloud2","/etc/apache2","/etc/php/7.0/fpm","/var/log", "/usr/share/proj", "/var/spool/cron/crontabs", "/etc/letsencrypt"]

# Expose standard ports for HTTP and HTTPS
EXPOSE 80
EXPOSE 443
EXPOSE 1339

# Install New Relic daemon
#RUN apt-get -yq install wget && \
#    wget -O - https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
#    echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list

#RUN apt-get update && \
#    apt-get -yq install newrelic-php7

# Setup environment variables for initializing New Relic
#ENV NR_INSTALL_SILENT 1
#ENV NR_APP_NAME "Default App Name"

# Add the Nodejs proxy
#ADD nodejs/* /root/server/

# Install packages
#RUN cd /root/server &&\
#	npm install

# Add the check-if-fpm-is-alive script
COPY check-fpm.sh /check-fpm.sh
RUN chmod +x /check-fpm.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

ADD conf/apache/run-apache.sh /
RUN chmod +x /run-apache.sh

# Startrt fpm, so dirs are created
RUN service php7.0-fpm start


# Install PostGIS tools only
#RUN apt-get download postgis && \
#    dpkg --force-all -i postgis_2.1.4+dfsg-3_amd64.deb

# Add Supervisor config and run the deamon
ADD conf/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]