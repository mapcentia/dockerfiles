FROM java:8-jre

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

# Elasticsearch
ENV ELASTICSEARCH_VERSION 1.7.1

ENV ELASTICSEARCH_MAJOR 2.1
ENV ELASTICSEARCH_VERSION 2.1.1
ENV ELASTICSEARCH_REPO_BASE http://packages.elasticsearch.org/elasticsearch/2.x/debian

RUN echo "deb $ELASTICSEARCH_REPO_BASE stable main" > /etc/apt/sources.list.d/elasticsearch.list

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends elasticsearch=$ELASTICSEARCH_VERSION

# Expose port
EXPOSE 9200 9300

VOLUME ["/usr/share/elasticsearch/data", "/usr/share/elasticsearch/config"]

CMD ["/usr/share/elasticsearch/bin/elasticsearch"]
