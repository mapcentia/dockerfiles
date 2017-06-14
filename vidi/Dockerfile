# Use trusty so we can use wkhtmltopdf deb
FROM ubuntu:trusty
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update --fix-missing
RUN apt-get -y install wget curl vim git supervisor postgresql-client npm default-jre

RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN apt-get install -y nodejs

# Clone Vidi from GitHub
RUN cd  ~ &&\
	git  clone http://github.com/mapcentia/vidi.git

# Install grunt
RUN cd ~/vidi &&\
    npm install grunt-cli -g --save-dev

# Install packages
RUN cd ~/vidi &&\
	npm install

RUN cd ~/vidi/public/bower_components/bootstrap-material-design &&\
	npm install

#Add config files from Git repo
RUN cp ~/vidi/config/config.dist.js ~/vidi/config/config.js
RUN cp ~/vidi/public/bower_components/bootstrap-material-design/less/_variables.less ~/vidi/config/_variables.less

#Run Grunt
RUN cd ~/vidi &&\
    grunt

RUN ln -s /root/vidi/public/bower_components/bootstrap/dist/fonts /root/vidi/public/css/fonts

# Install wkhtmltox
RUN cd ~
RUN wget https://downloads.wkhtmltopdf.org/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
RUN dpkg -i --force-all wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
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