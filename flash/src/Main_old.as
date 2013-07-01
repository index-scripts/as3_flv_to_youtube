package 
{
	import caurina.transitions.Tweener;
	import flash.text.TextField;
	//import com.zeropointnine.SimpleFlvWriter;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	//import flash.filesystem.File;
	import flash.filters.BlurFilter;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import sav.gp.BitmapDrawer;
	import sav.gp.BitmapUtils;
	import com.zoharbabin.youtube.YouTubeDirectUpload;
	
	/**
	 * ...
	 * @author Sav
	 */
	public class Main extends Sprite 
	{
		public function Main():void 
		{
			/*
			var bitmap:Bitmap = new PIC_CLASS();
			var bitmapData:BitmapData = bitmap.bitmapData;
			
			_myFile = File.desktopDirectory;
			_myFile = _myFile.resolvePath("result.flv");
			
			
			_myWriter = SimpleFlvWriter.getInstance();
			_myWriter.createFile(_myFile, 320,240, 30, 120);
			
			var blurFilter:BlurFilter = new BlurFilter(0, 0);
			
			_clip = new Sprite();
			_clip.addChild(bitmap);
			addChild(_clip);
			
			_tempBitmap = new Bitmap();
			_tempBitmap.y = 300;
			addChild(_tempBitmap);
			
			Tweener.addTween(blurFilter, {time:5, blurX:100, onUpdate:onUpdate, onUpdateParams:[blurFilter], onComplete:cacheComplete});
			*/
			
			_tf = new TextField();
			_tf.x = 50;
			_tf.width = stage.stageWidth - 100;
			_tf.y = 50;
			_tf.height = stage.stageHeight - 50;
			_tf.multiline = true;
			_tf.wordWrap = true;
			addChild(_tf);
			
			testUpload();
		}
		
		private var ytUploader:YouTubeDirectUpload;
		
		private function testUpload():void
		{
			ytUploader = new YouTubeDirectUpload();
			
			var startX:int = 10;
			var startY:int = 10;
			var divW:int = 10;
			
			var btn:MyButton = new MyButton("Login");
			btn.x = startX;
			btn.y = startY;
			startX += btn.width + divW;
			addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, loginButton_click);
			
			btn = new MyButton("Browse");
			btn.x = startX;
			btn.y = startY;
			startX += btn.width + divW;
			addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, browseButton_click);
			
			btn = new MyButton("Upload");
			btn.x = startX;
			btn.y = startY;
			startX += btn.width + divW;
			addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, uploadButton_click);
		}
		
		private function loginButton_click(evt:MouseEvent):void
		{
			trace2('login');
			
			ytUploader.youTubeLogin('savorks@gmail.com', 'GlanceJr35');
			ytUploader.addEventListener("loginSuccess", ytUploader_loginSuccessHandler);
			ytUploader.addEventListener("loginFail", ytUploader_loginFailedHandler);
			ytUploader.addEventListener("uploadComplete", ytUploader_uploadCompleteHandler);
			ytUploader.addEventListener("uploadFailed", ytUploader_uploadFailedHandler);
		}
		
		protected function ytUploader_loginSuccessHandler(event:Event):void
		{
			//uploadBtn.enabled = true;
			//loadBtn.enabled = true;
			trace2('login success');
		}
		
		protected function ytUploader_loginFailedHandler(event:Event):void
		{
			//uploadBtn.label = 'Can\'t upload, login failed';
			trace2('login failed');
		}
		
		protected function ytUploader_uploadCompleteHandler(event:Event):void
		{
			trace2("upload completed successfully");
		}
		
		
		protected function ytUploader_uploadFailedHandler(event:Event):void
		{
			trace2("upload failed");
		}
		
		private function browseButton_click(evt:MouseEvent):void
		{
			fileReference = new FileReference();
			fileReference.addEventListener(Event.SELECT, fileSelectHandler, false, 0, true);
			fileReference.addEventListener(Event.COMPLETE, uploadDataComplete, false, 0, true);
			var videoFilter:FileFilter = new FileFilter("Video", "*.flv; *.wmv; *.mpeg; *.mpg; *.f4v; *.vp8; *.webm; *.3gp; *.mp4; *.mov; *.avi; *.mpegs; *.mpg; *.3gpp;");
			fileReference.browse([videoFilter]);
		}
		
		private var videoBytes:ByteArray;
		private var fileReference:FileReference;
		
		private function fileSelectHandler(event:Event):void {
			fileReference.load();
		}
		private function uploadDataComplete (event:Event):void {
			videoBytes = fileReference.data;
			trace2("file bytes loaded, ready to upload byteArray");
		}
		
		private function uploadButton_click(evt:MouseEvent):void
		{
			if (!videoBytes) {
				trace2 ("uploading from browse");
				ytUploader.uploadBrowse();
			} else {
				trace2 ("uploading byteArray");
				ytUploader.uploadByteArray(videoBytes);
			}
		}
		
		/*
		private function loginButtonClickHandler(event:MouseEvent):void 
		{	
			ytUploader.youTubeLogin('savorks@gmail.com', 'GlanceJr35');
			
			
		}
		
		private function uploadButtonClickHandler(event:MouseEvent):void {
			if (!videoBytes) {
				trace2 ("uploading from browse");
				ytUploader.uploadBrowse();
			} else {
				trace2 ("uploading byteArray");
				ytUploader.uploadByteArray(videoBytes);
			}
		}
		
		protected function ytUploader_loginSuccessHandler(event:Event):void
		{
			uploadBtn.enabled = true;
			loadBtn.enabled = true;
			trace2('login success');
		}
		
		
		protected function ytUploader_loginFailedHandler(event:Event):void
		{
			uploadBtn.label = 'Can\'t upload, login failed';
			trace2('login failed');
		}
		
		
		protected function ytUploader_uploadCompleteHandler(event:Event):void
		{
			trace2("upload completed successfully");
		}
		
		
		protected function ytUploader_uploadFailedHandler(event:Event):void
		{
			trace2("upload failed");
		}
		
		private var videoBytes:ByteArray;
		private var fileReference:FileReference;
		protected function loadBtn_clickHandler(event:MouseEvent):void
		{
			fileReference = new FileReference();
			fileReference.addEventListener(Event.SELECT, fileSelectHandler, false, 0, true);
			fileReference.addEventListener(Event.COMPLETE, uploadDataComplete, false, 0, true);
			var videoFilter:FileFilter = new FileFilter("Video", "*.flv; *.wmv; *.mpeg; *.mpg; *.f4v; *.vp8; *.webm; *.3gp; *.mp4; *.mov; *.avi; *.mpegs; *.mpg; *.3gpp;");
			fileReference.browse([videoFilter]);
		}
		private function fileSelectHandler(event:Event):void {
			fileReference.load();
		}
		private function uploadDataComplete (event:Event):void {
			videoBytes = fileReference.data;
			trace2("file bytes loaded, ready to upload byteArray");
		}
		
		private function onUpdate(blurFilter:BlurFilter):void
		{
			_clip.filters = [blurFilter];
			
			var bitmapData:BitmapData = BitmapUtils.cacheBitmapData(_clip, 2, true, true)
			_tempBitmap.bitmapData = bitmapData;
			
			_myWriter.saveFrame( bitmapData );
		}
		
		private function cacheComplete():void
		{
			_myWriter.closeFile();   
			trace2("cache complete");
		}
		*/
		
		private function trace2(string:String):void
		{
			trace(string);	
			_tf.htmlText += "<p>"+string+"</p>";
		}
		
		/*** params ***/
		private var _clip:Sprite;
		private var _tempBitmap:Bitmap;
		private var _tf:TextField;
		//private var _myFile:File;
		//private var _myWriter:SimpleFlvWriter;
	}
	
}