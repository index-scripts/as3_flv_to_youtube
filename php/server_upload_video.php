<?php

error_reporting(E_ERROR);  

ini_set('memory_limit', '256M');
ini_set("max_execution_time", "60");

$success = 0;
$result = '';

// recived binary data from swf
$im = $GLOBALS["HTTP_RAW_POST_DATA"];

if ($im) 
{
	// temporary save file inside temp folder
	$filename = "../temp/tempfile".time()."x.flv";
	$fp = fopen($filename, 'w'); 
	fwrite($fp, $im);
	fclose($fp);
	
	/*	include serects and youtube php api
		the serects.php file contains these informations:
		$_email			your google account name(email)
		$_pwd			your google account password
		$_developerKey	the developer key we use for uploading
	*/
	require_once("private/serects.php");
	require_once('Zend/Loader.php');
	Zend_Loader::loadClass('Zend_Gdata_YouTube');
	Zend_Loader::loadClass('Zend_Gdata_ClientLogin');

	/*	use your google account request a client login into youtube, get authorization/accessToken then create httpclient, 
		which we need for initializing YouTube instance.
	*/
	$authenticationURL= 'https://www.google.com/accounts/ClientLogin';
	$httpclient = Zend_Gdata_ClientLogin::getHttpClient(
					  $username = $_email,
					  $password = $_pwd,
					  $service = 'youtube',
					  $client = null,
					  $source = 'Upload Flv Test',
					  $loginToken = null,
					  $loginCaptcha = null,
					  $authenticationURL
				   );
	
	$developerKey = $_developerKey;
	$applicationId = 'Upload Flv Test';
	$clientId = 'My video upload client - v1';
	
	
	// create YouTube instance, create video entry, assign datas for our new video entry
	$yt = new Zend_Gdata_YouTube($httpclient, "Upload Flv Test", NULL, $developerKey);
	
	$myVideoEntry = new Zend_Gdata_YouTube_VideoEntry();
	
	$filesource = $yt->newMediaFileSource($filename);
	$filesource->setContentType('video/x-flv');
	$filesource->setSlug('resultx.flv');
	$myVideoEntry->setMediaSource($filesource);
	
	$myVideoEntry->setVideoTitle('My Test Movie');
	$myVideoEntry->setVideoDescription('My Test Movie');
	$myVideoEntry->setVideoCategory('Autos');
	$myVideoEntry->SetVideoTags('cars, funny');
	$myVideoEntry->setVideoDeveloperTags(array('mydevtag', 'anotherdevtag'));
	
	$uploadUrl = 'http://uploads.gdata.youtube.com/feeds/api/users/default/uploads';
	
	// start upload new entry into youtube, if success we will get new video state, which contains information like video id, we can use it generate url to the video site
	try 
	{
		$newEntry = $yt->insertEntry($myVideoEntry, $uploadUrl, 'Zend_Gdata_YouTube_VideoEntry');
		
		$state = $newEntry->getVideoState();
		if ($state) {
			endWith(1, $newEntry->getVideoId());
		} else {
			endWith(0, "Not able to retrieve the video status information yet.");
		}
	}
	 catch (Zend_Gdata_App_HttpException $httpException) 
	{
		endWith(0, $httpException->getRawResponseBody());
	}
	 catch (Zend_Gdata_App_Exception $e) 
	{
		endWith(0, $e->getMessage());
	}
	
	endWith(0, "unknown error");
} 
else
{
	endWith(0, "No file uploaded.");
}

function endWith($success, $result)
{
	if($filename) unlink($filename);
	die("s=".$success."&res=".$result);
}

?>