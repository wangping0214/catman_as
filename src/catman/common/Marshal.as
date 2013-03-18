package catman.common 
{
	
	/**
	 * ...
	 * @author Alanmars
	 */
	public interface Marshal 
	{
		public function marshal(stream : OctetsStream) : void;
		public function unmarshal(stream : OctetsStream) : void;
	}
	
}