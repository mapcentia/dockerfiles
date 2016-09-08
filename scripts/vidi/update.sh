#!/bin/bash
docker run \
        --rm \
        --volumes-from=vidi \
        -t -i mapcentia/vidi grunt --gruntfile /root/vidi/Gruntfile.js production

docker run \
        --rm \
        --volumes-from=vidi \
        -t -i mapcentia/vidi bash -c "cd ~/vidi && npm install"

docker run \
        --rm \
        --volumes-from=vidi \
        -t -i mapcentia/vidi grunt --gruntfile /root/vidi/public/bower_components/bootstrap-material-design/Gruntfile.js serve --force