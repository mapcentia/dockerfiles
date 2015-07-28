# MapCentia ELK stack for GC2 Dockerfile

Full ELK stack (Logstash 1.5.0, Elasticsearch 1.5.2 and Kibana 4.0.2) with a NodeJS proxy for GC2. The container is set up to index Apache access logs with client IP geo-location.

## How to use this image

Start a Logstash container like this:

    sudo docker run \
        --name gc2logstash -t -d \
        -p 5043:5043 -p 5601:5601 -p 1337:1337 \
        -e "LOGSTASH_DOMAIN=example.com" \
        mapcentia/logstash
    
Change the DNS hostname "example.com" to the hostname of your ELK server. You can also use "LOGSTASH_IP=1.2.3.4" but there is some issues with certificates based on IPs and Logstash. So better use a DNS hostname. 

When a container is created a certificate is generated. Copy the certificate out from the container:

    sudo docker cp gc2logstash:/certs/logstash.crt ~/certs/
    
Use the certificate for [Logstashforwarder](https://registry.hub.docker.com/u/mapcentia/logstash-forwarder) on the GC2 servers.

![MapCentia](https://geocloud.mapcentia.com/assets/images/MapCentia_geocloud_200.png)

[www.mapcentia.com/en/geocloud](http://www.mapcentia.com/en/geocloud/)