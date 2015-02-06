<?php
namespace app\conf;

class Connection
{
    static $param = array(
        "postgishost" => "postgres",
        "postgisdb" => "postgres",
        "postgisuser" => "postgres",
        "postgisport" => "5432",
        "postgispw" => "1234",
        "pgbouncer" => false,
    );
}