var express = require('express');
var bodyParser = require('body-parser');
var exec = require('child_process').exec;
var fs = require("fs");

var app = express();

var file = "/etc/apache2/sites-enabled/mapcache.conf";
//var file = "mapcache.conf";

app.use(express.static('.'));
app.use(bodyParser.json());

app.get('/reload-fpm', function (request, res) {
    console.log("reload");
    res.setHeader('Content-Type', 'application/json');
    exec("/usr/bin/supervisorctl -c /etc/supervisor/conf.d/supervisord.conf restart php5-fpm", function (error, stdout, stderr) {
        if (error !== null) {
            res.send({success: false, message: error});
        } else {
            res.send({success: true, message: stdout});
        }
    });
});
app.listen(1339);