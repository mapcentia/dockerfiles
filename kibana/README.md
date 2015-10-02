# Kibana
Kibana 4.1.1

## How to use this image
Kibana needs Elasticsearch. Check out our Elasticsearch image.

First copy the config from a container, so its stored on the host for easy editing and persistence.

    sudo docker run \
        --rm -i \
        -v ~/kibana:/tmp \
        mapcentia/kibana cp /root/kibana-4.1.1-linux-x64/config /tmp -R
        
Run a container with link to a Elasticsearch container.

    sudo docker run \
        --name kibana \
        --link elasticsearch:elasticsearch \
        -v ~/kibana/config:/root/kibana-4.1.1-linux-x64/config \
        -p 5601:5601 \
        -t -d mapcentia/kibana
        
![MapCentia](https://geocloud.mapcentia.com/assets/images/MapCentia_geocloud_200.png)

[www.mapcentia.com/en/geocloud](http://www.mapcentia.com/en/geocloud/)