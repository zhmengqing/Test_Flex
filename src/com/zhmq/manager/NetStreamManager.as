package com.zhmq.manager
{
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.controls.sliderClasses.Slider;
	
	import spark.components.Button;

	public class NetStreamManager
	{
		private var _ns:NetStream;
		private var _video:Video;
		private var _btn:Button;
		private var _slider:Slider;
		public function NetStreamManager()
		{
			var nc:NetConnection=new NetConnection();
			nc.connect(null); 
			_ns=new NetStream(nc); 
		}
		
		protected function onNetStatus(event:NetStatusEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		public function onCuePoint(obj:Object):void
		{
		}
		public function onMetaData(obj:Object):void
		{
		}
		public function init(contain:Sprite):void
		{
			_video = new Video(400,350);
			_video.smoothing = true;
			contain.addChild(_video);
			_ns.client = this;
			_ns.receiveVideo(true);
			_ns.play("cuepoints.flv"); 
			_video.attachNetStream(_ns);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		}
		
		public function setButton(btn:Button):void
		{
			_btn = btn;
		}
		public function setSlider(slider:Slider):void
		{
			_slider = slider;
		}
		
		private static var _instance:NetStreamManager;
		public static function get instance():NetStreamManager
		{
			if(!_instance){
				_instance = new NetStreamManager();
			}
			return _instance;
		}
	}
}