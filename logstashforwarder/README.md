# MapCentia Logstash-forwarder for GC2 Dockerfile

Logstash-forwarder for shipping Apache access logs to Logstash.

## How to use this image

First make a folder on the host to hold the certificate (You get this when creating a [GC2 Logstash ELK container](https://registry.hub.docker.com/u/mapcentia/logstash/))

    mkdir ~/certs

When copy the certificate (with the name "logstash.crt") to the folder.

Now you can start a Logstash-forwarder container with the log folder mounted in the contianer:

    sudo docker run --name gc2logstashforwarder -t -d -v /var/log:/var/log -v ~/certs:/certs mapcentia/gc2logstashforwarder
     
If you are running GC2 in a container when do it like this:

    sudo docker run --name gc2logstashforwader -t -d --volumes-from gc2 --link gc2logstash:gc2logstash -v ~/certs/:/certs gc2logstashforwarder


![MapCentia](https://geocloud.mapcentia.com/assets/images/MapCentia_geocloud_200.png)

[www.mapcentia.com/en/geocloud](http://www.mapcentia.com/en/geocloud/)