<?php

/*

API2 client login, form upload

*/

//error_reporting(E_ALL);  
//ini_set("log_errors" , "1");

ini_set("display_errors" , "0");
error_reporting(E_ALL | E_STRICT);

require_once("private/serects.php");
require_once('Zend/Loader.php'); // the Zend dir must be in your include_path
 
$authenticationURL= 'https://www.google.com/accounts/ClientLogin';
Zend_Loader::loadClass('Zend_Gdata_ClientLogin');
$httpclient = Zend_Gdata_ClientLogin::getHttpClient(
				  $username = $_email,
				  $password = $_pwd,
                  $service = 'youtube',
                  $client = null,
                  $source = 'An App Name', // a short string identifying your application
                  $loginToken = null,
                  $loginCaptcha = null,
                  $authenticationURL
               );

Zend_Loader::loadClass('Zend_Gdata_YouTube');

$developerKey = $_developerKey;
$applicationId = 'Demo Application';
  
  
$yt = new Zend_Gdata_YouTube($httpclient, $applicationId, NULL, $developerKey);

$myVideoEntry = new Zend_Gdata_YouTube_VideoEntry();
$myVideoEntry->setVideoTitle('My Test Movie');
$myVideoEntry->setVideoDescription('My Test Movie');
$myVideoEntry->setVideoCategory('Autos');


$tokenHandlerUrl = 'http://gdata.youtube.com/action/GetUploadToken';
$tokenArray = $yt->getFormUploadToken($myVideoEntry, $tokenHandlerUrl);
$tokenValue = $tokenArray['token'];
$postUrl = $tokenArray['url'];

// place to redirect user after upload
$nextUrl = 'http://example.com/your-youtube-upload';

//echo "post url = ".$postUrl;

// build the form
echo '<form action="'. $postUrl .'?nexturl='. $nextUrl .
	  '" method="post" enctype="multipart/form-data">'. 
	  '<input name="file" type="file"/>'. 
	  '<input name="token" type="hidden" value="'. $tokenValue .'"/>'.
	  '<input value="Upload Video File" type="submit" />'. 
	  '</form>';

if(isset($_GET['status']) && $_GET['status'] == '200'){
	  echo '<h1>Video Uploaded</h1>';
}

?>