FROM ubuntu:trusty
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update
RUN apt-get -y install wget curl apache2-mpm-worker libfcgi-dev apache2-threaded-dev cmake g++ build-essential \
    libgdal-dev libgdal1-dev libgeos-dev libpng12-dev libjpeg-dev libcurl4-gnutls-dev libpcre3-dev libpixman-1-dev libsqlite3-dev libtiff4-dev git


RUN cd ~ && \
    git clone git://github.com/mapserver/mapcache.git

RUN cd ~ && \
    cd mapcache &&\
    mkdir build &&\
    cd build &&\
    cmake .. &&\
    make &&\
    make install

# Add apache config file from Docker repo
ADD conf/apache/000-default.conf /etc/apache2/sites-enabled/
ADD conf/apache/mapcache.conf /etc/apache2/sites-enabled/

# Share dirs
VOLUME  ["/var/log", "/etc/apache2/sites-enabled/"]

# Expose standard ports for HTTP
EXPOSE 80

RUN apache2ctl start

CMD ["/bin/bash", "-c", "source /etc/apache2/envvars && exec /usr/sbin/apache2 -D FOREGROUND"]


