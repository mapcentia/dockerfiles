FROM java:7-jre

# Install supervisor
RUN apt-get -y update
RUN apt-get -y install supervisor

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

# Elasticsearch
ENV ELASTICSEARCH_VERSION 1.5.2

RUN echo "deb http://packages.elasticsearch.org/elasticsearch/${ELASTICSEARCH_VERSION%.*}/debian stable main" > /etc/apt/sources.list.d/elasticsearch.list

RUN apt-get update \
	&& apt-get -y install elasticsearch=$ELASTICSEARCH_VERSION \
	&& rm -rf /var/lib/apt/lists/*

# Expose port
EXPOSE 9200

CMD ["/usr/share/elasticsearch/bin/elasticsearch"]
