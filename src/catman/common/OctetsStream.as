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
		
		public function OctetsStream(endian : Endian = Endian.BIG_ENDIAN) 
		{
			m_data = new ByteArray();
			m_data.endian = endian;
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
			m_data.writeDouble(val);
			return this;
		}
	}

}