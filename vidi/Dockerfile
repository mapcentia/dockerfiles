# Use trusty so we can use wkhtmltopdf deb
FROM ubuntu:trusty
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update --fix-missing
RUN apt-get -y install wget curl vim git supervisor postgresql-client nodejs npm

# Fix
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Clone Vidi from GitHub
RUN cd  ~ &&\
	git clone http://github.com/mapcentia/vidi.git

# Install grunt
RUN cd ~/vidi &&\
    npm install grunt-cli -g --save-dev

# Install packages
RUN cd ~/vidi &&\
	npm install

#Add config files from Git repo
RUN cp ~/vidi/config/config.dist.js ~/vidi/config/config.js

#Run Grunt
RUN cd ~/vidi &&\
    grunt

# Install wkhtmltox
RUN cd ~
RUN wget http://download.gna.org/wkhtmltopdf/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb
RUN dpkg -i --force-all  wkhtmltox-0.12.1_linux-trusty-amd64.deb
RUN apt-get -y -f install

EXPOSE 3000

# Share the source dir
VOLUME  ["/root/vidi"]

# Add entry point
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Add Supervisor config and run the deamon
ADD conf/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]