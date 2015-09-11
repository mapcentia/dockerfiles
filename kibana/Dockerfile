FROM ubuntu:vivid
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

#Kibana
ENV KIBANA_VERSION 4.1.1
RUN cd /root && curl -L -O https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VERSION}-linux-x64.tar.gz \
        && tar xzvf kibana-${KIBANA_VERSION}-linux-x64.tar.gz

# Expose Kibana
EXPOSE 5601

CMD ["/usr/bin/supervisord", "-c", "/root/kibana-4.1.1-linux-x64/bin/kibana"]
