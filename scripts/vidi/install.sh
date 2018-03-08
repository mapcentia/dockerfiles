#!/bin/bash

#
# Check Docker
#

VERSION=$(docker info | grep 'Server Version')
if [ "$VERSION" = "" ]; then
    echo "Docker is not installed or the you don't have permission to run Docker."
    exit
else
    echo "Docker info: $VERSION"
fi

LOCALE=$(locale | grep LANG= | grep -o '[^=]*$')
echo "Locale [$LOCALE]"
read CONF
if [ "$CONF" != "" ]; then
    LOCALE=$CONF
fi

TIMEZONE="UTC"
echo "Timezone [$TIMEZONE]"
read CONF
if [ "$CONF" != "" ]; then
    TIMEZONE=$CONF
fi

echo "Hostname (e.g. example.com,www.example.com)"
read CONF
if [ "$CONF" != "" ]; then
    VIRTUAL_HOST=$CONF
fi

echo "Let's encrypt email"
read CONF
if [ "$CONF" != "" ]; then
    LETSENCRYPT_EMAIL=$CONF
fi

check () {
    flag=0
    if [[ $(docker ps -a --filter="name=$1" | grep $1$) ]]
        then
                echo "Remove existing $1 container [y/N]"
                read CONF
                if [ "$CONF" = "y" ]; then
                        docker rm -f $1
                        return 1
                fi
        else
                return 1
    fi
}

check nginx-proxy
if [[ $? = 1 ]]
    then
        echo "Creating the nginx-proxy container...."
        docker create \
            --name nginx-proxy \
            -p 80:80 -p 443:443 \
            -v $PWD/certs:/etc/nginx/certs:ro \
            -v /etc/nginx/vhost.d \
            -v /usr/share/nginx/html \
            -v /var/run/docker.sock:/tmp/docker.sock:ro \
            --label com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy \
            jwilder/nginx-proxy:alpine
fi


check nginx-letsencrypt
if [[ $? = 1 ]]
    then
        echo "Creating the nginx-letsencrypt container...."
            docker create \
                --name nginx-letsencrypt \
                -v $PWD/certs:/etc/nginx/certs:rw \
                -v /var/run/docker.sock:/var/run/docker.sock:ro \
                --volumes-from nginx-proxy \
                jrcs/letsencrypt-nginx-proxy-companion
fi

#
# Vidi data
#

if [[ $(docker ps -a --filter="name=vidi-data" | grep vidi-data) ]]
        then
                echo "vidi-data already exists. Doing nothing."
        else
                echo "Create config files for Vidi on host [y/N]"
                read CONF
                if [ "$CONF" = "y" ]; then
                        docker run \
                            --rm -i \
                            -v $PWD/vidi/config:/tmp mapcentia/vidi cp /root/vidi/config/config.js /tmp -R

                        docker run \
                            --rm -i \
                            -v $PWD/vidi/config:/tmp mapcentia/vidi cp /root/vidi/config/_variables.less /tmp -R
                fi

                #Create a persistence volume for Vidi.
                echo "Creating a persistence volume for vidi...."
                docker create --name vidi-data mapcentia/vidi
        fi

#
# Vidi
#

check vidi
if [[ $? = 1 ]]
    then
        echo "Creating the Vidi container...."
        docker create \
                --name vidi \
                --volumes-from vidi-data \
                -e TIMEZONE="$TIMEZONE" \
                -e BACKEND="gc2" \
                -e LOCALE="$LOCALE" \
                -v $PWD/vidi/config:/root/vidi/config \
                -e "VIRTUAL_HOST=${VIRTUAL_HOST}" \
                -e "LETSENCRYPT_HOST=${VIRTUAL_HOST}" \
                -e "LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL}" \
                -t mapcentia/vidi

fi

#
# Run Docker ps
#

docker ps -a