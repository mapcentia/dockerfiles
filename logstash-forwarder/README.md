# MapCentia Logstash-forwarder for GC2 Dockerfile

Logstash-forwarder for shipping Apache access logs to Logstash.

## How to use this image

First make a folder on the host to hold the certificate (You get this when creating a [GC2 Logstash ELK container](https://registry.hub.docker.com/u/mapcentia/logstash/))

    mkdir ~/certs

When copy the certificate (with the name "logstash.crt") to the folder.

Now you can start a Logstash-forwarder container with the host log-folder mounted in the container. Set -e MASTER=LOGSTASHDOMAIN:PORT to the hostname of the Logstash server eg. -e MASTER=example.com:5043

     sudo docker run \
        --name logstashforwarder \
        -v /var/log:/var/log \
        -v ~/certs:/certs \
        -e "MASTER=example.com:5043" \
        -t -d \
        mapcentia/logstash-forwarder
     
If you are running GC2 in a container called GC2 when do it like this:

    sudo docker run \
        --name logstashforwader \
        --volumes-from gc2 \
        -v ~/certs/:/certs \
        -e "MASTER=example.com:5043" \
        -t -d \
        mapcentia/logstash-forwarder


![MapCentia](https://geocloud.mapcentia.com/assets/images/MapCentia_geocloud_200.png)

[www.mapcentia.com/en/geocloud](http://www.mapcentia.com/en/geocloud/)