#!/bin/bash

daemonize=false

while getopts ":d:" opt; do
    case "$opt" in
    d)  daemonize=$OPTARG
        ;;
    esac
done

echo $daemonize

docker start postgis
docker start elasticsearch
docker start gc2core
until [ "`/usr/bin/docker inspect -f {{.State.Running}} gc2core`" == "true" ]; do
    sleep 0.1;
done;
docker start mapcache
docker start kibana
docker start logstash
docker start logstashforwarder

if [ $daemonize == true ]; then
    exit 0
fi

check () {
    flag=0
    if [[ "`/usr/bin/docker inspect -f {{.State.Running}} $1`" == "true" ]]
        then
                return 1
        else
                return 0
    fi
}

while true; do
    sleep 10;
    #echo "checking...";

    check postgis
    if [[ $? = 0 ]]
        then
                echo "postgis stopped";
                break;
    fi

    check elasticsearch
    if [[ $? = 0 ]]
        then
                echo "elasticsearch stopped";
                break;
    fi

    check gc2core
    if [[ $? = 0 ]]
        then
                echo "gc2Core stopped";
                break;
    fi

    check mapcache
    if [[ $? = 0 ]]
        then
                echo "mapcache stopped";
                break;
    fi
done