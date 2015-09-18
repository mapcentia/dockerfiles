# PostGreSQL backup to AWS s3
An image for backing up all databases in a PostGreSQL cluster. The backups are stores on the Docker host and synced to an AWS s3 bucket. One backup is kept for every day in the month, one for every month in the year and one for every year.

Use -e SKIP="[db1] [db2]" if you want databases excluded from the backup.

## How to use this image
Run a container like this. Put the command in a crontab file on the host, so it runs every day. Backups are stored on the host in ~/backups

-e AWSACCESSKEYID=xxxxxx and -e AWSSECRETACCESSKEY=xxxxxx are your AWS credentials.

-e USER=gc2 and -e PASSWORD=xxxxxx is the PostGreSQL user and password. 

    sudo docker run \
        --rm=true \
        --privileged \
        -v ~/backups:/backups \
        --link postgis:postgis \
        -e USER=gc2 \
        -e PASSWORD=xxxxxx \
        -e BUCKET=[bucket-name] \
        -e AWSACCESSKEYID=xxxxxx \
        -e AWSSECRETACCESSKEY=xxxxxx \
        -e SKIP="template1 postgres" \
        -t -i \
        mapcentia/gc2backup
    

### Optional
Restore a backup. In this case the latest one. Notice: This command is using the image mapcentia/postgis.

    sudo docker run \
        --rm=true \
        -v ~/backups/postgis/latest:/restore \
        --link postgis:postgis \
        -t -i \
        mapcentia/postgis pg_restore --clean --dbname [database] -U gc2 -h postgis /restore/[database].bak
        
![MapCentia](https://geocloud.mapcentia.com/assets/images/MapCentia_geocloud_200.png)

[www.mapcentia.com/en/geocloud](http://www.mapcentia.com/en/geocloud/)
    