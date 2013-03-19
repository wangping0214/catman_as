package catman.common 
{
	
	/**
	 * ...
	 * @author Alanmars
	 */
	public interface Marshal 
	{
		public function marshal(stream : OctetsStream) : OctetsStream;
		public function unmarshal(stream : OctetsStream) : OctetsStream;
	}
	
}