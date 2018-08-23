#!/usr/bin/env bash
cp ~/dockerfiles/scripts/gc2/systemd/* /lib/systemd/system
systemctl enable nginx-proxy.service
systemctl enable nginx-letsencrypt.service
