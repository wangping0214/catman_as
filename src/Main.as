package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import catman.net.Protocol;
	import catman.net.Session;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
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
		private var m_nameText : TextField = new TextField();
		private var m_passwordText : TextField = new TextField();
		
		private var m_session : Session;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initGui();
			
			m_session = new Session();
			m_session.addEventListener(ProtocolType.LOGINRESPONSE, loginResponseHandler);
			//m_session.start("192.168.0.102", 50000);
		}
		
		private function initGui() : void
		{
			var myFormat : TextFormat = new TextFormat();
			myFormat.color = 0x000000;
			myFormat.size = 16;
			
			var nameLabel : TextField = new TextField();
			nameLabel.x = 300;
			nameLabel.y = 100;
			nameLabel.selectable = false;
			nameLabel.autoSize = TextFieldAutoSize.LEFT;
			nameLabel.defaultTextFormat = myFormat;
			nameLabel.text = "用户名: ";
			addChild(nameLabel);
			
			m_nameText.x = 360
			m_nameText.y = 100;
			m_nameText.width = 100;
			m_nameText.height = 25;
			m_nameText.type = TextFieldType.INPUT;
			m_nameText.border = true;
			addChild(m_nameText);
			
			var passwordLabel : TextField = new TextField();
			passwordLabel.x = 300;
			passwordLabel.y = 130;
			passwordLabel.selectable = false;
			passwordLabel.autoSize = TextFieldAutoSize.LEFT;
			passwordLabel.defaultTextFormat = myFormat;
			passwordLabel.text = "密    码: ";
			addChild(passwordLabel);
			
			m_passwordText.x = 360;
			m_passwordText.y = 130;
			m_passwordText.width = 100;
			m_passwordText.height = 25;
			m_passwordText.type = TextFieldType.INPUT;
			m_passwordText.displayAsPassword = true;
			m_passwordText.border = true;
			addChild(m_passwordText);
		}
		
		private function loginResponseHandler(event : Event) : void
		{
			var lr : LoginResponse = event as LoginResponse;
			trace("Recv: " + lr.loginResult);
		}
	}
	
}