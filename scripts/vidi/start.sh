#!/bin/bash

docker start vidi
until [ "`/usr/bin/docker inspect -f {{.State.Running}} vidi`" == "true" ]; do
    sleep 0.1;
done;
docker run \
        --rm \
        --volumes-from=vidi \
        -t -i mapcentia/vidi grunt --gruntfile /root/vidi/Gruntfile.js
docker exec vidi bash -c "/usr/bin/supervisorctl -c /etc/supervisor/conf.d/supervisord.conf restart vidi"