package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import catman.net.Protocol;
	import catman.net.Session;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import protocol.LoginResponse;
	import protocol.PlayerLogin;
	import protocol.ProtocolType;
	import ui.Button;
	
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
		private var m_resultLabel : TextField = new TextField();
		private var m_resultFormat : TextFormat = new TextFormat();
		
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
			m_session.addEventListener(Event.CONNECT, sessionConnectHandler);
			m_session.addEventListener(ProtocolType.LOGINRESPONSE, loginResponseHandler);
			m_session.start("192.168.0.102", 50000);
		}
		
		private function initGui() : void
		{
			var myFormat : TextFormat = new TextFormat();
			myFormat.color = 0x000000;
			myFormat.size = 16;
			
			m_resultLabel.x = 320;
			m_resultLabel.y = 70;
			m_resultLabel.selectable = false;
			m_resultLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(m_resultLabel);
			
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
			
			var loginBtn : Button = new Button();
			loginBtn.x = 300;
			loginBtn.y = 160;
			loginBtn.addEventListener(MouseEvent.CLICK, clickHandler);
			addChild(loginBtn);
		}
		
		private function sessionConnectHandler(event : Event) : void
		{
		}
		
		private function loginResponseHandler(event : Event) : void
		{
			var response : LoginResponse = event as LoginResponse;
			if (response.retcode == 0)
				m_resultFormat.color = 0x00ff00;
			else
				m_resultFormat.color = 0xff0000;
			m_resultFormat.size = 24;
			m_resultLabel.defaultTextFormat = m_resultFormat;
			m_resultLabel.text = response.loginResult;
		}
		
		private function clickHandler(event : MouseEvent) : void
		{
			var loginRequest : PlayerLogin = new PlayerLogin();
			loginRequest.userName = m_nameText.text;
			loginRequest.password = m_passwordText.text;
			m_session.send(loginRequest);
		}
	}
	
}