This project is a demo about how to generate FLV video in swf via as3, and upload the generated file to youtube with help by PHP.

  [DEMO](http://lab.savorks.com/uflv/)

the process are splited into three parts:
  * generate FLV in swf
  * send FLV to server(using php in this demo)
  * server use ClientLogin tech login youtube and then upload FLV to server.
 
####  generate FLV in swf
we use [zeropointnine's FlvEncoder](https://github.com/zeropointnine/leelib) help us generate FLV, source code licensed under a [Creative Commons Attribution 3.0 License.](http://creativecommons.org/licenses/by/3.0/) Some Rights Reserved.

in this part we use IBitmapDrawable.draw method capture BitmapData from swf frame by frame, send them to FlvEncoder instance, in the end we will get a ByteArray which contains the video data, we will send it to server in step 2.

####  swf send FLV to php
sending binary data to server is bit different of sending text, in the UrlRequest instance, we need assign different content-type("application/octet-stream") in request header, the sending method need to be "POST", and assign our video ByteArray in data params.
here are snippets from [Main.as](https://github.com/index-scripts/as3_flv_to_youtube/blob/master/flash/src/Main.as)
```as3
var request:URLRequest = new URLRequest(HTTP_PATH + "php/server_upload_video.php");
  		
var loader:URLLoader = new URLLoader();
loader.addEventListener(Event.COMPLETE, upload_Complete);
loader.addEventListener(IOErrorEvent.IO_ERROR, file_IOError);
loader.addEventListener(ProgressEvent.PROGRESS, upload_progress);
    
var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
request.requestHeaders.push(header);
request.method = URLRequestMethod.POST;
request.data = _baFlvEncoder.byteArray;
loader.load(request);
```

####  php client login youtube and upload video
for uploading a video, you need prepare something:

* create a google account.
* use your google account login youtube and create at least one channel.
* generate a developerkey in [here](http://code.google.com/apis/youtube/dashboard/).

php file [server_upload_video.php](https://github.com/index-scripts/as3_flv_to_youtube/blob/master/php/server_upload_video.php) process this step.

more detail please read [here](https://developers.google.com/youtube/2.0/developers_guide_protocol_direct_uploading?hl=de#Direct_uploading)
  
