#!/bin/bash
set -e

export PGPASSWORD=$PASSWORD
export PGUSER=$USER
export PGPORT=5432
export AWSACCESSKEYID=$AWSACCESSKEYID
export AWSSECRETACCESSKEY=$AWSSECRETACCESSKEY
if [ -z ${HOST+x} ]; then
  export PGHOST=postgis
else
  export PGHOST=$HOST
fi

echo $PGHOST

BACKUPDIR=backups

echo `date`

YEAR=`date +%Y`						    # Year e.g. 2008
MONTH=`date +%m`				    	# MONTH e.g. 08
DAY=`date +%d`						    # Date of the Month e.g. 27
DNOW=`date +%u`						    # Day number of the week 1 to 7 where 1 represents Monday

BACKUPALTS="year/${YEAR}
month/${MONTH}
day/${DAY}"

function mkdbbackup {
    BLACKLIST=$1[@]
	BACKUPBASE="${BACKUPDIR}/${PGHOST}"
	BACKUPLATEST="${BACKUPBASE}/latest"
	if [ ! -d $BACKUPDIR ]; then
            mkdir $BACKUPDIR
    fi
	if [ ! -d $BACKUPLATEST ]; then
		mkdir -vp $BACKUPLATEST
	else
		rm -fv $BACKUPLATEST/*
	fi
	bl=("${!BLACKLIST}")
	for DATABASE in `psql postgres -c "SELECT datname FROM pg_database" | grep -v "datname\|(\|---"`
    	do
    	    ix=$( printf "%s\n" "${bl[@]}" | grep -n -m 1 "^${DATABASE}$" | cut -d ":" -f1 )
    	    if [[ -z $ix ]]
    	    then
    	       DUMPPATH="${BACKUPLATEST}/${DATABASE}.bak"
               echo "Backing up: ${PGHOST}.${DATABASE} to ${DUMPPATH}"
               pg_dump --format=c  ${DATABASE} > ${DUMPPATH}
    	    else
    	        echo "${DATABASE} is skipped"
            fi
    	done

    	for BDIR in $BACKUPALTS
            do
                TARGETDIR="${BACKUPBASE}/${BDIR}"
                if [ ! -d $TARGETDIR ]; then
                        mkdir -vp $TARGETDIR
                else
                        rm -fv $TARGETDIR/*
                fi
                cp -v $BACKUPLATEST/* $TARGETDIR/.
            done
}

echo "_ts_ host1 start" `date`
skip=(template0 $SKIP)
mkdbbackup skip
echo "_ts_ host1 end" `date`

s3fs $BUCKET /mnt
rsync -avrz --delete --inplace --stats $BACKUPDIR/* /mnt
fusermount -u /mnt

exec "$@"
