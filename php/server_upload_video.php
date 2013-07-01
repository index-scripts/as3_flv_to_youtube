<?php

error_reporting(E_ERROR);  
//error_reporting(E_ALL);  

ini_set('memory_limit', '256M');
ini_set("max_execution_time", "60");

//$uploadPath = tempnam("temp/", "FOO");

$success = 0;
$result = '';

$im = $GLOBALS["HTTP_RAW_POST_DATA"];

//if (move_uploaded_file($_FILES['Filedata']['tmp_name'], $uploadPath)) 
if ($im) 
{
	$filename = "../temp/tempfile".time()."x.flv";
	$fp = fopen($filename, 'w'); 
	fwrite($fp, $im);
	fclose($fp);
	
	require_once("private/serects.php");
	require_once('Zend/Loader.php');
	Zend_Loader::loadClass('Zend_Gdata_YouTube');
	Zend_Loader::loadClass('Zend_Gdata_ClientLogin');

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
	
	/*
	$yt->registerPackage('Zend_Gdata_Geo');
	$yt->registerPackage('Zend_Gdata_Geo_Extension');
	$where = $yt->newGeoRssWhere();
	$position = $yt->newGmlPos('37.0 -122.0');
	$where->point = $yt->newGmlPoint($position);
	$myVideoEntry->setWhere($where);
	*/
	
	$uploadUrl = 'http://uploads.gdata.youtube.com/feeds/api/users/default/uploads';
	
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