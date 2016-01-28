FROM java:7-jre

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

# Elasticsearch
ENV ELASTICSEARCH_VERSION 2.1.1

RUN echo "deb http://packages.elasticsearch.org/elasticsearch/${ELASTICSEARCH_VERSION%.*}/debian stable main" > /etc/apt/sources.list.d/elasticsearch.list

RUN apt-get update \
	&& apt-get -y install elasticsearch \
	&& rm -rf /var/lib/apt/lists/*

#Kibana
ENV KIBANA_VERSION 4.3.1
RUN cd /root && curl -L -O https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VERSION}-linux-x64.tar.gz \
        && tar xzvf kibana-${KIBANA_VERSION}-linux-x64.tar.gz

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

# Expose Elasticsearch, Logstash, Kibana and the Nodejs proxy
EXPOSE 9200 5043 5601 1337

# Add the logstash configuration
ADD conf/logstash/logstash-apache.conf /root/

# Add Supervisor config and run the deamon
ADD conf/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Make a dir for the certificate
RUN mkdir /certs

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

VOLUME ["/usr/share/elasticsearch", "/var/lib/elasticsearch/data", "/var/log", "/etc/elasticsearch"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
