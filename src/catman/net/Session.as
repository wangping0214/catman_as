/**************************************************************
 * (C) Copyright 2013 Alanmars
 * Keep it simple at first 
 *************************************************************/
package catman.net 
{
	import catman.common.OctetsStream;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import protocol.PlayerLogin;
	
	/**
	 * ...
	 * @author Alanmars
	 */
	public class Session extends EventDispatcher
	{
		protected var m_sock : Socket;
		protected var m_permitSend : Boolean;
		
		public function Session() 
		{
			m_sock = new Socket();
			m_permitSend = false;
			configureListeners();
		}
		
		public function start(ipAddr : String, port : int) : void
		{
			m_sock.connect(ipAddr, port);
		}
		
		public function send(protocol : Protocol) : Boolean
		{
			if (m_permitSend)
			{
				m_sock.writeBytes(Protocol.encode(protocol));
				return true;
			}
			return false;
		}
		
		private function configureListeners() : void
		{
			m_sock.addEventListener(Event.CONNECT, connectHandler);
			m_sock.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			m_sock.addEventListener(Event.CLOSE, closeHandler);
			m_sock.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			m_sock.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		protected function connectHandler(event : Event) : void
		{
			m_permitSend = true;
			// temporary
			var pl : PlayerLogin = new PlayerLogin();
			pl.userName = "毛太祖";
			pl.password = "毛泽东";
			send(pl);
		}
		
		protected function socketDataHandler(event : ProgressEvent) : void
		{
			var stream : OctetsStream = new OctetsStream();
			
			m_sock.readBytes(stream.bytes);
			for (var p : Protocol; (p = Protocol.decode(stream)) != null; )
				dispatchEvent(p);
			
		}
		
		protected function closeHandler(event : Event) : void
		{
			m_permitSend = false;
		}
		
		protected function ioErrorHandler(event : IOErrorEvent) : void
		{
			trace("IOError: " + event);
		}
		
		protected function securityErrorHandler(event : SecurityErrorEvent) : void
		{
			trace("SecurityError: " + event);
		}
	}

}