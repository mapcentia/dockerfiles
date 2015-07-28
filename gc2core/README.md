docker run --name gc2core --link postgis:postgis --link elasticsearch:elasticsearch -d -t -p 80:80 mapcentia/gc2core

docker run --name gc2core --link postgis:postgis -v ~/ssl:/etc/apache2/ssl -v ~/sites-enabled:/etc/apache2/sites-enabled/ -d -t -p 80:80 -p 443:443 mapcentia/gc2core

docker run --volumes-from=gc2core --rm=true -t -i mapcentia/gc2core /bin/bash

/path/to/openssl rsa -in /path/to/originalkeywithpass.key -out /path/to/newkeywithnopass.key

docker cp gc2core:/var/www/geocloud2/app/tmp/ ~/gc2files/