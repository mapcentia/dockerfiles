#!/bin/bash

sysctl -w vm.max_map_count=262144

docker start nginx-proxy
docker start nginx-letsencrypt
docker start postgis
docker start elasticsearch
docker start gc2core
until [ "`/usr/bin/docker inspect -f {{.State.Running}} gc2core`" == "true" ]; do
    sleep 0.1;
done;
docker start mapcache