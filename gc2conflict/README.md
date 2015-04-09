# MapCentia GC2conflict Dockerfile

GC2conflict is a web based tool for making spatial conflict queries in a PostGIS database. 

## How to use this image
    
Just run a container like this:

    sudo docker run --name "gc2conflict" --link gc2:gc2 -p 80:80 -d -t mapcentia/gc2conflict

You can map port 80 inside the container to any port on your local host. Here is host port 80 mapped to port 80 inside the container.

GC2conflict depends on the APIs of GC2, so link to a running GC2 container and edit the settings in the container.

To edit the connection settings in the container, run:

    sudo docker run --volumes-from gc2conflict --rm=true -i -t mapcentia/gc2conflict /bin/bash
    
And from the command-line edit the files:

    ~/gc2conflict/app/config/nodeConfig.js
    ~/gc2conflict/app/config/browserConfig.js
    
After editing config files, you've to restart the GC2conflict container:

    sudo docker restart gc2conflict

![MapCentia](https://geocloud.mapcentia.com/assets/images/MapCentia_geocloud_200.png)

[www.mapcentia.com/en/geocloud](http://www.mapcentia.com/en/geocloud/)