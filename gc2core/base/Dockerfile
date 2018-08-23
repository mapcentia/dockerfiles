FROM debian:stable
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN export DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update  --fix-missing
RUN apt-get -y install cron vim wget  g++ build-essential git unzip rng-tools apache2-utils postgresql-client supervisor netcat \
    apache2 php-fpm php-pgsql php-curl php-sqlite3 php-mbstring php-gd php-cli php-mbstring php-pear php-dev php7.0-zip \
    cmake libgdal-dev librsvg2-dev libpng++-dev libjpeg-dev libfreetype6-dev libproj-dev libfribidi-dev libharfbuzz-dev libcairo2-dev \
    libgeos++-dev libpython-all-dev curl libapache2-mod-fcgid libfcgi-dev xvfb nodejs osm2pgsql postgis swig sudo \
    apt-transport-https ca-certificates default-jre default-jdk

# Get libs for MS Access support in GDAL
RUN cd ~ &&\
    wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mdb-sqlite/mdb-sqlite-1.0.2.tar.bz2 &&\
    tar -vxjf mdb-sqlite-1.0.2.tar.bz2 &&\
    cp mdb-sqlite-1.0.2/lib/jackcess-1.1.14.jar /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/ &&\
    cp mdb-sqlite-1.0.2/lib/commons-logging-1.1.1.jar /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/ &&\
    cp mdb-sqlite-1.0.2/lib/commons-lang-2.4.jar /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/

# Install QGIS-server 2.18
RUN echo "deb http://qgis.org/debian stretch main" >> /etc/apt/sources.list &&\
    wget -O - http://qgis.org/downloads/qgis-2017.gpg.key | gpg --import &&\
    gpg --fingerprint CAEB3DC3BDF7FB45 &&\
    gpg --export --armor CAEB3DC3BDF7FB45 | apt-key add - &&\
    apt-get -y update &&\
    apt-get -y install qgis-server

# Add SQLite3 module to php.ini
RUN echo "extension=sqlite3.so" >> /etc/php/7.0/fpm/php.ini
