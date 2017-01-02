# MapCentia GC2conflict Dockerfile

GC2conflict is a web based tool for making spatial conflict queries in a PostGIS database. 

## How to use this image

    sudo docker run \
        --rm -i \
        -v ~/gc2conflict:/tmp mapcentia/gc2conflict cp /root/gc2conflict/app/config /tmp -R
        
    sudo docker run \
        --rm -i \
        -v ~/gc2conflict:/tmp mapcentia/gc2conflict cp /root/gc2conflict/app/tmp /tmp -R

GC2conflict depends on the APIs of GC2 and GeoServer with Printing Plugin, so link to a running GC2 and GeoServer container like this:

    sudo docker run \
        --name "gc2conflict" \
        --link gc2core:gc2core \
        --link postgis:postgis \
        -v ~/gc2conflict/config:/root/gc2conflict/app/config \
        -v ~/gc2conflict/tmp:/root/gc2conflict/app/tmp \
        -e TIMEZONE="Europe/Copenhagen" \
        -p 8000:80 \
        -d -t mapcentia/gc2conflict

You can map port 80 inside the container to any port on your local host. Here is host port 80 mapped to port 80 inside the container. Get the GC2 and GeoServer Docker Image from our account.


To edit the connection settings in the running container, run:

    sudo docker run \
        --volumes-from gc2conflict \
        --rm=true \
        -i -t mapcentia/gc2conflict /bin/bash
    
And from the command-line edit the files:

    ~/gc2conflict/app/config/browserConfig.js
    ~/gc2conflict/app/config/nodeConfig.js

At least you've to set the "host" in browserConfig.js. It's the public IP address or domain name of your running GC2 container. You don't need to change nodeConfig.js. 

And still on the command-line, run Grunt:

    cd ~/gc2conflict && grunt
    
After editing config files and running Grunt, you've to restart the GC2conflict container from the host:

    sudo docker restart gc2conflict

Call the web app in a browser with:

    [your host]/?db=[database]&schema=[schema]

![MapCentia](https://geocloud.mapcentia.com/assets/images/MapCentia_geocloud_200.png)

[www.mapcentia.com/en/geocloud](http://www.mapcentia.com/en/geocloud/)