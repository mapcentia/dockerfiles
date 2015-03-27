FROM tomcat:8.0
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

# Install packages
RUN apt-get -y update
RUN apt-get -y install unzip openjdk-7-jre-headless openjdk-7-jre

# Get GeoServer
RUN wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/2.7.0/geoserver-2.7.0-bin.zip -O ~/geoserver.zip &&\
    unzip ~/geoserver.zip -d /opt && mv -v /opt/geoserver* /opt/geoserver

ENV GEOSERVER_HOME /opt/geoserver
ENV JAVA_HOME /usr/

# Get printing-plugin
RUN wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/2.7.0/extensions/geoserver-2.7.0-printing-plugin.zip -O ~/geoserver-printing-plugin.zip &&\
    unzip ~/geoserver-printing-plugin.zip -d /opt/geoserver/webapps/geoserver/WEB-INF/lib/

CMD ["/opt/geoserver/bin/startup.sh"]
EXPOSE 8080