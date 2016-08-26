#!/usr/bin/env bash
curl  https://raw.githubusercontent.com/mapcentia/dockerfiles/master/scripts/gc2/install.sh --create-dirs -o $PWD/scripts/gc2/install.sh
curl  https://raw.githubusercontent.com/mapcentia/dockerfiles/master/scripts/gc2/start.sh --create-dirs -o $PWD/scripts/gc2/start.sh
curl  https://raw.githubusercontent.com/mapcentia/dockerfiles/master/scripts/gc2/update.sh --create-dirs -o $PWD/scripts/gc2/update.sh
curl  https://raw.githubusercontent.com/mapcentia/dockerfiles/master/scripts/gc2/migrate.sh --create-dirs -o $PWD/scripts/gc2/migrate.sh
