package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import catman.net.Protocol;
	import catman.net.Session;
	import protocol.LoginResponse;
	import protocol.PlayerLogin;
	
	/**
	 * ...
	 * @author Alan
	 */
	public class Main extends Sprite 
	{
		private static var lr : LoginResponse = new LoginResponse();
		private static var pl : PlayerLogin = new PlayerLogin();
		
		private var m_session : Session;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			m_session = new Session("192.168.0.102", 50000);
		}
	}
	
}