FROM ubuntu:vivid
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

#Kibana
ENV KIBANA_VERSION 4.3.1
RUN cd /root && curl -L -O https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VERSION}-linux-x64.tar.gz \
        && tar xzvf kibana-${KIBANA_VERSION}-linux-x64.tar.gz

# Change the Elasticsearch host
RUN sed -i "s/elasticsearch_url: \"http://127.0.0.1:9200\"/elasticsearch_url: \"http://elasticsearch:9200\"/g" /var/www/geocloud2/app/conf/Connection.php

# Share volumes
VOLUME  ["kibana-${KIBANA_VERSION}-linux-x64"]

# Expose Kibana
EXPOSE 5601

CMD ["/usr/bin/supervisord", "-c", "/root/kibana-4.1.1-linux-x64/bin/kibana"]
