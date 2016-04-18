#!/bin/bash

docker start postgis
docker start elasticsearch
docker start geoserver
docker start gc2core
until [ "`/usr/bin/docker inspect -f {{.State.Running}} gc2core`" == "true" ]; do
    sleep 0.1;
done;
docker start mapcache
docker start kibana
docker start logstash
docker start logstashforwarder