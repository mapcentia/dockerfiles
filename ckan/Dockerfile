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

# Expose standard ports for HTTP and HTTPS
EXPOSE 80

VOLUME ["/etc/ckan"]

# Add Supervisor config and run the deamon
ADD conf/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]