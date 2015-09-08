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

app.get('/add', function (request, res) {
    var params = request.body
});

app.listen(1337);