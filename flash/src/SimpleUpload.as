package  
{
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.ui.Mouse;
	import net.UploadPostHelper;
	import sav.components.dialog_v2.Dialog;
	import sav.ui.MyButton;
	import uflv.TestScene;
	
	/**
	 * ...
	 * @author Sav
	 */
	public class SimpleUpload extends Sprite 
	{
		
		public function SimpleUpload() 
		{
			Dialog.defaultContainer = stage;
			
			var startX:int = 10;
			var startY:int = 10;
			var divW:int = 10;
			
			var btn:MyButton;
			
			_btn_browse = btn = new MyButton("Browse");
			btn.x = startX;
			btn.y = startY;
			startX += btn.width + divW;
			addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, browseButton_click);
			
			_btn_upload = btn = new MyButton("Upload");
			btn.x = startX;
			btn.y = startY;
			startX += btn.width + divW;
			btn.alpha = .5;
			btn.mouseEnabled = false;
			addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, uploadButton_click);
			
			buildFileReference();
		}
		
		/*** upload process ***/
		private function uploadButton_click(evt:MouseEvent):void
		{
			//var request:URLRequest = new URLRequest(HTTP_PATH + "recive_file.php");
			var request:URLRequest = new URLRequest(HTTP_PATH + "server_upload_video.php");
			_fr.upload(request);
			
			//grantUploadURL();
			
			//_fr.addEventListener(Event.COMPLETE, file_loaded);
			//_fr.load();
		}
		
		private function buildFileReference():void
		{
			_fr = new FileReference();
			
			_fr.addEventListener(Event.SELECT, file_selected);	
			_fr.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, file_uploadComplete);
			_fr.addEventListener(IOErrorEvent.IO_ERROR, file_IOError);
			//_fr.addEventListener(Event.COMPLETE, file_complete);
		}
		
		private function file_IOError(evt:IOErrorEvent):void
		{
			trace(evt);
		}
		
		private function file_complete(evt:Event):void
		{
			trace("file complete");
		}
		
		private function browseButton_click(evt:MouseEvent):void
		{
			trace("browse click");
			var videoFilter:FileFilter = new FileFilter("Video", "*.flv; *.wmv; *.mpeg; *.mpg; *.f4v; *.vp8; *.webm; *.3gp; *.mp4; *.mov; *.avi; *.mpegs; *.mpg; *.3gpp;");
			_fr.browse([videoFilter]);
		}
		
		private function file_uploadComplete(evt:DataEvent):void
		{
			trace("upload complete");
			trace("data = " + evt.data);
		}
		
		private function file_selected(evt:Event):void
		{
			trace("file selected");
			_btn_upload.alpha = 1;
			_btn_upload.mouseEnabled = true;
		}
		
		/*** load file data ***/		
		private function file_loaded(evt:Event):void
		{
			_fr.removeEventListener(Event.COMPLETE, file_loaded);
			trace('data = ' + _fr.data.length);
			
			//grantUploadURL();
		}
		
		
		/*** params ***/
		private const HTTP_PATH:String = "http://192.168.2.71/uflv/";
		
		private var _fr:FileReference;
		private var _picFr:FileReference;
		
		private var _btn_upload:MyButton;
		private var _btn_browse:MyButton;
	}

}