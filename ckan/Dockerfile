FROM ubuntu:trusty
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update --fix-missing
RUN apt-get -y install nginx apache2 libapache2-mod-wsgi libpq5 wget supervisor

RUN wget http://packaging.ckan.org/python-ckan_2.5-trusty_amd64.deb &&\
        dpkg -i python-ckan_2.5-trusty_amd64.deb

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

ADD conf/ckan/production.ini /etc/ckan/default/

# Expose standard ports for HTTP and HTTPS
EXPOSE 8080

VOLUME ["/etc/ckan", "/var/log", "/usr/lib/ckan"]

# Install ckanext-geoview plugins
RUN . /usr/lib/ckan/default/bin/activate &&\
        pip install ckanext-geoview

ADD run-apache.sh /
RUN chmod +x /run-apache.sh

CMD ["/bin/bash", "-c", "/run-apache.sh"]