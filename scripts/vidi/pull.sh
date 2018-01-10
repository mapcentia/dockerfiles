#!/bin/bash
docker run \
        --rm \
        --volumes-from=vidi \
        -t -i mapcentia/vidi grunt --gruntfile /root/vidi/Gruntfile.js gitreset gitpull

docker run \
        --rm \
        --volumes-from=vidi \
        -t -i mapcentia/vidi bash -c "cd ~/vidi && npm install"
