FROM ubuntu:trusty
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update
RUN apt-get -y install curl vim git supervisor

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup | sudo bash -
RUN apt-get -y install nodejs

# Clone GC2 from GitHub
RUN cd /root &&\
	git clone http://github.com/mapcentia/gc2conflict.git &&\
	git  clone http://github.com/mapcentia/html2pdf.it.git

# Install packages
RUN cd /root/gc2conflict &&\
	npm install

RUN cd /root/html2pdf.it &&\
	npm install

# Fix bug in jsts by locking javascript.utils to ver. 0.12.5
RUN sed -i 's/\~0\.12\.5/0\.12\.5/g' /root/gc2conflict/node_modules/jsts/package.json
RUN cd /root/gc2conflict &&\
	npm update

# Install grunt
RUN npm install -g grunt-cli

#Add config files from Docker repo
ADD conf/browserConfig.js /root/gc2conflict/app/config/
ADD conf/nodeConfig.js /root/gc2conflict/app/config/

#Run Grunt
RUN cd /root/gc2conflict &&\
	grunt

VOLUME  ["/root/gc2conflict/app/conf"]

# Add Supervisor config and run the deamon
ADD conf/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

EXPOSE 80