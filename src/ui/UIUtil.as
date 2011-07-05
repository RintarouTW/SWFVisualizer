package ui
{
	import flash.text.*;
	import flash.display.*;
	
	/**
	 * Utility to create the label, drawing bitmap and apply default text format.
	 */
	public class UIUtil
	{
		/**
		 * Apply default style setting to the text format.
		 * @param	tf The text format to be applied with default style setting.
		 * @return applied text format.
		 */
		public static function applyDefaultTextFormat(tf:TextFormat):TextFormat {
			var _config:Object = Global.config.system.textFormat;
			
			tf.font = _config.font;
			tf.size = _config.size;
			tf.color = _config.color;
			tf.bold = _config.bold;
			tf.leftMargin = _config.leftMargin;
			tf.rightMargin = _config.rightMargin;
			tf.size = 13;
			return tf;
		}
		
		/**
		 * Create a simple label which is a simple text field with default style text format.
		 * @param	left	left of the label.
		 * @param	top		top of the label.
		 * @param	txt		text string of the label.
		 * @param	type	@default TextFieldType.DYNAMIC
		 * @return	created text field as a label.
		 */
		public static function createLabel(left:int, top:int, txt:String, type:String = null):TextField {
			var labelText:TextField = new TextField();
			
			labelText.x = left;
			labelText.y = top;
			labelText.text = txt;
			labelText.textColor = Global.config.system.textColor;
			
			if (type) {	// as input box
				labelText.type = type;
			} else { // as label
				labelText.autoSize = TextFieldAutoSize.LEFT;
				labelText.type = TextFieldType.DYNAMIC;
				labelText.selectable = false;
				labelText.mouseEnabled = false;
			}
			
			labelText.antiAliasType = AntiAliasType.ADVANCED;
			labelText.gridFitType = GridFitType.SUBPIXEL;
			
			var tf:TextFormat = labelText.getTextFormat();
			applyDefaultTextFormat(tf);
			labelText.setTextFormat(tf);
			
			return labelText;
		}
		
		/**
		 * Draw the bitmap to the sprite's graphics.
		 * @param	sprite	The sprite need to be drawn with the bitmap.
		 * @param	bmp		Bitmap as the source.
		 */
		public static function drawBmp(sprite:Sprite, bmp:Bitmap):void {
			sprite.graphics.clear();
			sprite.graphics.beginBitmapFill(bmp.bitmapData, null, false, true);
			sprite.graphics.drawRect(0, 0, bmp.width, bmp.height);
			sprite.graphics.endFill();
		}
		
	}
	
}