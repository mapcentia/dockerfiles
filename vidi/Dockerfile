FROM debian:stable
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN export DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update --fix-missing
RUN apt-get -y install wget curl vim git supervisor postgresql-client nodejs default-jre gnupg2 locales libssl1.0-dev

RUN curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs

# Clone Vidi from GitHub
RUN cd  ~ &&\
	git  clone http://github.com/mapcentia/vidi.git --branch develop

# Install grunt
RUN cd ~/vidi &&\
    npm install grunt-cli -g --save-dev

# Install packages
RUN cd ~/vidi &&\
	npm install

RUN cd ~/vidi/public/js/lib/bootstrap-material-design &&\
	npm install

RUN cd ~/vidi/public/extensions/keplergl/browser &&\
	npm install

#Add config files from Git repo
RUN cp ~/vidi/config/config.dist.js ~/vidi/config/config.js
RUN cp ~/vidi/public/js/lib/bootstrap-material-design/less/_variables.less ~/vidi/config/_variables.less

#Run Grunt
RUN cd ~/vidi &&\
    grunt env gitreset browserify:publish less hogan shell uglify processhtml cssmin cacheBust

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