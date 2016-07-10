<?php



if(isset($_GET['tag']) && !empty($_GET['tag'])){
    $tag = filter_input(INPUT_GET, 'tag');

    require_once 'image.php';

    $image = new MediaFunctions();

    if($tag == 'profilepicture'){
        if(isset($_GET['username']) && !empty($_GET['username']) &&
           isset($_GET['userid']) && !empty($_GET['userid'])){

            $username = filter_input(INPUT_GET, 'username');
            $userID = filter_input(INPUT_GET, 'userid');

            // response Array
            $response = array("tag" => "profilepicture", "success" => "0", "error" => "0", "image" => "");
            $imagePath = $image->returnProfilePic($username, $userID);
            if($imagePath){
                $response["success"] = "1";
                $response["image"] = $imagePath;
                echo json_encode($response);
            }
            else {
                $response["error"] = "1";
                echo json_encode($response);
            }
        }
    }else{
        echo "Access Denied";
    }
}else{
    echo "Access Denied";
}
