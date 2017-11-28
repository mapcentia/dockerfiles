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

#
# Set the maximum number of memory map area for Elasticsearch
# Only root can do this
#

sudo sysctl -w vm.max_map_count=262144

#
# Create a subnet, so each container gets a fixed IP 
#

git clone https://github.com/mapcentia/dockerfiles.git

#
# Set PostGreSQL pwd
#

echo "Password for new GC2 PostGreSQL user? This is only needed the first time you run this script or if the PostGIS or GC2core containers are re-created. "
read CONF
export PG_PW=$CONF

#echo "Leave PREFIX blank"
PREFIX=""
#echo "Prefix"
#read CONF
#if [ "$CONF" != "" ]; then
#    PREFIX=$CONF"_"
#fi

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
# PostGIS
#

#Create a persistence volume for postgis
if [[ $(docker ps -a --filter="name=postgis-data" | grep postgis-data) ]]
        then
                echo "postgis-data already exists. Doing nothing."
        else
                echo "Creating a persistence volume for postgis...."
                docker create --name postgis-data mapcentia/postgis
fi

check postgis
if [[ $? = 1 ]]
        then
                echo "Creating the postgis container...."
                docker create \
                        --name postgis \
                        -p 5432:5432 \
                        -p 6432:6432 \
                        --volumes-from postgis-data \
                        -e GC2_PASSWORD=$PG_PW \
                        -e LOCALE=$LOCALE \
                        -e TIMEZONE="$TIMEZONE" \
                        -t mapcentia/postgis
fi

#
# Elasticsearch
#

ELASTIC_VERSION=6.0.0

#Create a persistence volume for elasticsearch.
if [[ $(docker ps -a --filter="name=es-data" | grep es-data) ]]
        then
                echo "es-data already exists. Doing nothing."
        else
                echo "Creating a persistence volume for elasticsearch...."
                docker create --name es-data -v /usr/share/elasticsearch/data docker.elastic.co/elasticsearch/elasticsearch:${ELASTIC_VERSION}
fi

check elasticsearch
if [[ $? = 1 ]]
        then
                echo "Creating the elasticsearch container...."
                docker create \
                        --name elasticsearch \
                        --volumes-from es-data \
                        -e ES_JAVA_OPTS="-Xms512m -Xmx512m" \
                        -e "xpack.security.enabled=false" \
                        --cap-add=IPC_LOCK \
                        --ulimit memlock=-1:-1 \
                        --ulimit nofile=65536:65536 \
                        -p 9200:9200 \
                        -t docker.elastic.co/elasticsearch/elasticsearch:${ELASTIC_VERSION}
fi

#
# GC2 data
#

if [[ $(docker ps -a --filter="name=${PREFIX}gc2-data" | grep ${PREFIX}gc2-data) ]]
        then
                echo "${PREFIX}gc2-data already exists. Doing nothing."
        else
                echo "Create GC2 config files on host [y/N]"
                read CONF
                if [ "$CONF" = "y" ]; then
                        docker run \
                                --rm -i \
                                -v $PWD/${PREFIX}/gc2:/tmp mapcentia/gc2core cp /var/www/geocloud2/app/conf /tmp -R
                fi
                #Create a persistence volume for GC2. Busybox based.
                echo "Creating a persistence volume for gc2...."
                docker create --name ${PREFIX}gc2-data \
                        -v /etc/letsencrypt \
                        -v /var/www/geocloud2/app/tmp \
                        -v /var/www/geocloud2/app/wms/files \
                        -v /var/www/geocloud2/app/wms/mapcache \
                        -v /var/www/geocloud2/app/wms/mapfiles \
                        -v /var/www/geocloud2/app/wms/qgsfiles \
                        busybox
fi


#
# GC2 core
#

check ${PREFIX}gc2core
if [[ $? = 1 ]]
        then
                echo "Creating the GC2 container...."
                docker create \
                        --name ${PREFIX}gc2core \
                        --link postgis:postgis \
                        --link elasticsearch:elasticsearch \
                        --volumes-from gc2-data \
                        -v $PWD/${PREFIX}gc2/conf:/var/www/geocloud2/app/conf \
                        -e GC2_PASSWORD=$PG_PW \
                        -e TIMEZONE="$TIMEZONE" \
                        -e "VIRTUAL_HOST=${VIRTUAL_HOST}" \
                        -e "LETSENCRYPT_HOST=${VIRTUAL_HOST}" \
                        -e "LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL}" \
                        -p 1339:1339\
                        -t \
                        mapcentia/gc2core:php7
                fi

#
# MapCache
#

#Create a persistence volume for MapCache.
if [[ $(docker ps -a --filter="name=${PREFIX}mapcache-data" | grep ${PREFIX}mapcache-data) ]]
        then
                echo "${PREFIX}mapcache-data already exists. Doing nothing."
        else
                echo "Creating a persistence volume for mapcache...."
                docker create --name ${PREFIX}mapcache-data mapcentia/mapcache
fi

check ${PREFIX}mapcache
if [[ $? = 1 ]]
        then
                echo "Creating the MapCache container...."
                docker create \
                        --name ${PREFIX}mapcache \
                        --net container:${PREFIX}gc2core \
                        --volumes-from ${PREFIX}gc2-data \
                        --volumes-from ${PREFIX}mapcache-data \
                        -t mapcentia/mapcache
fi

#The rest is optional.

#
# Kibana
#

check kibana
if [[ $? = 1 ]]
        then
                echo "Install kibana [y/N]"
                read CONF
                if [ "$CONF" = "y" ]; then
                        #Create a persistence volume for Kibana
                        if [[ $(docker ps -a --filter="name=kibana-data" | grep kibana-data) ]]
                                then
                                        echo "kibana-data already exists. Doing nothing."
                                else
                                        echo "Creating a persistence volume for kibana...."
                                        docker create --name kibana-data docker.elastic.co/kibana/kibana:${ELASTIC_VERSION}
                        fi

                        echo "Creating the Kibana container...."
                        mkdir kibana
                        sudo cp $PWD/dockerfiles/kibana/kibana.yml ./kibana
                        docker create\
                                --name kibana \
                                --volumes-from kibana-data \
                                -v $PWD/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml \
                                --link elasticsearch:elasticsearch \
                                -p 5601:5601 \
                                -t docker.elastic.co/kibana/kibana:${ELASTIC_VERSION}
                fi
fi

#
# Logstash
#

check logstash
if [[ $? = 1 ]]
        then
                echo "Install logstash [y/N]"
                read CONF
                if [ "$CONF" = "y" ]; then
                    mkdir logstash && mkdir logstash/pipeline
                    sudo cp $PWD/dockerfiles/logstash/logstash.conf ./logstash/pipeline
                    echo "Creating the Logstash container...."
                    docker create \
                            --name logstash \
                            -v $PWD/logstash/piplogstash.conf:/usr/share/logstash/pipeline/logstash.conf \
                            --link elasticsearch:elasticsearch \
                            -p 5043:5043 \
                            -p 1338:1338 \
                            -t \
                             docker.elastic.co/logstash/logstash:${ELASTIC_VERSION}
                fi
fi

#
# Filebeat
#

check filebeat
if [[ $? = 1 ]]
        then
                echo "Install filebeat [y/N]"
                read CONF
                if [ "$CONF" = "y" ]; then
                    mkdir filebeat
                    sudo cp $PWD/dockerfiles/filebeat/filebeat.yml ./filebeat
                    docker create \
                            --name filebeat \
                            -v $PWD/filebeat/filebeat.yml:/usr/share/filebeat/filebeat.yml \
                            --volumes-from gc2core \
                            -t \
                            docker.elastic.co/beats/filebeat:${ELASTIC_VERSION}
                fi
fi

#
# Run Docker ps
#

docker ps -a
