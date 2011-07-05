package ui
{
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;

	/**
	 * ToolTip is a simple popup box.
	 */
	public class ToolTip extends Sprite
	{
		private var _text:TextField;
		private var _config:Object;
		private var shadownFilter:DropShadowFilter;
		
		/**
		 * @param	hidden default was hidden.
		 */
		public function ToolTip(hidden:Boolean = true)
		{
			_config = Global.config.tooltip;	
			
			_text = UIUtil.createLabel(5, 5, "");
			_text.multiline = false;
			_text.mouseEnabled = false;
			_text.border = true;
			_text.textColor = _config.textColor;
			
			addChild(_text);
			alpha = _config.alpha;
			mouseEnabled = false;
			
			draw();
			
			shadownFilter = new DropShadowFilter();
			filters = [shadownFilter];
			
			visible = !hidden;
		}
		
		/**
		 * Set the text.
		 */
		public function set text(txt:String):void {
			_text.text = txt;
			draw();
		}
		
		/**
		 * Pop up the tooltip with the message text.
		 * @param	left left of the tooltip.
		 * @param	top  top of the tooltip.
		 * @param	txt  The message text.
		 */
		public function show(left:int, top:int, txt:String = null):void {
			if (txt) {
				text = txt;
			}
			x = left;
			y = top;
			visible = true;
		}
		
		/**
		 * hide the tooltip.
		 */
		public function hide():void {
			visible = false;
		}
		
		/**
		 * Draw the background.
		 */
		private function draw():void {
			graphics.clear();
			graphics.beginFill(_config.backgroundColor);
			graphics.drawRoundRect(0, 0, width + 10, height + 10, 5, 5);
			graphics.endFill();
		}		
	}
}