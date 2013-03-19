package catman.net 
{
	import catman.common.Marshal;
	import catman.common.OctetsStream;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Alanmars
	 */
	public class Protocol implements Marshal
	{
		private static var s_typeProtocolMap : Object;
		protected var m_type : uint;
		
		public function Protocol(type : uint) 
		{
			m_type = type;
			if (getStub(m_type) == null)
				s_typeProtocolMap[m_type] = this;
		}
		
		public function get type() : uint
		{
			return m_type;
		}
		
		public function clone() : Protocol
		{
			var dup : Protocol = new Protocol(m_type);
			return dup;
		}
		
		public function marshal(stream : OctetsStream) : OctetsStream
		{
			return stream;
		}
		
		public function unmarshal(stream : OctetsStream) : OctetsStream
		{	
			return stream;
		}
		
		private static function getStub(type : uint) : Protocol
		{
			return s_typeProtocolMap[type];
		}
		
		public static function create(type : uint) : Protocol
		{
			var stub : Protocol = getStub(type);
			return stub != null ? stub.clone() : null;
		}
		
		public static function encode(protocol : Protocol) : ByteArray
		{
			var stream : OctetsStream = new OctetsStream();
			stream.marshal_uint32_t(protocol.type);
			protocol.marshal(stream);
			return stream.bytes;
		}
		
		public static function decode(stream : OctetsStream) : Protocol
		{
			var protocol : Protocol = null;
			var type : uint = stream.unmarshal_uint32_t();
			protocol = create(type);
			if (protocol != null)
				protocol.unmarshal(stream);
			return protocol;
		}
	}

}