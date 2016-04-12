FROM ubuntu:wily
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

# Suppress prompts from dpkg to resolve conffile differences
ENV DEBIAN_FRONTEND noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
      wget curl

# Download and install the Public Signing Key:
RUN wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -

# Add the repository definition to your /etc/apt/sources.list file:
RUN echo "deb http://packages.elasticsearch.org/logstashforwarder/debian stable main" > /etc/apt/sources.list

# Install logstash forwarder
RUN apt-get update && apt-get install -y \
      logstash-forwarder

# Copy configuration file

COPY ./logstash-forwarder.conf /root/

# Make a dir for the certificate
RUN mkdir /certs

# Share the root dir, so the logstash-forwarder.conf can be edited
VOLUME  ["/root"]

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Run logstash forwarder
CMD [ "/opt/logstash-forwarder/bin/logstash-forwarder", "-config", "/root/logstash-forwarder.conf" ]