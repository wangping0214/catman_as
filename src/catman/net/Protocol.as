/**************************************************************
 * (C) Copyright 2013 Alanmars
 * Keep it simple at first 
 *************************************************************/
package catman.net 
{
	import catman.common.Marshal;
	import catman.common.OctetsStream;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Alanmars
	 */
	public class Protocol extends Event implements Marshal
	{
		private static var s_typeProtocolMap : Object = new Object();
		protected var m_id : uint;
		
		public function Protocol(id : uint, type : String) 
		{
			super(type);
			m_id = id;
			if (getStub(m_id) == null)
				s_typeProtocolMap[m_id] = this;
		}
		
		public function get id() : uint
		{
			return m_id;
		}
		
		public override function clone() : Event
		{
			var dup : Protocol = new Protocol(m_id, type);
			return dup;
		}
		
		public override function toString() : String
		{
			return formatToString("AlarmEvent", "type", "bubbles", "cancelable", "eventPhase", "m_id");
		}
		
		public function marshal(stream : OctetsStream) : OctetsStream
		{
			return stream;
		}
		
		public function unmarshal(stream : OctetsStream) : OctetsStream
		{	
			return stream;
		}
		
		private static function getStub(id : uint) : Protocol
		{
			return s_typeProtocolMap[id];
		}
		
		public static function create(id : uint) : Protocol
		{
			var stub : Protocol = getStub(id);
			return stub != null ? stub.clone() as Protocol : null;
		}
		
		public static function encode(protocol : Protocol) : ByteArray
		{
			var stream : OctetsStream = new OctetsStream();
			stream.marshal_uint32_t(protocol.m_id);
			protocol.marshal(stream);
			return stream.bytes;
		}
		
		public static function decode(stream : OctetsStream) : Protocol
		{
			if (stream.bytesAvailable < 4)	// less than the bytes of uint
				return null;
			var protocol : Protocol = null;
			var m_id : uint = stream.unmarshal_uint32_t();
			protocol = create(m_id);
			if (protocol != null)
				protocol.unmarshal(stream);
			return protocol;
		}
	}

}