#GC2conflict basic
Dette er installationsvejledningen til GC2conflict koblet til en eksisterende PostGIS database. Den bruger en neddroslet vsersion af GC2, kaldet GC2basic, til udstilling af API'er og håndtering af metadata.

##Forberedelser
Start med at lave foldere på hosten. Disse skal bruges til konfigurationsfiler, så det ikke er nødvendigt at rette dem inde i containeren.

    mkdir ~/tmp && \
    mkdir ~/gc2 && \
    mkdir ~/gc2conflict

tmp folderen skal være skrivebar indefra Docker containeren.

##Installer GC2basic
Vi antager i guiden, at PostGreSQL og GC2conflict kører på samme server.

Kopier konfigurationsfilerne ud fra containeren, så vi har dem på hosten.
    
    docker run --rm -i \
        -v ~/gc2:/tmp mapcentia/gc2basic \
        cp /var/www/geocloud2/app/conf /tmp -R
        
Find hvilken IP hosten har indefra containeren (Se under gateway) og sæt denne i ~/gc2/conf/Connection.php sammen med login creds. PostgreSQL brugeren skal have læse-privilegier til databasen, som skal søges i, samt privilegier til at oprette nye databaser (Se trin længere nede).

    docker run --rm -it ubuntu:trusty route
    
Tjek om PostgreSQL er åben for forbindelser fra containeren (Brug de creds, som du har sat i ovenstående). Hvis ikke så åben op for forbindelse i pg_hba.conf og evt. i postgresql.conf

    docker run \
        --rm \
        -i -t \
        mapcentia/gc2basic psql postgres -h 172.17.42.1 -U postgres -c "SELECT 1"
 
Start en gc2basic container med navnet "gc2".
    
    docker run \
        --name gc2 \
        -p 8080:80 \
        -v ~/gc2/conf:/var/www/geocloud2/app/conf \
        -v ~/tmp:/var/www/geocloud2/app/tmp \
        -d -t \
        mapcentia/gc2basic

Kald install scriptet i en browser og installer GC2 i databasen.

    http://[ip-adresse]:8080/install/dbs.php
    
Opret database til brugerstyring (Ret evt. IP til det rigtige). PostGreSQL brugerens privilegier til oprettelse af databaser kan revokes efter dette trin.

    docker run \
        --rm \
        -v ~/gc2/conf:/var/www/geocloud2/app/conf \
        -t -i mapcentia/gc2basic \
        createdb mapcentia -h 172.17.42.1 -U postgres  &&\
        psql mapcentia -h 172.17.42.1 -U postgres -c "CREATE TABLE users\
        (screenname character varying(255),\
        pw character varying(255),\
        email character varying(255),\
        zone character varying,\
        parentdb varchar(255),\
        created timestamp with time zone DEFAULT ('now'::text)::timestamp(0) with time zone)"
    
Kør seneste database migration

    docker run \
        --rm \
        --volumes-from=gc2 \
        -v ~/gc2/conf:/var/www/geocloud2/app/conf \
        -t -i mapcentia/gc2basic grunt --gruntfile /var/www/geocloud2/Gruntfile.js migration
    
Gå til http://[ip-adresse]:8080 og opret en brugerprofil med samme navn som databasen.

Hvsi du vil opdatere en kørende GC2 container med seneste kode. Altid en god ide at køre migration fra ovenstående trin efter en kode-opdatering.

    docker run \
        --rm \
        --volumes-from=gc2 \
        -t -i mapcentia/gc2basic grunt --gruntfile /var/www/geocloud2/Gruntfile.js production
        
##Installer Geoserver

    docker run --name "geoserver" \
            -d -t \
            mapcentia/geoserver

##Installer GC2Conflict
Kopier konfigurationsfilerne ud fra containeren, så vi har dem på hosten.
    
    docker run --rm -i \
        -v ~/gc2conflict:/tmp mapcentia/gc2conflict \
        bash -c "cd /root/gc2conflict && git pull && cp /root/gc2conflict/app/config /tmp -R"

Ret "host.pg" til i filen ~/gc2conflict/config/nodeConfig.js, så den peger på hostens IP set fra containeren (172.17.42.1)

Ret "host" til i filen ~/gc2conflict/config/browserConfig.js, så den peger på GC2's public adresse (http://[ip-adresse]:8080)

Start en container med navnet "gc2conflict".

    docker run \
        --name gc2conflict\
        -v ~/gc2conflict/config:/root/gc2conflict/app/config \
        --link gc2:gc2 \
        --link geoserver:geoserver \
        -p 80:8080 \
        -d -t mapcentia/gc2conflict
        
Kør Grunt

    docker run \
        --rm \
        --volumes-from=gc2conflict \
        -t -i mapcentia/gc2conflict \
         grunt --gruntfile /root/gc2conflict/Gruntfile.js production 

    
Genstart containeren.
    
    docker restart gc2conflict
     


    docker run \
             --rm \
             -v ~/gc2conflict/config:/root/gc2conflict/app/config \
             --link gc2:gc2 \
             --link geoserver:geoserver \
             -i -t mapcentia/gc2conflict bash



    
