<?php
namespace app\conf;

class Connection
{
    static $param = array(
        "postgishost" => "YOUR_HOST",
        "postgisdb" => "postgres",
        "postgisuser" => "gc2",
        "postgisport" => "5432",
        "postgispw" => "YOUR_PASSWORD",
        "pgbouncer" => false,
    );
}