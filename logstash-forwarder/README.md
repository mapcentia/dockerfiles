# MapCentia Logstash-forwarder for GC2 Dockerfile

Logstash-forwarder for shipping Apache access logs to Logstash.

## How to use this image

First make a folder on the host to hold the certificate (You get this when creating a [GC2 Logstash ELK container](https://registry.hub.docker.com/u/mapcentia/logstash/))

    mkdir ~/logstash
    mkdir ~/logstash/certs

When copy the certificate (with the name "logstash.crt") to the folder.

Set -e MASTER=LOGSTASHDOMAIN:PORT to the hostname of the Logstash server eg. -e MASTER=example.com:5043

    docker run \
        --name logstashforwader \
        --restart=always \
        --volumes-from gc2 \
        -v ~/certs/:/certs \
        -e "MASTER=example.com:5043" \
        -t -d \
        mapcentia/logstash-forwarder:apache
        
    docker run \
        --name logstashforwader \
        --restart=always \
        --volumes-from nginx \
        -v ~/certs/:/certs \
        -e "MASTER=example.com:5043" \
        -t -d \
        mapcentia/logstash-forwarder:nginx


![MapCentia](https://geocloud.mapcentia.com/assets/images/MapCentia_geocloud_200.png)

[www.mapcentia.com/en/geocloud](http://www.mapcentia.com/en/geocloud/)