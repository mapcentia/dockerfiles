FROM ubuntu:trusty
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

RUN apt-get -y --fix-missing update
RUN apt-get -y install  openjdk-7-jdk wget

RUN mkdir /usr/java &&\
    ln -s /usr/lib/jvm/java-7-openjdk-amd64 /usr/java/default

RUN cd /opt &&\
    wget http://archive.apache.org/dist/lucene/solr/4.7.2/solr-4.7.2.tgz &&\
    tar -xvf solr-4.7.2.tgz &&\
    cp -R solr-4.7.2/example /opt/solr

RUN useradd -d /opt/solr -s /sbin/false solr &&\
    chown solr:solr -R /opt/solr

RUN cd /opt/solr/solr &&\
    mv collection1 ckan

ADD conf/solr/schema.xml /opt/solr/solr/conf/schema.xml

EXPOSE 8983

RUN cd /opt/solr

CMD ["/usr/bin/java", "-jar", "/opt/solr/start.jar"]