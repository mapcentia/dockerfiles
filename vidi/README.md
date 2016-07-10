# MapCentia Vidi Dockerfile

Vidi (To See) is a new map viewer for GC2 and CartoDB

## How to use this image

    sudo docker run \
        --name "vidi" \
        -e TIMEZONE="Europe/Copenhagen" \
        -p 3000:3000 \
        -d -t mapcentia/vidi
        
## Configure

    sudo docker run \
            --rm \
            --volumes-from=vidi \
            -i -t mapcentia/vidi bash
            
Edit ~/vidi/config/config.js

Set the external DNS or IP of your GC2 server


![MapCentia](https://geocloud.mapcentia.com/assets/images/MapCentia_geocloud_200.png)

[www.mapcentia.com/en/geocloud](http://www.mapcentia.com/en/geocloud/)