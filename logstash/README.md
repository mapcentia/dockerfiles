# MapCentia Logstash for GC2 Dockerfile

Logstash 2.1 for indexing Apache ot Nginx access logs with client IP geo-location.

## How to use this image

Start a Logstash container like this:

    docker run \
        --name logstash \
        --restart=always \
        --link elasticsearch:elasticsearch \
        -v ~/logstash/certs:/certs \
        -p 5043:5043 \
        -p 1338:1338 \
        -e "LOGSTASH_DOMAIN=example.com" \
        -t -d \
        mapcentia/logstash:apache
    
Change the DNS hostname "example.com" to the hostname of your ELK server. You can also use "LOGSTASH_IP=1.2.3.4" but there is some issues with certificates based on IPs and Logstash. So better use a DNS hostname. 

When a container is created a certificate is generated in:

    ~/logstash/certs:/certs
    
Use the certificate for [Logstashforwarder](https://hub.docker.com/r/mapcentia/logstash-forwarder) on the GC2 servers.

![MapCentia](https://geocloud.mapcentia.com/assets/images/MapCentia_geocloud_200.png)

[www.mapcentia.com/en/geocloud](http://www.mapcentia.com/en/geocloud/)