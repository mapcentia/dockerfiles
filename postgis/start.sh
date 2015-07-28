#!/bin/bash
set -e

export PGUSER=gc2

if [ -n "$GC2_PASSWORD" ]; then
    exec "$@"
else
    # The - option suppresses leading tabs but *not* spaces. :)
    echo '
        ****************************************************
        ERROR:   No password has been set for the GC2 user.
                 Use "-e GC2_PASSWORD=password" to set
                 it in "docker run".
        ****************************************************
    '
    exit 1
fi

if [ -n "$LOCALE" ]; then
    locale=$LOCALE
else
    locale=en_US.UTF-8
    echo '
        ****************************************************
        WARNING: No locale has been for the GC2 template db.
                 Setting it to en_US.UTF-8.
                 Use "-e locale=your_locale" to set
                 it in "docker run".
        ****************************************************
    '
fi
locale-gen $locale
dpkg-reconfigure locales

# Create template database and run latest migrations
echo "Creating GC2 template database and user $PGUSER"
service postgresql start && \
	psql postgres -U postgres -c "CREATE USER $PGUSER WITH CREATEDB SUPERUSER PASSWORD '$GC2_PASSWORD'" &&\
    createdb template_geocloud -T template0 --encoding UTF-8 --locale $locale &&\
	psql template_geocloud -c "create extension postgis"  &&\
	psql template_geocloud -c "create extension pgcrypto"  &&\
	psql template_geocloud -c "create extension pgrouting"  &&\
    psql template_geocloud -f /var/www/geocloud2/public/install/geometry_columns_join.sql  &&\

	createdb mapcentia  &&\
	psql mapcentia -c "CREATE TABLE users\
		(screenname character varying(255),\
  		pw character varying(255),\
  		email character varying(255),\
  		zone character varying,\
  		parentdb varchar(255),\
  		created timestamp with time zone DEFAULT ('now'::text)::timestamp(0) with time zone)"  &&\

	createdb gc2scheduler -T template0 --encoding UTF-8 --locale $locale &&\
	psql gc2scheduler -c "CREATE TABLE jobs (
        id serial,
        name character varying(255),
        url character varying(255),
        cron character varying(255),
        schema character varying(255),
        epsg character varying(255),
        type character varying(255),
        min character varying,
        hour character varying,
        dayofmonth character varying,
        month character varying,
        dayofweek character varying,
        encoding character varying(255),
        lastcheck boolean,
        lasttimestamp timestamp with time zone,
        db character varying(255),
        extra character varying(255)
    );" &&\

	cd /var/www/geocloud2 && git pull &&\
	cd /var/www/geocloud2/app/conf/migration/ && ./run &&\
	service postgresql stop
exec su postgres -c "/usr/lib/postgresql/9.4/bin/postgres -D /var/lib/postgresql/9.4/main -c config_file=/etc/postgresql/9.4/main/postgresql.conf"