# MapCentia Vidi Dockerfile

Vidi (To See) is a new map viewer for GC2 and CartoDB

## How to use this image

    docker run \
            --rm -i \
            -v $PWD/vidi/config:/tmp mapcentia/vidi cp /root/vidi/config/config.js /tmp -R
    
###Create a persistence volume for Vidi.

    docker create --name vidi-data mapcentia/vidi
        
## Configure

    docker create \
            --name vidi \
            --volumes-from vidi-data \
            -e TIMEZONE="UTC" \
            -v $PWD/vidi/config:/root/vidi/config \
            -p 3000:3000 \
            -t mapcentia/vidi
            
Edit $PWD/vidi/config/config.js

Set the external DNS or IP of your GC2 server


![MapCentia](https://geocloud.mapcentia.com/assets/images/MapCentia_geocloud_200.png)

[www.mapcentia.com/en/geocloud](http://www.mapcentia.com/en/geocloud/)