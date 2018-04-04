#!/bin/bash
docker run \
        --rm \
        --volumes-from=vidi \
        -t -i mapcentia/vidi grunt --gruntfile /root/vidi/Gruntfile.js env gitreset browserify:publish less hogan shell uglify processhtml cssmin cacheBust