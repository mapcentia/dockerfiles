FROM debian:jessie
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update
RUN apt-get -y install curl
RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.1.1-amd64.deb
RUN dpkg -i filebeat-5.1.1-amd64.deb

COPY filebeat.yml /etc/filebeat/filebeat.yml

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Install package for geo-location
RUN cd /root &&\
	curl -O "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz" &&\
	gunzip GeoLiteCity.dat.gz

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/filebeat.sh", "-c", "/etc/filebeat/filebeat.yml"]

