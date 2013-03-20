package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import catman.net.Protocol;
	import catman.net.Session;
	import protocol.LoginResponse;
	import protocol.PlayerLogin;
	import protocol.ProtocolType;
	
	/**
	 * ...
	 * @author Alan
	 */
	public class Main extends Sprite 
	{	
		private var pl : PlayerLogin = new PlayerLogin();
		private var lr : LoginResponse = new LoginResponse();
		
		private var m_session : Session;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			m_session = new Session();
			m_session.addEventListener(ProtocolType.LOGINRESPONSE, loginResponseHandler);
			m_session.start("192.168.0.102", 50000);
		}
		
		private function loginResponseHandler(event : Event) : void
		{
			var lr : LoginResponse = event as LoginResponse;
			trace("Recv: " + lr.loginResult);
		}
	}
	
}