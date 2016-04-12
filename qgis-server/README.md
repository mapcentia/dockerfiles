docker run \
    --name qgis-server \
    --link postgis:postgis \
    -v /vagrant/geocloud2:/var/www/geocloud2 \
    -td mapcentia/qgis-server
    
docker run \
    --rm \
    --link postgis:postgis \
    --volumes-from  qgis-server \
    -ti mapcentia/qgis-server bash