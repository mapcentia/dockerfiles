#!/bin/bash
docker run \
        --rm \
        --volumes-from=vidi \
        -t -i mapcentia/vidi grunt --gruntfile /root/vidi/Gruntfile.js env browserify less hogan shell uglify processhtml cssmin cacheBust