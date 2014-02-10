package com.zhmq.manager
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.controls.sliderClasses.Slider;
	import mx.events.SliderEvent;
	
	import spark.components.BorderContainer;
	import spark.components.Button;

	public class NetStreamManager extends EventDispatcher
	{
		private var _ns:NetStream;
		private var _video:Video;
		private var _btn:Button;
		private var _slider:Slider;
		private var isPause:Boolean;
		private var _rect:BorderContainer;
		public function NetStreamManager()
		{
			var nc:NetConnection=new NetConnection();
			nc.connect(null); 
			_ns=new NetStream(nc); 
		}
		
		private function btnPlay(boo:Boolean):void
		{
			if(boo){
				_btn.label = "暂停";
			}else{
				_btn.label = "播放";
			}
			isPause = !boo;
		}
		
		protected function onNetStatus(e:NetStatusEvent):void
		{
			// TODO Auto-generated method stub
			btnPlay(true);
			if(e.info.code == "NetStream.Play.Stop")
			{
				_ns.seek(0);
				btnPlay(false);
				_ns.pause();
			}
		}
		
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			btnPlay(isPause);
			if(isPause){
				_ns.pause();
			}else{
				_ns.resume();
			}
		}
		
		public function EnterFrameHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			if (_slider.maximum>0){ 
				_slider.value = _ns.time;
			}
			
			if (_ns.bytesLoaded>0 && _ns.bytesLoaded<_ns.bytesTotal){ 
				_rect.width = _ns.bytesLoaded / _ns.bytesTotal*(_slider.width-10);
			}
		}
		
		public function onCuePoint(obj:Object):void
		{
		}
		public function onMetaData(obj:Object):void
		{
			_slider.maximum = obj.duration;
			_video.width = obj.width;
			_video.height = obj.height;
		}
		public function init(contain:Sprite):void
		{
			_video = new Video();
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
			_btn.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function setSlider(slider:Slider):void
		{
			_slider = slider;
			_rect = new BorderContainer();
			_slider.parentApplication.addElement(_rect);
			_rect.x = _slider.x;
			_rect.y = _slider.y;
			_rect.width = 0;
			_rect.height = 4;
		}
		
		public function onChange(e:SliderEvent):void
		{
			if(_ns.time == 0)
			{ 
				_slider.value = 0; 
				return; 
			} 
			_ns.seek(_slider.value);
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