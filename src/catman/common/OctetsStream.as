package catman.common 
{
	import flash.utils.Endian;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Alanmars
	 */
	public class OctetsStream 
	{
		protected var m_data : ByteArray;
		
		public function OctetsStream(endian : String = Endian.LITTLE_ENDIAN) 
		{
			m_data = new ByteArray();
			m_data.endian = endian;
		}
		
		public function get bytes() : ByteArray
		{
			return m_data;
		}
		
		public function get bytesAvailable() : uint
		{
			return m_data.bytesAvailable;
		}
		
		public function marshal_bool(val : Boolean) : OctetsStream
		{
			m_data.writeBoolean(val);
			return this;
		}
		
		public function marshal_int8_t(val : int) : OctetsStream
		{
			m_data.writeByte(val);
			return this;
		}
		
		public function marshal_int16_t(val : int) : OctetsStream
		{
			m_data.writeShort(val);
			return this;
		}
		
		public function marshal_int32_t(val : int) : OctetsStream
		{
			m_data.writeInt(val);
			return this;
		}
		
		public function marshal_int64_t(val : Number) : OctetsStream
		{
			// C++ code must be modified to parse correct long value. 
			m_data.writeDouble(val);
			return this;
		}
		
		public function marshal_uint8_t(val : uint) : OctetsStream
		{
			m_data.writeByte(val);
			return this;
		}
		
		public function marshal_uint16_t(val : uint) : OctetsStream
		{
			m_data.writeShort(val);
			return this;
		}
		
		public function marshal_uint32_t(val : uint) : OctetsStream
		{
			m_data.writeUnsignedInt(val);
			return this;
		}
		
		public function marshal_uint64_t(val : Number) : OctetsStream
		{
			// See also marshal_int64_t
			m_data.writeDouble(val);
			return this;
		}
		
		public function marshal_float(val : Number) : OctetsStream
		{
			m_data.writeFloat(val);
			return this;
		}
		
		public function marshal_double(val : Number) : OctetsStream
		{
			m_data.writeDouble(val);
			return this;
		}
		
		public function marshal_string(val : String) : OctetsStream
		{
			var utfBuff : ByteArray = new ByteArray();
			utfBuff.endian = m_data.endian;
			utfBuff.writeUTFBytes(val);
			m_data.writeUnsignedInt(utfBuff.length);
			m_data.writeBytes(utfBuff);
			return this;
		}
		
		public function unmarshal_bool() : Boolean
		{
			return m_data.readBoolean();
		}
		
		public function unmarshal_int8_t() : int
		{
			return m_data.readByte();
		}
		
		public function unmarshal_int16_t() : int
		{
			return m_data.readShort();
		}
		
		public function unmarshal_int32_t() : int
		{
			return m_data.readInt();
		}
		
		public function unmarshal_int64_t() : Number
		{
			return m_data.readDouble();
		}
		
		public function unmarshal_uint8_t() : uint
		{
			return m_data.readUnsignedByte();
		}
		
		public function unmarshal_uint16_t() : uint
		{
			return m_data.readUnsignedShort();
		}
		
		public function unmarshal_uint32_t() : uint
		{
			return m_data.readUnsignedInt();
		}
		
		public function unmarshal_float() : Number
		{
			return m_data.readFloat();
		}
		
		public function unmarshal_double() : Number
		{
			return m_data.readDouble();
		}
		
		public function unmarshal_string() : String
		{
			var bytes : uint = m_data.readUnsignedInt();
			return m_data.readUTFBytes(bytes);
		}
	}

}