#!/bin/bash

docker exec vidi bash -c "/usr/bin/supervisorctl -c /etc/supervisor/conf.d/supervisord.conf stop vidi"