# MapCentia MapCache
Stand-alone MapCache server for use with MapCentia GC2. The image comes with an API for adding new configurations and reloading the server. GC2 will transparently use this API.

## How to use this image
Start a contianer with two mounted volumes: One with MapCache configurations (the same as mounted in gc2core) and one for the cache (also the same as mounted in gc2core).

The API is listening to port 1337.

        
    sudo docker run \
            --name mapcache \
            -p 8888:80 \
            -p 1337:1337 \
            --link gc2core:gc2core \
            -v ~/gc2/mapcache:/var/www/geocloud2/app/wms/mapcache \
            -v ~/gc2/tmp:/var/www/geocloud2/app/tmp \
            -d -t mapcentia/mapcache

## Setup in GC2
In app/conf/App.php add:


    "mapCache" => [
                // MapCache host URL. This is the Docker host IP and port of the running MapCache container from within the GC2 container.
                "host" => "http://172.17.42.1:8888",
    
                // WMS host for MapCache. This is the Docker host IP and port of the running GC2 container from within the MapCache container.
                "wmsHost" => "http://172.17.42.1",
    
                // MapCache API URL. This is the Docker host IP and port of the running MapCache container from within the GC2 container.
                "api" => "http://172.17.42.1:1337",
            ],


## Optional
Start an interactive container for debugging:
    
    sudo docker run \
           --rm \
           --volumes-from=mapcache \
           --link gc2core:gc2core \
           -v ~/gc2/mapcache:/var/www/geocloud2/app/wms/mapcache \
           -i -t mapcentia/mapcache bash
            
                
