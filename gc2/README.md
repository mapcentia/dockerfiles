First start PostGreSQL and Elasticsearch:

```docker run –name postgres -d -p 5432:5432 mapcentia/gc2 sudo -u postgres /usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf -D FOREGROUND```

And:

```docker run –name elasticsearch -p 9200:9200 -d -t mapcentia/gc2 /usr/share/elasticsearch/bin/elasticsearch -D FOREGROUND```

The start the HTTP server with container links:

```docker run –name apache2 –link elasticsearch:elasticsearch –link postgres:postgres -p 80:80 -d -t mapcentia/gc2 /root/run-apache.sh -D FOREGROUND```

Enjoy!

![MapCentia](http://www.mapcentia.com/images/__od/863/mapcentialogo.png)

http://www.mapcentia.com/en/geocloud/