var express = require('express');
var es = require('elasticsearch');
var bodyParser = require('body-parser')

var app = express();

var client = new es.Client({
    hosts: 'localhost:9200'
});

app.use(express.static('.'));
app.use(bodyParser.json());
app.post('/data', function(request, res){

    var params = request.body;

    client.search(params).then(function(result){
        var buckets = result.aggregations.histogram.buckets;
        var data = buckets.map(function(bucket){
            return [
                new Date(bucket.key).getTime(),
                bucket.doc_count
            ];
        });
        res.send(data);
    });
});

app.listen(1337);