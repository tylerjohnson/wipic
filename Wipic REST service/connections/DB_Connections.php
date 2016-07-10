<?php

class DB_Connections {

    private $db;

    // constructor
    function __construct() {
        require_once '../account/DB_Connect.php';
        //connecting to database
        $this->db = new DB_Connect();
        $this->db->connect();
    }

    // destructor
    function __destruct(){

    }

    public function returnAllUsers(){
        $result = mysql_query("SELECT Username FROM wipic.users") or die(mysql_error());

        $no_of_rows = mysql_num_rows($result);

        $users["count"] = $no_of_rows;
        if($no_of_rows > 0){
            $count = 1;
            while($row_sections = mysql_fetch_array($result))
            {
                $users["usernames"][$count]= $row_sections['Username'];
                $count++;
            }
            $result = mysql_fetch_array($result);
            return $users;
        }
        else{
            //Error occured
            return false;
        }
    }

    public function createFriendRequest($requester, $requestee){
        $result = mysql_query("INSERT INTO wipic.connections(Username, UserFriend, Accepted) VALUES('$requester', '$requestee', '0')") or die(mysql_error());

        // check for successful store
        if ($result) {
            // return user details
            return true;
        } else {
            return false;
        }
    }

    public function acceptOrDenyFriendRequest($accepter, $acceptee, $acceptStatus){
        if($acceptStatus == '1'){
            $result = mysql_query("UPDATE wipic.connections SET Accepted = '1' Where Username = '$acceptee' And UserFriend = '$accepter'") or die(mysql_error());
            if($result){
                //Check for the situation where accepter has also sent a friend request
                $result = mysql_query("SELECT * FROM wipic.connections WHERE Username = '$accepter' And UserFriend = '$acceptee'") or die(mysql_error());
                // check for result
                $no_of_rows = mysql_num_rows($result);
                if($no_of_rows == 1){
                    $result = mysql_query("UPDATE wipic.connections SET Accepted = '1' Where Username = '$accepter' And UserFriend = '$acceptee'") or die(mysql_error());
                }
                else {
                    $result = mysql_query("INSERT INTO wipic.connections(Username, UserFriend, Accepted) VALUES('$accepter', '$acceptee', '1')") or die(mysql_error());
                }
                return true;
            }
            else{
                return false;
            }
        }
        else{
            $result = mysql_query("DELETE FROM wipic.connections WHERE Username = '$acceptee' And UserFriend = '$accepter'") or die(mysql_error());
        }
    }

    /**
     * @param $username
     * @return array|bool|resource
     */
    public function returnFriendList($username){
        $result = mysql_query("SELECT UserFriend FROM wipic.connections WHERE Username = '$username' And Accepted = '1'") or die(mysql_error());

        $no_of_rows = mysql_num_rows($result);
        $users["count"] = $no_of_rows;
        if($no_of_rows > 0){
            $count = 1;
            while($row_sections = mysql_fetch_array($result))
            {
                $users["UserFriend"][$count]= $row_sections['UserFriend'];
                $count++;
            }
            $result = mysql_fetch_array($result);
            return $users;
        }
        else{
            //user has no friends
            return false;
        }
    }

    public function returnFriendRequests($username){
        $result = mysql_query("SELECT Username FROM wipic.connections WHERE UserFriend = '$username' And Accepted = '0'") or die(mysql_error());

        $no_of_rows = mysql_num_rows($result);
        $users["count"] = $no_of_rows;
        if($no_of_rows > 0){
            $count = 1;
            while($row_sections = mysql_fetch_array($result))
            {
                $users["UserRequests"][$count]= $row_sections['Username'];
                $count++;
            }
            $result = mysql_fetch_array($result);
            return $users;
        }
        else if($result){
            //user has no requests
            return $users;
        }
        else{
            return false;
        }
    }
}
