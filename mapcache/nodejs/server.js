var express = require('express');
var bodyParser = require('body-parser');
var exec = require('child_process').exec;

var app = express();

app.use(express.static('.'));
app.use(bodyParser.json());

app.get('/reload', function (request, res) {
    console.log("reload");
    res.setHeader('Content-Type', 'application/json');
    exec("service apache2 reload", function (error, stdout, stderr) {
        if (error !== null) {
            console.log(error);
        }
        res.send({success: true});
    });

});

// TODO Check for existing file and add minimal if not

/*
 <mapcache>
    <service type="wmts" enabled="true"/>
 </mapcache>
 */
app.get('/add', function (request, res) {
    // TODO Check if entry is already there
    var db = request.query.db;
    console.log(db);
    exec('echo "MapCacheAlias /mapcache/' + db + ' /var/www/geocloud2/app/wms/mapcache/' + db + '.xml" >> /etc/apache2/sites-enabled/mapcache.conf', function (error, stdout, stderr) {
        if (error !== null) {
            console.log(error);
        }
        res.setHeader('Content-Type', 'application/json');
        exec("service apache2 reload", function (error, stdout, stderr) {
            if (error !== null) {
                console.log(error);
            }
            res.send({success: true});
        });
    });
});
app.listen(1337);