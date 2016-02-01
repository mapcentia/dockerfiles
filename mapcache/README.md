# MapCentia MapCache
Stand-alone MapCache server for use with MapCentia GC2. The image comes with an API for adding new configurations and reloading the server. GC2 will transparently use this API.

## How to use this image
Start a contianer with two mounted volumes: One with MapCache configurations (the same as mounted in gc2core) and one for the cache (also the same as mounted in gc2core).

The API is listening to port 1337.

        
    sudo docker run \
            --name mapcache \
            --restart=always \
            -p 5555:5555 \
            -p 1337:1337 \
            --link gc2core:gc2core \
            -v ~/gc2/mapcache:/var/www/geocloud2/app/wms/mapcache \
            -v ~/gc2/tmp:/var/www/geocloud2/app/tmp \
            -d -t mapcentia/mapcache

## Setup in GC2
In app/conf/App.php add:


    "mapCache" => [
                // MapCache host URL. This is the Docker host IP and port of the running MapCache container from within the GC2 container.
                "host" => "http://mapcache",
    
                // WMS host for MapCache. This is the Docker host IP and port of the running GC2 container from within the MapCache container.
                "wmsHost" => "http://gc2core",
    
                // MapCache API URL. This is the Docker host IP and port of the running MapCache container from within the GC2 container.
                "api" => "http://mapcache:1337",
            ],


## Optional
MapCache is by default proxied by GC2, which adds a security layer. This adds a small resource overhead. If you want to bypass GC2 security you can add these lines to the Apache2 configuration in the GC2 container.

    # Always rewrite GetLegendGraphic, GetFeatureInfo, DescribeFeatureType, format_options and all POST to WMS
    RewriteEngine On
    RewriteCond %{QUERY_STRING} (^|&)REQUEST=GetLegendGraphic($|&) [NC,OR]
    RewriteCond %{QUERY_STRING} (^|&)REQUEST=GetFeatureInfo($|&) [NC,OR]
    RewriteCond %{QUERY_STRING} (^|&)REQUEST=DescribeFeatureType($|&) [NC,OR]
    RewriteCond %{REQUEST_METHOD} POST
    RewriteRule /mapcache/(.*)/wms/(.*) /ows/$1/$2 [L]
    
    ProxyPreserveHost On
    ProxyPass /mapcache/ http://mapcache/mapcache/
    ProxyPassReverse /mapcache/ http://mapcache/mapcache/


Start an interactive container for debugging:
    
    sudo docker run \
           --rm \
           --volumes-from=mapcache \
           --link gc2core:gc2core \
           -v ~/gc2/mapcache:/var/www/geocloud2/app/wms/mapcache \
           -i -t mapcentia/mapcache bash
            
                
![MapCentia](https://geocloud.mapcentia.com/assets/images/MapCentia_geocloud_200.png)

[www.mapcentia.com/en/product](http://www.mapcentia.com/en/product)