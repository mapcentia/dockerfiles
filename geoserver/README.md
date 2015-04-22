# MapCentia GeoServer-printing Dockerfile

GeoServer 2.7.0 with the printing plug-in running on Oracle Java 7 with native JAI and JAI ImageIO.  

## How to use this image

Just run a container like this:

    sudo docker run --name "geoserver" -p 8080:8080 -d -t mapcentia/geoserver
    
You can map port 8080 inside the container to any port on your local host. Here is host port 8080 mapped to port 8080 inside the container.


You can edit the print configuration by starting an other container with volumes mounted from the geoserver container like this:

    sudo docker run --rm=true --volumes-from geoserver -i -t mapcentia/geoserver /bin/bash
    
And edit the file:
    
    /opt/geoserver/data_dir/printing/config.yaml

![MapCentia](https://geocloud.mapcentia.com/assets/images/MapCentia_geocloud_200.png)

[www.mapcentia.com/en/geocloud](http://www.mapcentia.com/en/geocloud/)