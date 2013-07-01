This project is a demo about how to generate FLV video in swf via as3, and upload the generated file to youtube with help by PHP.

see a demo here: [DEMO](http://lab.savorks.com/uflv/)

the process are splited into three parts:
  * generate FLV in swf
  * send FLV to server(using php in this demo)
  * server use ClientLogin tech login youtube and then upload FLV to server.
 
####  generate FLV in swf

####  swf send FLV to php

####  php client login youtube and upload video

php file [server_upload_video.php](https://github.com/index-scripts/as3_flv_to_youtube/blob/master/php/server_upload_video.php) process this step.

for uploading a video, you need prepare something:

* create a google account.
* use your google account login youtube and create at least one channel.
* generate a developerkey in [here](http://code.google.com/apis/youtube/dashboard/).

for more detail please read [here](https://developers.google.com/youtube/2.0/developers_guide_protocol_direct_uploading?hl=de#Direct_uploading)
  
