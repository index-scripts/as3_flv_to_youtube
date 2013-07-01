package uflv 
{
	import res.SceneSclip;
	/**
	 * ...
	 * @author Sav
	 */
	public class TestScene 
	{
		public function init():void
		{
			_sceneClip = new SceneSclip();
			_sceneClip.x = (REF.nStage.stageWidth - _sceneClip.width) / 2;
			_sceneClip.y = (REF.nStage.stageHeight - _sceneClip.height) / 2;
			
			REF.main.addChild(_sceneClip);
		}
		
		private var _sceneClip:SceneSclip;
		public function get sceneClip():SceneSclip { return _sceneClip; }
	}
}