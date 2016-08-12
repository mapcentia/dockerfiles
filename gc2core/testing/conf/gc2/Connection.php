<?php
namespace app\conf;

class Connection
{
    static $param = array(
        "postgishost" => "postgis",
        "postgisdb" => "postgres",
        "postgisuser" => "gc2",
        "postgisport" => "5432",
        "postgispw" => "YOUR_PASSWORD",
        "pgbouncer" => false,
    );
}