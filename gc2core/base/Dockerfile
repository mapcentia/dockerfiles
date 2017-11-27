FROM debian:stable
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN export DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update  --fix-missing
RUN apt-get -y install cron vim wget  g++ build-essential git unzip rng-tools apache2-utils postgresql-client supervisor netcat \
    apache2 php-fpm php-pgsql php-curl php-sqlite3 php-mbstring php-gd php-cli php-mbstring php-pear php-dev php7.0-zip \
    cmake libgdal-dev librsvg2-dev libpng++-dev libjpeg-dev libfreetype6-dev libproj-dev libfribidi-dev libharfbuzz-dev libcairo2-dev \
    libgeos++-dev libpython-all-dev curl libapache2-mod-fcgid libfcgi-dev xvfb nodejs osm2pgsql postgis swig sudo

# Install QGIS-server 2.18
RUN echo "deb http://qgis.org/debian stretch main" >> /etc/apt/sources.list &&\
    wget -O - http://qgis.org/downloads/qgis-2017.gpg.key | gpg --import &&\
    gpg --fingerprint CAEB3DC3BDF7FB45 &&\
    gpg --export --armor CAEB3DC3BDF7FB45 | apt-key add - &&\
    apt-get -y update &&\
    apt-get -y install qgis-server

# Add SQLite3 module to php.ini
RUN echo "extension=sqlite3.so" >> /etc/php/7.0/fpm/php.ini

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
