/**************************************************************
 * (C) Copyright 2013 Alanmars
 * Keep it simple at first 
 *************************************************************/
package catman.error 
{
	/**
	 * ...
	 * @author Alanmars
	 */
	public class MarshalError extends Error
	{
		private static var errorMessageMap : Object;
		public static const NO_BYTES_AVAILABLE : uint = 0xc0;
		public static const INSUFFICIENT_BYTES_AVAILABLE : uint = 0xc1;
		
		{
			errorMessageMap = new Object();
			errorMessageMap[NO_BYTES_AVAILABLE] = "No bytes available!";
			errorMessageMap[INSUFFICIENT_BYTES_AVAILABLE] = "Insufficient bytes available!";
		}
		
		public function MarshalError(errId : int) 
		{
			super("Marshal error: " + errorMessageMap[errId], errId);
		}
		
	}

}