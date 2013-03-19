package catman.common 
{
	
	/**
	 * ...
	 * @author Alanmars
	 */
	public interface Marshal 
	{
		function marshal(stream : OctetsStream) : OctetsStream;
		function unmarshal(stream : OctetsStream) : OctetsStream;
	}
	
}