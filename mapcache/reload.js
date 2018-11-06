var exec = require('child_process').exec;
var fs = require("fs");
var path = require('path');

var file = "/etc/apache2/sites-enabled/mapcache.conf";

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

        fs.readdir("/var/www/geocloud2/app/wms/mapcache/", function (err, files) {
            var targetFiles = files.filter(function (file) {
                return path.extname(file).toLowerCase() === ".xml";
            });

            console.log(targetFiles)

            var length = targetFiles.length;
            var count = 0;
            exec('echo "" > ' + file);
            targetFiles.forEach(function (targetFile) {
                var db = targetFile.split('.')[0];

                exec('echo "MapCacheAlias /mapcache/' + db + ' /var/www/geocloud2/app/wms/mapcache/' + targetFile + '" >> ' + file, function (error, stdout, stderr) {
                    count++;
                    if (error !== null) {
                        console.log(error);
                    }
                    if (count === length)
                        exec("service apache2 reload", function (error, stdout, stderr) {
                            if (error !== null) {
                                console.log(error);
                            }
                            console.log(stdout);

                        });
                });
            });
        })
    });
}
