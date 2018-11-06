#!/bin/bash

while true;
	do
		ls /var/www/geocloud2/app/wms/mapcache/*.xml | entr -d node reload.js /_;
	sleep 0.3
done
