FROM ubuntu:wily
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update  --fix-missing
RUN apt-get -y install sudo wget curl apache2 libfcgi-dev apache2-threaded-dev cmake g++ build-essential \
    libgdal-dev libgdal1-dev libgeos-dev libpng12-dev libjpeg-dev libcurl4-gnutls-dev libpcre3-dev libpixman-1-dev libsqlite3-dev libtiff5-dev git \
    supervisor

RUN cd ~ && \
    git clone http://github.com/mapserver/mapcache.git

RUN cd ~ && \
    cd mapcache &&\
    mkdir build &&\
    cd build &&\
    cmake .. &&\
    make &&\
    make install &&\
    ldconfig

# Change default port
RUN sed 's/Listen 80/Listen 5555/' -i /etc/apache2/ports.conf

# Start httpd with apache2ctl, so the lock file is created
RUN apache2ctl start

# Add apache config file from Docker repo
ADD conf/apache/000-default.conf /etc/apache2/sites-enabled/
ADD conf/apache/mapcache.conf /etc/apache2/sites-enabled/

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get -y install nodejs

# Add the Nodejs proxy
ADD nodejs/* /root/server/

# Install packages
RUN cd /root/server &&\
	npm install

RUN mkdir /mapcache
RUN cp /root/mapcache/mapcache.xml /mapcache/

# Share dirs
VOLUME  ["/var/log", "/etc/apache2", "/mapcache", "/tmp"]

# Expose standard ports for HTTP
EXPOSE 80
EXPOSE 1337

ADD conf/apache/run-apache.sh /
RUN chmod +x /run-apache.sh

# Add Supervisor config and run the deamon
ADD conf/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]


