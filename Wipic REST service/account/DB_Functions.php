<?php

class DB_Functions {

    private $db;

    // constructor
    function __construct() {
        require_once 'DB_Connect.php';
        //connecting to database
        $this->db = new DB_Connect();
        $this->db->connect();
    }

    // destructor
    function __destruct(){

    }

    /**
     * Storing new user
     * returns user details
     * @param $email
     * @param $username
     * @param $password
     * @param $fName
     * @param $lName
     * @return array|bool
     */

    public function storeUser($email, $username, $password, $fName, $lName) {
        $hash = $this->hashSSHA($password);
        $encrypted_password = $hash["encrypted"]; // encrypted password
        $salt = $hash["salt"]; // salt
        $result = mysql_query("INSERT INTO wipic.users(Email, Username, Password, FirstName, LastName, LoginCount, Status, Salt, Active, RegDate) VALUES('$email', '$username', '$encrypted_password', '$fName', '$lName', '0', '0', '$salt', '0', 'NOW()')") or die(mysql_error());
        // check for successful store
        if ($result) {
            // get user details
            $result = mysql_query("SELECT * FROM wipic.users WHERE Username = '$username'") or die(mysql_error());
            // return user details
            return mysql_fetch_array($result);
        } else {
            return false;
        }
    }


    /**
     * Get user by email and password
     * @param $username
     * @param $password
     * @return array|bool|resource
     */

    public function loginByUsernameAndPassword($username, $password) {
        $result = mysql_query("SELECT * FROM wipic.users WHERE Username = '$username'") or die(mysql_error());
        // check for result
        $no_of_rows = mysql_num_rows($result);

        if ($no_of_rows == 1) {
            $result = mysql_fetch_array($result);
            $salt = $result['Salt'];
            $encrypted_password = $result['Password'];
            $activeAccount = $result["Active"];
            $hash = $this->checkhashSSHA($salt, $password);
            // check for password equality
            if ($encrypted_password == $hash && $activeAccount == "1") {
                // user authentication details are correct
                $flag1 = $this->updateLoginStatus($username, 'login');
                $flag2 = $this->updateLoginCount($username, $result['LoginCount']);

                if(!$flag1){
                    return false;
                }elseif(!$flag2){
                    return false;
                }
                return $result;

            }
            else{
                return false;
            }
        } else {
            // user not found
            return false;
        }

    }


    /**
     * Logs out the user
     * @param $username
     * @return bool
     */
    public function logoutByUsername($username){

        $status = $this->updateLoginStatus($username, 'logout');

        if($status == false){
            return false;
        }

        return true;
    }

    /**
     * Update current login status
     * @param $username
     * @param $command
     * @return bool
     */
    public function updateLoginStatus($username, $command){

        if($command == 'login'){
            $result = mysql_query("UPDATE wipic.users SET Status = '1' Where Username = '$username'");
            if($result){
                return true;
            }else{
                return false;
            }
        }elseif($command == 'logout') {
            $result = mysql_query("UPDATE wipic.users SET Status = '0' Where Username = '$username'");
            if ($result) {
                return true;
            } else {
                return false;
            }
        }else{
            return false;
        }
    }

    /**
     * Update the login count for the user
     * @param $username
     * @param $currentCount
     * @return bool
     */
    public function updateLoginCount($username, $currentCount){
        $currentCount++;
        $result = mysql_query("UPDATE wipic.users SET LoginCount = '$currentCount' Where Username = '$username'");
        if($result){
            return true;
        }else{
            return false;
        }
    }

    /**
     * Checks if the email is used by another user already
     * @param $email
     * @return bool
     */
    public function isUserExisted($email) {
        $result = mysql_query("SELECT Email from wipic.users WHERE Email = '$email'");
        $no_of_rows = mysql_num_rows($result);

        if ($no_of_rows > 0) {
            // user existed
            return true;
        } else {
            // user not existed
            return false;
        }
    }

    /**
     * Checks if the username is used by another user already
     * @param $username
     * @return bool
     */
    public function isUsernameTaken($username){
        $result = mysql_query("SELECT Username from wipic.users WHERE Username = '$username'");
        $no_of_rows = mysql_num_rows($result);

        if ($no_of_rows > 0) {
            // username exists
            return true;
        } else {
            // username does not exist
            return false;
        }
    }

    /**
     * Once the user has been added to the database
     * a verification email is sent to their email
     * @param $email
     * @param $password
     * @param $hashPassword
     * @param $username
     * @return bool
     */
    public function sendValidation($email, $password, $hashPassword, $username){

        $to      = $email; // Send email to our user
        $subject = 'WiPic Signup | Verification'; // Give the email a subject
        $message = '

        Thanks for signing up!
        Your account has been created, you can login with the following credentials after you have activated your account by pressing the url below.

        ------------------------
        Username: '.$username.'
        Password: '.$password.'
        ------------------------

        Please click this link to activate your account:
        http://wi-pic.us/account/verification.php?userName='.$username.'&hash='.$hashPassword.'

        '; // Our message above including the link

        $headers = 'From:noreply@wi-pic.us' . "\r\n"; // Set from headers
        $mail = mail($to, $subject, wordwrap($message), $headers); // Send our email
        if($mail){
            return true;
        }else{
            return false;
        }
    }

    /**
     * Sets the active bit to 1 allowing user to login
     * @param $username
     * @param $hash
     * @return bool
     */
    public function validateUser($username, $hash){
        $result = mysql_query("UPDATE wipic.users SET Active = '1' Where Username = '$username' And Password = '$hash'") or die(mysql_error());
        if($result){
            return true;
        }else{
            return false;
        }
    }

    /**
     * @param $username
     * @param $oldPassword
     * @param $newPassword
     * @return bool
     */
    public function changeUserPassword($username, $oldPassword, $newPassword){

        $result = mysql_query("SELECT * FROM wipic.users WHERE Username = '$username'") or die(mysql_error());
        // check for result
        $no_of_rows = mysql_num_rows($result);

        if ($no_of_rows == 1) {
            $result = mysql_fetch_array($result);
            $salt = $result['Salt'];
            $encrypted_password = $result['Password'];
            $hash = $this->checkhashSSHA($salt, $oldPassword);

            // check for password equality
            if ($encrypted_password == $hash) {
                $newHash = $this->checkhashSSHA($salt, $newPassword);
                $result = mysql_query("UPDATE wipic.users SET Password = '$newHash' Where Username = '$username' And Password = '$hash'") or die(mysql_error());
                return true;
            }
            else{
                return false;
            }
        } else {
            // user not found
            return false;
        }
    }
    /**
     * Encrypting password
     * @param password
     * returns salt and encrypted password
     * @return array
     */
    public function hashSSHA($password) {

        $salt = sha1(rand());
        $salt = substr($salt, 0, 10);
        $encrypted = base64_encode(sha1($password . $salt, true) . $salt);
        $hash = array("salt" => $salt, "encrypted" => $encrypted);
        return $hash;
    }

    /**
     * Decrypting password
     * @param $salt
     * @param $password
     * @return string
     * returns hash string
     */
    public function checkhashSSHA($salt, $password) {

        $hash = base64_encode(sha1($password . $salt, true) . $salt);

        return $hash;
    }
}
