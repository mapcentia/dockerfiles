FROM java:8-jre

# Install supervisor
RUN apt-get -y update
RUN apt-get -y install supervisor

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

# Logstash
ENV LOGSTASH_MAJOR 2.1

RUN echo "deb http://packages.elasticsearch.org/logstash/${LOGSTASH_MAJOR}/debian stable main" > /etc/apt/sources.list.d/logstash.list

RUN set -x \
	&& apt-get update \
	&& apt-get install -y logstash \
	&& rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get -y install nodejs

# Add the Nodejs proxy
ADD nodejs/* /root/server/

# Install packages
RUN cd /root/server &&\
	npm install

# Install package for geo-location
RUN cd /etc/logstash &&\
	curl -O "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz" &&\
	gunzip GeoLiteCity.dat.gz

# Expose Logstash and the Nodejs proxy
EXPOSE 5043 1338

# Add the logstash configuration
ADD logstash-nginx.conf /root/
ADD nginx /opt/logstash/patterns/

# Add Supervisor config and run the deamon
ADD conf/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Make a dir for the certificate
RUN mkdir /certs

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

VOLUME ["/var/lib/elasticsearch/data", "/var/log"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
