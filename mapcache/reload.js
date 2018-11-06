var exec = require('child_process').exec;
var fs = require("fs");

var file = "/etc/apache2/sites-enabled/mapcache.conf";

var dbFile = process.argv[2];
var db = process.argv[2].split('/')[7].split('.')[0];

fs.exists(file, function (exists) {
    if (exists) {
        callback();
    } else {
        fs.writeFile(file, '', function (err, data) {
            console.log("Creating mapcache.conf");
            callback();
        })
    }
});

function callback() {
    fs.readFile(file, function (err, data) {
        if (err) {
            console.log(err);
        }
        console.log(data.toString('utf-8'));
        if (data.toString('utf-8').indexOf('/mapcache/' + db) === -1) {
            exec('echo "MapCacheAlias /mapcache/' + db + ' ' + dbFile + '" >> ' + file, function (error, stdout, stderr) {
                if (error !== null) {
                    console.log(error);
                }
                exec("service apache2 reload", function (error, stdout, stderr) {
                    if (error !== null) {
                        console.log(error);
                    }
                    console.log(stdout);

                });
            });
        } else {
            console.log("Already there");
            exec("service apache2 reload", function (error, stdout, stderr) {
                if (error !== null) {
                    console.log(error);
                } else {
                    console.log(stdout);
                }
            });
        }
    });
}
