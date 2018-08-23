#!/usr/bin/env bash
cp ~/dockerfiles/scripts/vidi/systemd/* /lib/systemd/system
systemctl enable vidi.service
