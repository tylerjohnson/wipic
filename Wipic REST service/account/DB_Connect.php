<?php

class DB_Connect {

    // constructor
    function __construct() {

    }

    // destructor
    /**
     *
     */
    function __destruct() {

    }

    // Connecting to database
    /**
     * @return resource
     */

    public function connect() {
        require_once 'config.php';
        // connecting to mysql
        $con = mysql_connect(DB_HOST, DB_USER, DB_PASSWORD);
        if(!$con){
            die('Could not connect: ' . mysql_error());
        }
        // selecting database
        $db_selected = mysql_select_db(DB_DATABASE, $con);
        if(!$db_selected){
            die('Can\'t use selected database ' . mysql_error());
        }

        // return database handler
        return $con;
    }

    // Closing database connection
    public function close() {
        mysql_close();
    }

}


