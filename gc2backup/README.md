docker run \
    --rm=true \
    --privileged \
    -v ~/backups:/backups \
    --link postgis:postgis \
    -e USER=gc2 \
    -e PASSWORD=naTH7crU \
    -e BUCKET=gc2-furesoe \
    -e AWSACCESSKEYID=AKIAJUMX36CJNFIPXJLA \
    -e AWSSECRETACCESSKEY=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 \
    -e SKIP="template1 postgres" \
    -t -i \
    mapcentia/gc2backup
    


sudo docker images -q |xargs sudo docker rmi


# Create new database
docker run \
    --rm=true \
    --link postgis:postgis \
    -t -i \
    mapcentia/postgis createdb dragoer -U gc2 -h postgis -T template0 -l da_DK.UTF-8
    
# Restore backup
docker run \
    --rm=true \
    -v ~/latest:/latest \
    --link postgis:postgis \
    -t -i \
    mapcentia/postgis pg_restore --clean --dbname mapcentia -U gc2 -h postgis /latest/mapcentia.bak
    