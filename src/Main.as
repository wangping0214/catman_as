package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.system.Security;
	
	/**
	 * ...
	 * @author Alan
	 */
	public class Main extends Sprite 
	{
		private var m_clientConn : Socket;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			m_clientConn = new Socket();
			configureListeners();
			m_clientConn.connect("127.0.0.1", 5000);
		}
		
		private function configureListeners() : void
		{
			m_clientConn.addEventListener(Event.CONNECT, connectHandler);
			m_clientConn.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			m_clientConn.addEventListener(Event.CLOSE, closeHandler);
			m_clientConn.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			m_clientConn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		private function connectHandler(event : Event) : void
		{
			trace("connectHandler: " + event);
			
			var itemlist : Vector.<int> = new Vector.<int>();
			for each (var abc:int in itemlist)
				;
			// send data
			/*
			var sendBuff : ByteArray = new ByteArray();
			sendBuff.endian = Endian.LITTLE_ENDIAN;
			sendBuff.writeUnsignedInt(1);
			var userName : String = "中国";
			sendBuff.writeUnsignedInt(userName.length);
			sendBuff.writeMultiByte(userName, "utf-8");
			var password : String = "admin";
			sendBuff.writeUnsignedInt(password.length);
			sendBuff.writeMultiByte(password, "utf-8");
			//trace(sendBuff);
			m_clientConn.writeBytes(sendBuff);
			m_clientConn.flush();
			trace("send finish");
			*/
			var sendBuff : ByteArray = new ByteArray();
			sendBuff.endian = Endian.LITTLE_ENDIAN;
			/*
			var strBuff : ByteArray = new ByteArray();
			strBuff.endian = Endian.LITTLE_ENDIAN;
			//strBuff.writeUTFBytes("中国");
			strBuff.writeMultiByte("中国", "gb2312");
			trace("strBuff len: " + strBuff.length);
			sendBuff.writeUnsignedInt(strBuff.length);
			sendBuff.writeBytes(strBuff);
			*/
			//var lval : Number = 0xFFFFFFFFF;
			//sendBuff.writeDouble(lval);
			
			sendBuff.writeBoolean(true);
			m_clientConn.writeBytes(sendBuff);
			m_clientConn.flush();
			
			//var ival : int = 0;
			//changeInt(lval);
			trace("ival is: " + sendBuff.length);
		}
		
		private function closeHandler(event : Event) : void
		{
			trace("closeHandler: " + event);
		}
		
		private function ioErrorHandler(event : IOErrorEvent) : void
		{
			trace("ioErrorHandler: " + event);
		}
		
		private function securityErrorHandler(event : SecurityErrorEvent) : void
		{
			trace("securityErrorHandler: " + event);
		}
		
		private function socketDataHandler(event : ProgressEvent) : void
		{
			trace("socketDataHandler: " + event);
		}
		
		private function changeInt(i : Number) : void
		{
			i = 5;
		}
	}
	
}