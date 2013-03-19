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
	import catman.net.Protocol;
	
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
			var p : Protocol = new Protocol(1);
			// entry point
			m_clientConn = new Socket();
			configureListeners();
			m_clientConn.connect("192.168.0.102", 50000);
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
			// send data
			var sendBuff : ByteArray = new ByteArray();
			sendBuff.endian = Endian.LITTLE_ENDIAN;
			sendBuff.writeUnsignedInt(1);
			var userName : String = "中国";
			var nameArray : ByteArray = new ByteArray();
			nameArray.endian = Endian.LITTLE_ENDIAN;
			nameArray.writeUTFBytes(userName);
			sendBuff.writeUnsignedInt(nameArray.length);
			sendBuff.writeBytes(nameArray);
			var password : String = "admin";
			sendBuff.writeUnsignedInt(password.length);
			sendBuff.writeMultiByte(password, "utf-8");
			//trace(sendBuff);
			m_clientConn.writeBytes(sendBuff);
			m_clientConn.flush();
			trace("send finish");
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
			var recvBuff : ByteArray = new ByteArray();
			recvBuff.endian = Endian.LITTLE_ENDIAN;
			m_clientConn.readBytes(recvBuff);
			trace("Recv: " + recvBuff.length);
			var proType : uint = recvBuff.readUnsignedInt();
			var strSize : uint = recvBuff.readUnsignedInt();
			var res : String = recvBuff.readUTFBytes(strSize);
			trace("Res is: " + res);
		}
	}
	
}