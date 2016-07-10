<?php
/**
 * Created by PhpStorm.
 * User: john
 * Date: 3/18/15
 * Time: 12:06 PM
 */

define("PROFILE_IMAGE_PATH", "http://wi-pic.us/media/images/profile/");
class MediaFunctions {

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

    public function returnProfilePic($user, $userid){
        $result = mysql_query("SELECT pictureName FROM wipic.users WHERE Username = '$user'") or die(mysql_error());
        if($result){
            $row_sections = mysql_fetch_array($result);
            $imageName = $row_sections['pictureName'];

            if($imageName != null){
                $imageFullPath = PROFILE_IMAGE_PATH . $userid ."/".$imageName;
                return $imageFullPath;
            }
            else{
                return false;
            }
        }
    }
}
/*

private function imageCreateFromFile($filename) {

    //if (!file_exists($filename)) {
    //    throw new InvalidArgumentException('File "'.$filename.'" not found.');
    //}

    switch ( strtolower( pathinfo( $filename, PATHINFO_EXTENSION ))) {
        case 'jpeg':
        case 'jpg':
            return imagecreatefromjpeg($filename);
            break;

        case 'png':
            return imagecreatefrompng($filename);
            break;

        case 'gif':
            return imagecreatefromgif($filename);
            break;

        default:
            throw new InvalidArgumentException('File "'.$filename.'" is not valid jpg, png or gif image.');
            break;
    }

}
if(isset($_POST['userid']) && !empty($_POST['userid'])){

    $id = $_POST['userid'];
    $uploaddir = '/var/www/media/images/'.$id.'/';
    $uploadfile = $uploaddir. basename($_FILES['userfile']['name']);
    $tmpFile = $_FILES['userfile']['tmp_name'];

    $response = array("success" => 0, "error" => 0, "imageName" => basename($_FILES['userfile']['name']));

    if(!file_exists(($uploaddir)))
        $dirMade = mkdir($uploaddir);
    else
        $dirMade = true;


    if($dirMade){
        $moveResult = move_uploaded_file($tmpFile, $uploadfile);
        $response["success"] = 1;
        echo(json_encode($response));
    }
    else{
        $response["error"] = 1;
        echo(json_encode($response));
    }
}else{
    echo "Access Denied";
}
*/
