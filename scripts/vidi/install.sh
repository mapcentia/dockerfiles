#!/bin/bash

#
# Check Docker
#

VERSION=$(docker info | grep 'Server Version')
if [ "$VERSION" = "" ]; then
    echo "Docker is not installed or the you don't have permission to run Docker."
    exit
else
    echo "Docker info: $VERSION"
fi

docker network create --subnet=172.18.0.0/16 gc2net


LOCALE=$(locale | grep LANG= | grep -o '[^=]*$')
echo "Locale [$LOCALE]"
read CONF
if [ "$CONF" != "" ]; then
    LOCALE=$CONF
fi

TIMEZONE=$(date +%Z)
echo "Timezone [$TIMEZONE]"
read CONF
if [ "$CONF" != "" ]; then
    TIMEZONE=$CONF
fi



echo "Which backend?"
select yn in "GC2" "CartoDB"; do
    case $yn in
        GC2 ) BACKEND="gc2"; break;;
        CartoDB ) BACKEND="cartodb"; break;;
    esac
done

check () {
    flag=0
    if [[ $(docker ps -a --filter="name=$1" | grep $1$) ]]
        then
                echo "Remove existing $1 container [y/N]"
                read CONF
                if [ "$CONF" = "y" ]; then
                        docker rm -f $1
                        return 1
                fi
        else
                return 1
    fi
}

#
# Vidi data
#

if [[ $(docker ps -a --filter="name=vidi-data" | grep vidi-data) ]]
        then
                echo "vidi-data already exists. Doing nothing."
        else
                echo "Create config files for Vidi on host [y/N]"
                read CONF
                if [ "$CONF" = "y" ]; then
                        docker run \
                            --rm -i \
                            -v $PWD/vidi/config:/tmp mapcentia/vidi cp /root/vidi/config/config.js /tmp -R

                        docker run \
                            --rm -i \
                            -v $PWD/vidi/config:/tmp mapcentia/vidi cp /root/vidi/config/_variables.less /tmp -R
                fi

                #Create a persistence volume for Vidi.
                echo "Creating a persistence volume for vidi...."
                docker create --name vidi-data mapcentia/vidi
        fi

#
# Vidi
#

check vidi
if [[ $? = 1 ]]
    then
        echo "Creating the Vidi container...."
        docker create \
                --name vidi \
                --volumes-from vidi-data \
                --net gc2net \
                --ip 172.18.0.31 \
                --hostname vidi \
                -e TIMEZONE="$TIMEZONE" \
                -e BACKEND="$BACKEND" \
                -v $PWD/vidi/config:/root/vidi/config \
                -p 3000:3000 \
                -t mapcentia/vidi

fi

#
# Run Docker ps
#

docker ps -a