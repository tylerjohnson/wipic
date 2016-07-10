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

    if($tag == 'login'){

        if (isset($_GET['username']) && !empty($_GET['username']) &&
            isset($_GET['password']) && !empty($_GET['password'])) {

            // get login info
            $username = $_GET['username'];
            $password = $_GET['password'];

            // include db handler
        	require_once 'DB_Functions.php';

            $db = new DB_Functions();

            // response Array
            $response = array("tag" => "login", "success" => "0", "error" => "0");

            $user = $db->loginByUsernameAndPassword($username, $password);

            if($user != false){
                $response["success"] = "1";
                echo json_encode($response);
            }else{
                $response["error"] = "1";
                $response["error_msg"] = "Unable to log user in";
                echo json_encode($response);
            }
        }else{
            echo "Access Denied";
        }
    }elseif($tag == 'logout'){
        if(isset($_GET['username']) && !empty($_GET['username'])){
            //get logout info
            $username = $_GET['username'];

            // include db handler
            require_once 'DB_Functions.php';
            $db = new DB_Functions();

            // response Array
            $response = array("tag" => "login", "success" => 0, "error" => 0);

            $user = $db->logoutByUsername($username);

            if($user != false){
                $response["success"] = "1";
                echo json_encode($response);
            }else{
                $response["error"] = "1";
                $response["error_msg"] = "Unable to log out user";
                echo json_encode($response);
            }

        }
    }else{
        echo "Access Denied";
    }

}elseif(isset($_POST['tag']) && !empty($_POST['tag'])){

    $tag = $_POST['tag'];

    if($tag == 'register'){


        if(isset($_POST['email']) && !empty($_POST['email']) &&
            isset($_POST['firstName']) && !empty($_POST['firstName']) &&
            isset($_POST['lastName']) && !empty($_POST['lastName']) &&
            isset($_POST['username']) && !empty($_POST['username']) &&
            isset($_POST['password']) && !empty($_POST['password']) ) {

            // include db handler
            require_once 'DB_Functions.php';

            $db = new DB_Functions();

            $email = $_POST['email'];
            $username = $_POST['username'];
            $password = $_POST['password'];
            $fName = $_POST['firstName'];
            $lName = $_POST['lastName'];

            if ($db->isUserExisted($email)){
                $response["success"] = "0";
                $response["error"] = "2";
                $response["error_msg"] = "The email provided is already in use.";
                echo json_encode($response);
            }elseif($db->isUsernameTaken($username)){
                $response["success"] = "0";
                $response["error"] = "2";
                $response["error_msg"] = "The username provided is already in use.";
                echo json_encode($response);
            }else{

                // store user
                $user = $db->storeUser($email, $username, $password, $fName, $lName);

                $db->sendValidation($email, $password, $user["Password"], $user["Username"]);

                if ($user) {
                    // user stored successfully
                    $response["success"] = "1";
                    $response["error"] = "0";
                    $response["ID"] = $user["PersonID"];
                    $response["user"]["email"] = $user["Email"];
                    $response["user"]["Username"] = $user["Username"];
                    $response["user"]["FirstName"] = $user["FirstName"];
                    $response["user"]["LastName"] = $user["LastName"];
                    $response["user"]["Status"] = $user["Status"];
                    $response["user"]["Active"] = $user["Active"];
                    $response["user"]["created_at"] = $user["RegDate"];
                    $response["user"]["logincount"] = $user["LoginCount"];
                    echo json_encode($response);
                } else {
                    // user failed to store
                    $response["error"] = "2";
                    $response["error_msg"] = "User was unsuccessfully added to the database.";
                    echo json_encode($response);
                }

            }

        }else{
            echo "Access Denied";
        }

    }elseif($tag == "update"){
        if(isset($_POST['username']) && !empty($_POST['newPassword']) && !empty($_POST['oldPassword'])) {
            $username = $_POST['username'];
            $newPassword = $_POST['newPassword'];
            $oldPassword = $_POST['oldPassword'];

            // include db handler
            require_once 'DB_Functions.php';

            $db = new DB_Functions();

            $db->changeUserPassword($username, $oldPassword, $newPassword);
        }
        else {
            echo "Access Denied";
        }
    }else{
        echo "Access Denied";
    }

}else {
    echo "Access Denied";
}
