docker run \
        --name filebeat \
        --volumes-from gc2core \
        --link logstash:logstash \
        -e "MASTER=logstash:5043" \
        -t -d \
        mapcentia/filebeat