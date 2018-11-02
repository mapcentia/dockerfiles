mkdir data
cd && wget http://download.geofabrik.de/europe/europe/denmark-latest.osm.pbf && cd ..
docker run -t -v $PWD/data/foot:/data osrm/osrm-backend:v5.18.0 osrm-extract -p /opt/foot.lua /data/denmark-latest.osm.pbf
docker run -t -v $PWD/data/foot:/data osrm/osrm-backend:v5.18.0 osrm-contract /data/denmark-latest.osrm

git clone https://github.com/mapcentia/dockerfiles.git
mkdir nginx
cp $PWD/dockerfiles/nginx/proxy.conf ./nginx

docker create \
    --name nginx-proxy \
    -p 80:80 -p 443:443 \
    -v $PWD/nginx/certs:/etc/nginx/certs \
    -v $PWD/nginx/vhost.d:/etc/nginx/vhost.d \
    -v $PWD/nginx/proxy.conf:/etc/nginx/conf.d/proxy.conf \
    --ulimit nofile=65536:65536 \
    -v /usr/share/nginx/html \
    -v /var/run/docker.sock:/tmp/docker.sock \
    --label com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy \
    jwilder/nginx-proxy:alpine
    
docker create \
    --name nginx-letsencrypt \
    -v $PWD/nginx/certs:/etc/nginx/certs \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --volumes-from nginx-proxy \
    jrcs/letsencrypt-nginx-proxy-companion

docker start nginx-proxy
docker start nginx-letsencrypt

docker create \
    --name galton-foot \
    -p 6000:4000 \
    -e "VIRTUAL_HOST=galton-foot.gc2.io" \
    -e "LETSENCRYPT_HOST=galton-foot.gc2.io" \
    -e "LETSENCRYPT_EMAIL=mh@mapcentia.com" \
    -v $PWD/data:/data urbica/galton:v5.18.0 galton /data/foot/denmark-latest.osrm

docker run \
    -t -i \
    -p 4000:4000 \
    -e "VIRTUAL_HOST=galton-foot.gc2.io" \
    -e "LETSENCRYPT_HOST=galton-foot.gc2.io" \
    -e "LETSENCRYPT_EMAIL=mh@mapcentia.com" \
    -v $PWD/data:/data urbica/galton:v5.18.0 galton /data/foot/denmark-latest.osrm

