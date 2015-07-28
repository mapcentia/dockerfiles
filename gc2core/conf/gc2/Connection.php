<?php
namespace app\conf;

class Connection
{
    static $param = array(
        "postgishost" => "postgis",
        "postgisdb" => "postgres",
        "postgisuser" => "gc2",
        "postgisport" => "5432",
        "postgispw" => "1234",
        "pgbouncer" => false,
    );
}