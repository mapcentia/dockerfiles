FROM tomcat:8.0
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

# Install packages
RUN apt-get -y update
RUN apt-get -y install vim unzip openjdk-7-jre-headless openjdk-7-jre

# Get GeoServer
RUN wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/2.6.1/geoserver-2.6.1-bin.zip -O ~/geoserver.zip &&\
    unzip ~/geoserver.zip -d /opt && mv -v /opt/geoserver* /opt/geoserver

ENV GEOSERVER_HOME /opt/geoserver
ENV JAVA_HOME /usr/

# Get printing-plugin
RUN wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/2.6.1/extensions/geoserver-2.6.1-printing-plugin.zip -O ~/geoserver-printing-plugin.zip &&\
    unzip ~/geoserver-printing-plugin.zip -d /opt/geoserver/webapps/geoserver/WEB-INF/lib/

# Make dir and copy config for print
RUN mkdir /opt/geoserver/data_dir/printing/
ADD conf/config.yaml /opt/geoserver/data_dir/printing/

EXPOSE 8080
CMD ["/opt/geoserver/bin/startup.sh"]
