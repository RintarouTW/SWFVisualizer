package  
{
	/**
	 * ColorInfo class is a utility to do color conversion between hex string, uint and CSS color string.
	 * @author Rintarou Chou
	 */
	public class ColorInfo
	{
		
		private var _hasAlpha:Boolean = false;
		private var _Alpha:Number = 1.0;
		private var _Color:uint;
		
		/**
		 * @param	colorStr color in hex string format. (ex: "0xffffffff")
		 *          <p>Notice: colorStr is following the pixel format in SWF as following:</p>
		 * 			<p>1. "0xBBGGRR"   => 0xRRGGBB (uint) without Alpha</p>
		 *			<p>2. "0xAABBGGRR" => 0xAARRGGBB (uint) with Alpha</p>
		 */
		public function ColorInfo(colorStr:String = null) 
		{
			if (colorStr)
				string2Color(colorStr);
		}
		
		/**
		 * Get RGB color in CSS string format.
		 * @return CSS String, ex: "rgb(0, 0, 0)"
		 */
		public function getRGB():String {
			var r:uint, g:uint, b:uint;
			r = (_Color & 0x00ff0000) >> 16;
			g = (_Color & 0x0000ff00) >> 8;
			b = (_Color & 0x000000ff);
			
			return "rgb(" + r.toString() + ", " + g.toString() + ", " + b.toString() + ")";
		}
		
		/**
		 * Get RGBA color in CSS string format.
		 * @return CSS String, ex: "rgb(0, 0, 0)"
		 */
		public function getRGBA():String {
			var r:uint, g:uint, b:uint;
			r = (_Color & 0x00ff0000) >> 16;
			g = (_Color & 0x0000ff00) >> 8;
			b = (_Color & 0x000000ff);
			return "rgba(" + r.toString() + ", " + g.toString() + ", " + b.toString() + ", " + _Alpha.toString() + ")";
		}
		
		/**
		 * In order to reuse the ColorInfo object without renew instance, user can use string2Color() to set the color.
		 * @param	colorStr color in hex string format. (ex: "0xffffffff")
		 *          <p>Notice: colorStr is following the pixel format in SWF as following:</p>
		 * 			<p>1. "0xBBGGRR"   => 0xRRGGBB (uint) without Alpha</p>
		 *			<p>2. "0xAABBGGRR" => 0xAARRGGBB (uint) with Alpha</p>
		 */
		public function string2Color(colorStr:String):void {
			// colorStr Format
			// "0xBBGGRR"   => 0xRRGGBB without Alpha
			// "0xAABBGGRR" => 0xRRGGBB with Alpha
			
			_Color = uint(colorStr);
			
			if (colorStr.length > 8) {
				var a:Number = ((_Color >> 24) & 0xff);
				_hasAlpha = true;
				_Alpha =  Number(a/255);
			} else {
				_Alpha = 1.0;
				_hasAlpha = false;				
			}
			
			_Color = ((_Color & 0x000000ff) << 16) | (_Color & 0x0000ff00) | ((_Color & 0x00ff0000) >> 16);
		}
		
		/**
		 * True if the color has Alpha component.
		 */
		public function get hasAlpha():Boolean {
			return _hasAlpha;
		}
		
		/**
		 * Alpha value between 0.0 and 1.0.
		 */
		public function get Alpha():Number {
			return _Alpha;
		}
		
		/**
		 * Color value in uint.
		 */
		public function get Color():uint {
			return _Color;
		}
		
	}
}