FROM ubuntu:trusty
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

# Install packages
RUN apt-get -y update --fix-missing
RUN apt-get -y install vim unzip software-properties-common tomcat7

RUN \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update --fix-missing && \
  apt-get install -y oracle-java7-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk7-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# Get GeoServer

RUN wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/2.7.0/geoserver-2.7.0-bin.zip -O ~/geoserver.zip &&\
    unzip ~/geoserver.zip -d /opt && mv -v /opt/geoserver* /opt/geoserver

ENV GEOSERVER_HOME /opt/geoserver
ENV JAVA_HOME /usr/

# Get printing-plugin
RUN wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/2.7.0/extensions/geoserver-2.7.0-printing-plugin.zip -O ~/geoserver-printing-plugin.zip &&\
    unzip ~/geoserver-printing-plugin.zip -d /opt/geoserver/webapps/geoserver/WEB-INF/lib/

# Get native JAI and ImageIO
RUN \
    cd ~ && \
    wget http://download.java.net/media/jai-imageio/builds/release/1.1/jai_imageio-1_1-lib-linux-amd64.tar.gz && \
    tar -zxvf jai_imageio-1_1-lib-linux-amd64.tar.gz && \
    cp jai_imageio-1_1/lib/*.jar /usr/lib/jvm/java-7-oracle/jre/lib/ext/ && \
    cp jai_imageio-1_1/lib/*.so /usr/lib/jvm/java-7-oracle/jre/lib/amd64/

RUN \
    cd ~ && \
    wget http://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64.tar.gz && \
    tar -zxvf jai-1_1_3-lib-linux-amd64.tar.gz && \
    cp jai-1_1_3/lib/*.jar /usr/lib/jvm/java-7-oracle/jre/lib/ext/ && \
    cp jai-1_1_3/lib/*.so /usr/lib/jvm/java-7-oracle/jre/lib/amd64/

# Make dir and copy print config file from docker repo
RUN mkdir /opt/geoserver/data_dir/printing/
ADD conf/config.yaml /opt/geoserver/data_dir/printing/

# Share volume, so config.yaml can be edited in running container
VOLUME ["/opt/geoserver/data_dir/printing"]

# Expose GeoServer's default port
EXPOSE 8080
CMD ["/opt/geoserver/bin/startup.sh"]
