FROM ubuntu:xenial
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update --fix-missing
RUN apt-get -y install ghostscript phantomjs curl vim git supervisor postgresql-client nodejs npm

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
RUN cp ~/vidi/config/config.js.dist ~/vidi/config/config.js

#Run Grunt
RUN cd ~/vidi &&\
    grunt

# Add entry point
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3000

# Share the source dir
VOLUME  ["/root/vidi"]

# Add Supervisor config and run the deamon
ADD conf/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]