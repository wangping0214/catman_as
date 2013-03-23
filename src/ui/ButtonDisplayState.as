package ui 
{
	import flash.display.Shape;
	/**
	 * ...
	 * @author Alanmars
	 */
	public class ButtonDisplayState extends Shape
	{
		private var m_bgColor : uint;
		private var m_size : uint;
		
		public function ButtonDisplayState(bgColor : uint, size : uint) 
		{
			m_bgColor = bgColor;
			m_size = size;
			draw();
		}
		
		private function draw() : void
		{
			graphics.beginFill(m_bgColor);
			graphics.drawRect(0, 0, 75, 25);
			graphics.endFill();
		}
	}

}