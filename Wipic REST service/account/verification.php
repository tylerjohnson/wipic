<?php

	if(isset($_GET['userName']) && !empty($_GET['userName']) &&
	   isset($_GET['hash']) && !empty($_GET['hash'])){

		$uName = $_GET['userName'];
		$hash = $_GET['hash'];

		require_once 'DB_Functions.php';

		$db = new DB_Functions();

		$flag = $db->validateUser($uName, $hash);

		if($flag){
			echo '<div class="statusmsg">Your account is now active.</div>';
		}else{
			echo '<div class="statusmsg">Invalid approach, please use the link that has been send to your email.</div>';
		}

	}else{
		echo '<div class="statusmsg">Invalid approach, please use the link that has been send to your email.</div>';
	}

?>
