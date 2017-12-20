#!/usr/bin/env bash

# GC2
curl  https://raw.githubusercontent.com/mapcentia/dockerfiles/master/scripts/gc2/install.sh --create-dirs -o $PWD/scripts/gc2/install.sh
curl  https://raw.githubusercontent.com/mapcentia/dockerfiles/master/scripts/gc2/start.sh --create-dirs -o $PWD/scripts/gc2/start.sh
curl  https://raw.githubusercontent.com/mapcentia/dockerfiles/master/scripts/gc2/update.sh --create-dirs -o $PWD/scripts/gc2/update.sh
curl  https://raw.githubusercontent.com/mapcentia/dockerfiles/master/scripts/gc2/migrate.sh --create-dirs -o $PWD/scripts/gc2/migrate.sh
curl  https://raw.githubusercontent.com/mapcentia/dockerfiles/master/scripts/gc2/stop.sh --create-dirs -o $PWD/scripts/gc2/stop.sh

# Vidi
curl  https://raw.githubusercontent.com/mapcentia/dockerfiles/master/scripts/vidi/install.sh --create-dirs -o $PWD/scripts/vidi/install.sh
curl  https://raw.githubusercontent.com/mapcentia/dockerfiles/master/scripts/vidi/start.sh --create-dirs -o $PWD/scripts/vidi/start.sh
curl  https://raw.githubusercontent.com/mapcentia/dockerfiles/master/scripts/vidi/stop.sh --create-dirs -o $PWD/scripts/vidi/stop.sh
curl  https://raw.githubusercontent.com/mapcentia/dockerfiles/master/scripts/vidi/build.sh --create-dirs -o $PWD/scripts/vidi/build.sh
curl  https://raw.githubusercontent.com/mapcentia/dockerfiles/master/scripts/vidi/pull.sh --create-dirs -o $PWD/scripts/vidi/pull.sh
