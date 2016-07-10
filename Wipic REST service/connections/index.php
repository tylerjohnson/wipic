<?php
/**
 * File to handle all API requests
 * Accepts GET and POST
 *
 * Each request will be identified by TAG
 * Response will be JSON data
 *
 * check for GET and POST request
 */

//GET is for login/logout, POST is for registration/update

if (isset($_GET['tag']) && !empty($_GET['tag'])){

    $tag = $_GET['tag'];

    // include db handler
    require_once 'DB_Connections.php';
    $db = new DB_Connections();

    if($tag == 'usernames'){

        // response Array
        $response = array("tag" => "usernames", "success" => "0", "error" => "0", "users" => "");

        $users = $db->returnAllUsers();

        if($users != false){
            $response["success"] = "1";
            $response["users"] = $users;
            echo json_encode($response);
        }
        else {
            $response["error"] = "1";
            echo json_encode($response);
        }
    }
    else if($tag == 'newfriendrequest'){
        if(isset($_GET['requester']) && !empty($_GET['requester']) &&
             isset($_GET['requestee']) && !empty($_GET['requestee'])){
            $requester = filter_input(INPUT_GET, 'requester');
            $requestee = filter_input(INPUT_GET, 'requestee');

            // response Array
            $response = array("tag" => "newfriendrequest", "success" => "0", "error" => "0");

            if($db->createFriendRequest($requester, $requestee)){
                $response["success"] = "1";
            }
            else{
                $response["error"] = "1";
            }
            echo json_encode($response);
        }
    }
    else if($tag == 'acceptdenyrequest'){
        if(isset($_GET['accepter']) && !empty($_GET['accepter']) &&
            isset($_GET['acceptee']) && !empty($_GET['acceptee']) &&
            isset($_GET['status']) && !empty($_GET['status'])){
            $accepter = filter_input(INPUT_GET, 'accepter');
            $acceptee = filter_input(INPUT_GET, 'acceptee');
            $status = filter_input(INPUT_GET, 'status');

            // response Array
            $response = array("tag" => "acceptdenyrequest", "success" => "0", "error" => "0");

            if($db->acceptOrDenyFriendRequest($accepter, $acceptee, $status)){
                $response["success"] = "1";
            }
            else{
                $response["error"] = "1";
            }
            echo json_encode($response);
        }
    }
    else if($tag == 'userfriends'){
        if(isset($_GET['username']) && !empty($_GET['username'])){
            $username = filter_input(INPUT_GET, 'username');

            // response Array
            $response = array("tag" => "userfriends", "success" => "0", "error" => "0", "users" => "");

            $users = $db->returnFriendList($username);
            if($users != false){
                $response["success"] = "1";
                $response["users"] = array($users);
                echo json_encode($response);
            }
            else {
                $response["error"] = "1";
                echo json_encode($response);
            }
        }
    }
    else if($tag == 'userrequests'){
        if(isset($_GET['username']) && !empty($_GET['username'])){
            $username = filter_input(INPUT_GET, 'username');

            // response Array
            $response = array("tag" => "userrequests", "success" => "0", "error" => "0", "users" => "");

            $users = $db->returnFriendRequests($username);
            if($users != false){
                $response["success"] = "1";
                $response["users"] = array($users);
                echo json_encode($response);
            }
            else {
                $response["error"] = "1";
                echo json_encode($response);
            }
        }
    }
    else{
        echo "Access Denied";
    }

}else {
    echo "Access Denied";
}
