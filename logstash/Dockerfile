FROM java:7-jre

# Install supervisor
RUN apt-get -y update
RUN apt-get -y install supervisor

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

# Logstash
ENV LOGSTASH_MAJOR 1.5
ENV LOGSTASH_VERSION 1:1.5.0-1

RUN echo "deb http://packages.elasticsearch.org/logstash/${LOGSTASH_MAJOR}/debian stable main" > /etc/apt/sources.list.d/logstash.list

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends logstash=$LOGSTASH_VERSION \
	&& rm -rf /var/lib/apt/lists/*

# Elasticsearch
ENV ELASTICSEARCH_VERSION 1.5.2

RUN echo "deb http://packages.elasticsearch.org/elasticsearch/${ELASTICSEARCH_VERSION%.*}/debian stable main" > /etc/apt/sources.list.d/elasticsearch.list

RUN apt-get update \
	&& apt-get -y install elasticsearch=$ELASTICSEARCH_VERSION \
	&& rm -rf /var/lib/apt/lists/*

#Kibana
ENV KIBANA_VERSION 4.0.2
RUN cd /root && curl -L -O https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VERSION}-linux-x64.tar.gz \
        && tar xzvf kibana-4.0.2-linux-x64.tar.gz

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get -y install nodejs

ADD nodejs/* /root/server/

# Install packages
RUN cd /root/server &&\
	npm install

# Expose Logstash, Elasticsearch and Kibana
EXPOSE 9200 5601 5043 1337

# Add the logstash configuration
ADD conf/logstash/logstash-apache.conf /root/

# Add Supervisor config and run the deamon
ADD conf/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir /certs

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
