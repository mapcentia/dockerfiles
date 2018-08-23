#!/usr/bin/env bash
cp ~/dockerfiles/scripts/gc2/systemd/* /lib/systemd/system
systemctl enable postgis.service
#systemctl enable elasticsearch.service
systemctl enable gc2core.service
systemctl enable mapcache.service
