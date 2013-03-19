package catman.net 
{
	import catman.common.OctetsStream;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	
	/**
	 * ...
	 * @author Alanmars
	 */
	public class Session 
	{
		protected var m_sock : Socket;
		protected var m_permitSend : Boolean;
		
		public function Session(ipAddr : String, port : int) 
		{
			m_sock = new Socket();
			m_permitSend = false;
			configureListeners();
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
		}
		
		protected function socketDataHandler(event : ProgressEvent) : void
		{
			var stream : OctetsStream = new OctetsStream();
			m_sock.readBytes(stream.bytes);
			for (var protocol : Protocol = Protocol.decode(stream); protocol != null; )
				protocol.process();
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