package ui 
{
	import flash.display.SimpleButton;
	/**
	 * ...
	 * @author Alanmars
	 */
	public class Button extends SimpleButton
	{
		private var m_upColor : uint = 0xffcc00;
		private var m_overColor : uint = 0xccff00;
		private var m_downColor : uint = 0x00ccff;
		private var m_size : uint = 80;
		
		public function Button() 
		{
			upState = new ButtonDisplayState(m_upColor, m_size);
			overState = new ButtonDisplayState(m_overColor, m_size);
			downState = new ButtonDisplayState(m_downColor, m_size);
			hitTestState = overState;
			/*
			hitTestState = new ButtonDisplayState(m_upColor, m_size * 2);
			hitTestState.x = - (m_size / 4);
			hitTestState.y = hitTestState.x;
			*/
			useHandCursor = true;
		}
		
	}

}