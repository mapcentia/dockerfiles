#!/usr/bin/env bash
check () {
    flag=0
    if [[ $(docker ps -a --filter="name=$1" | grep $1$) ]]
        then
                return 1
        else
                return 0
    fi
}

check nginx-proxy
if [[ $? = 1 ]]
    then
        echo "nginx-proxy container exists..."
        cp $PWD/dockerfiles/scripts/systemd/nginx-proxy.service /lib/systemd/system
        systemctl enable nginx-proxy.service
        service nginx-proxy start
    else
        echo "nginx-proxy container doesn't exist"
fi

check nginx-letsencrypt
if [[ $? = 1 ]]
    then
        echo "nginx-letsencrypt container exists..."
        cp $PWD/dockerfiles/scripts/systemd/nginx-letsencrypt.service /lib/systemd/system
        systemctl enable nginx-letsencrypt.service
        service nginx-letsencrypt start
    else
        echo "nginx-letsencrypt container doesn't exist"
fi

check postgis
if [[ $? = 1 ]]
    then
        echo "postgis container exists..."
        cp $PWD/dockerfiles/scripts/systemd/postgis.service /lib/systemd/system
        systemctl enable postgis.service
        service postgis start
    else
        echo "postgis container doesn't exist"
fi

check elasticsearch
if [[ $? = 1 ]]
    then
        echo "elasticsearch container exists..."
        cp $PWD/dockerfiles/scripts/systemd/elasticsearch.service /lib/systemd/system
        systemctl enable elasticsearch.service
        service elasticsearch start
    else
        echo "elasticsearch container doesn't exist"
fi

check gc2core
if [[ $? = 1 ]]
    then
        echo "gc2core container exists..."
        cp $PWD/dockerfiles/scripts/systemd/gc2core.service /lib/systemd/system
        systemctl enable gc2core.service
        service gc2core start
    else
        echo "gc2core container doesn't exist"
fi

check vidi
if [[ $? = 1 ]]
    then
        echo "vidi container exists..."
        cp $PWD/dockerfiles/scripts/systemd/vidi.service /lib/systemd/system
        systemctl enable vidi.service
        service vidi start
    else
        echo "vidi container doesn't exist"
fi