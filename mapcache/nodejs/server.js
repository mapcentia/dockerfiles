var express = require('express');
var bodyParser = require('body-parser');
var exec = require('child_process').exec;
var fs = require("fs");

var app = express();

var file = "/etc/apache2/sites-enabled/mapcache.conf";
//var file = "mapcache.conf";

app.use(express.static('.'));
app.use(bodyParser.json());

app.get('/reload', function (request, res) {
    console.log("reload");
    res.setHeader('Content-Type', 'application/json');
    exec("service apache2 reload", function (error, stdout, stderr) {
        if (error !== null) {
            res.send({success: false, message: error});
        } else {
            res.send({success: true, message: stdout});
        }
    });
});

// TODO Check for existing file and add minimal if not

/*
 <mapcache>
 <service type="wmts" enabled="true"/>
 </mapcache>
 */
app.get('/add', function (request, res) {
    var db = request.query.db;

    fs.exists(file, function (exists) {
        if (exists) {
            callback();
        } else {
            fs.writeFile(file, {flag: 'wx'}, function (err, data) {
                console.log("Creating mapcache.conf");
                callback();
            })
        }
    });

    function callback() {
        fs.readFile(file, function (err, data) {
            if (err) {
                res.send({success: false, message: "error"});
            }
            console.log(data.toString('utf-8'));
            if (data.toString('utf-8').indexOf('/mapcache/' + db) === -1) {
                exec('echo "MapCacheAlias /mapcache/' + db + ' /var/www/geocloud2/app/wms/mapcache/' + db + '.xml" >> ' + file, function (error, stdout, stderr) {
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
            } else {
                res.send({success: true, message: "Already there"});
            }
        });
    }

});
app.listen(1337);