package  
{
	import caurina.transitions.Tweener;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	import leelib.util.flvEncoder.ByteArrayFlvEncoder;
	import leelib.util.flvEncoder.FlvEncoder;
	import leelib.util.flvEncoder.VideoPayloadMakerAlchemy;
	import res.PendingIcon;
	import sav.components.dialog_v2.Dialog;
	import sav.ui.MyButton;
	import uflv.TestScene;
	
	/**
	 * ...
	 * @author Sav
	 */
	public class Main extends Sprite 
	{
		public function Main() 
		{
			Dialog.defaultContainer = stage;
			
			REF.nStage = stage;
			REF.main = this;
			REF.scene = new TestScene();
			REF.scene.init();
			
			
			var startX:int = 0;
			var startY:int = 0;
			var divW:int = 10;
			
			var btn:MyButton;
			
			var sprite:Sprite = _btnSprite = new Sprite();
			
			_btn_changePic = btn = new MyButton("Change Picure");
			btn.x = startX;
			btn.y = startY;
			startX += btn.width + divW;
			sprite.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, changePicButton_click);
			
			_btn_captureVideo = btn = new MyButton("Capture Video");
			btn.x = startX;
			btn.y = startY;
			startX += btn.width + divW;
			sprite.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, captureVideoButton_click);
			
			addChild(sprite);
			sprite.x = int((stage.stageWidth - sprite.width) / 2);
			sprite.y = REF.scene.sceneClip.y + REF.scene.sceneClip.height + 20;
			
			_pendingIcon = new PendingIcon();
			_pendingIcon.x = stage.stageWidth / 2;
			_pendingIcon.y = sprite.y;
			
			buildFileReference();
			
			_sound = new Soundtrack();
			
			trace('init');
		}
		
		/*** capture video ***/
		private function captureVideoButton_click(evt:MouseEvent):void
		{		
			disableButtons();
			
			
			_baAudio = new ByteArray();
			var seconds:Number = REF.scene.sceneClip.totalFrames / FLV_FRAMERATE;
			_sound.extract(_baAudio, seconds * 44000 + 1000); 
			
			_baFlvEncoder = new ByteArrayFlvEncoder(FLV_FRAMERATE);
			//_baFlvEncoder.setVideoProperties(OUTPUT_WIDTH, OUTPUT_HEIGHT,VideoPayloadMakerAlchemy);
			_baFlvEncoder.setVideoProperties(OUTPUT_WIDTH, OUTPUT_HEIGHT);
			_baFlvEncoder.setAudioProperties(FlvEncoder.SAMPLERATE_44KHZ, true,true, true);
			_baFlvEncoder.start();
			

			REF.scene.sceneClip.gotoAndStop(1);
			capcureOneFrame();
			
			Tweener.addTween(this, { time:30/1000, transition:"none", onComplete:captureVideo_exec } );
		}
		
		private function capcureOneFrame():void
		{
			var audioChunk:ByteArray = new ByteArray();
			audioChunk.writeBytes(_baAudio, (REF.scene.sceneClip.currentFrame-1) * _baFlvEncoder.audioFrameSize, _baFlvEncoder.audioFrameSize);
			
			var bitmapData:BitmapData = new BitmapData(320, 200);
			bitmapData.draw(REF.scene.sceneClip);
			//_baFlvEncoder.addFrame(bitmapData, null);
			_baFlvEncoder.addFrame(bitmapData, audioChunk);
		}
		
		private function captureVideo_exec():void
		{
			if (REF.scene.sceneClip.totalFrames == REF.scene.sceneClip.currentFrame)
			{
				//_sound.close();
				trace('capture complete');
				_baFlvEncoder.updateDurationMetadata();
				
				//trace("_ba length = " + _baFlvEncoder.byteArray.length);
				//_baFlvEncoder.byteArray.compress();
				//trace("_ba length(compressed) = " + _baFlvEncoder.byteArray.length);
				
				enableButtons();
				
				Dialog.quickAlert("<c>Video capture complete.<c><br><br><p align='center'>next</p>", [ 
					{ text:"Save Localy", func:saveLocalButton_click },
					{ text:"Upload", func:uploadButton_click }, 
					{ text:"Close" } ]);
			}
			else
			{
				REF.scene.sceneClip.gotoAndStop(REF.scene.sceneClip.currentFrame + 1);
				capcureOneFrame();
				Tweener.addTween(this, { time:30/1000, transition:"none", onComplete:captureVideo_exec } );
			}
		}
		
		private function saveLocalButton_click(evt:MouseEvent = null):void
		{
			_fr.save(_baFlvEncoder.byteArray, "result.flv");
		}
		
		
		/*** change picture process ***/
		private function changePicButton_click(evt:MouseEvent):void
		{
			var videoFilter:FileFilter = new FileFilter("Picture", "*.png; *.jpg; *.jpeg;");
			_picFr.browse([videoFilter]);
		}
		
		private function picFile_selected(evt:Event):void
		{
			trace('picture selected');
			
			_picFr.addEventListener(Event.COMPLETE, picLoaded);
			_picFr.load();
		}
		
		private function picLoaded(evt:Event):void
		{
			trace('pic loaded');
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_complete);
			loader.loadBytes(_picFr.data);
		}
		
		private function loader_complete(evt:Event):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo(evt.currentTarget);
			loaderInfo.removeEventListener(Event.COMPLETE, loader_complete);
			
			var bitmap:Bitmap = Bitmap(loaderInfo.loader.content);
			bitmap.width = 90;
			bitmap.height = 90;
			bitmap.x = 5 - 50;
			bitmap.y = 5 - 100;
			bitmap.smoothing = true;
			
			REF.scene.sceneClip._clip.addChild(bitmap);
		}
		
		/*** upload process ***/
		private function uploadButton_click(evt:MouseEvent = null):void
		{
			addChild(_pendingIcon);
			disableButtons();
			
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
		}
		
		private function upload_progress(evt:ProgressEvent):void
		{
			trace(evt.bytesLoaded + " loaded, " + evt.bytesTotal + " total");
		}
		
		private function upload_Complete(evt:Event):void
		{
			trace("upload complete");
			
			var loader:URLLoader = URLLoader(evt.currentTarget);
			
			trace("data = " + loader.data);
			
			if (!loader.data)
			{
				Dialog.quickAlert("Upload timeout.");
				return;
			}
			
			var variables:URLVariables = new URLVariables(loader.data);
			
			
			removeChild(_pendingIcon);
			enableButtons();
			
			if (variables && variables.s == "1")
			{
				var videoId:String = variables.res;
				var videoUrl:String = "http://www.youtube.com/watch?v=" + videoId;
				Dialog.quickAlert("<p align='center'>Upload complete, new video link is <br><br><font color='#0075EA'><a href='"+videoUrl+"'>"+videoUrl+"</a></font></p>");
			}
			else
			{
				Dialog.quickAlert(variables.res);
			}
		}
		
		private function buildFileReference():void
		{
			_fr = new FileReference();
			
			_fr.addEventListener(IOErrorEvent.IO_ERROR, file_IOError);
			
			_picFr = new FileReference();
			_picFr.addEventListener(Event.SELECT, picFile_selected);
			_picFr.addEventListener(IOErrorEvent.IO_ERROR, file_IOError);
		}
		
		private function file_IOError(evt:IOErrorEvent):void
		{
			trace(evt);
			Dialog.quickAlert(String(evt.text));
		}
		
		/*** button control ***/
		private function disableButtons():void
		{
			_btnSprite.alpha = 0;
			_btnSprite.mouseChildren = false;
		}
		
		private function enableButtons():void
		{
			_btnSprite.alpha = 1;
			_btnSprite.mouseChildren = true;
		}
		
		/*** params ***/
		//private const HTTP_PATH:String = "http://192.168.2.71/lab/uflv/";
		private const HTTP_PATH:String = "";
		
		private static const FLV_FRAMERATE:int = 30;
		private static const OUTPUT_WIDTH:int = 320;
		private static const OUTPUT_HEIGHT:int = 200;
		
		private var _fr:FileReference;
		private var _picFr:FileReference;
		private var _baFlvEncoder:ByteArrayFlvEncoder; 
		
		private var _btn_upload:MyButton;
		private var _btn_browse:MyButton;
		private var _btn_changePic:MyButton;
		private var _btn_captureVideo:MyButton;
		private var _btn_saveLocal:MyButton;
		
		private var _btnSprite:Sprite;
		
		private var _baAudio:ByteArray;
		private var _sound:Sound;
		
		private var _pendingIcon:PendingIcon;
		
		[Embed(source = "../res/hello.mp3")]
		private var Soundtrack:Class;
	}
}