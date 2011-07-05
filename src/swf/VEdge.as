package swf
{
	import flash.display.Graphics;
	import flash.geom.Point;
	/**
	 * VEdge has no direction itself, controlled by VPath to call darw(direction:Boolean);
	 */
	public class VEdge
	{
		private var startP:Point;
		private var endP:Point;
		
		private var controlP:Point = null;
		private var deltaX:Number, deltaY:Number;
		private var canvasStr:String;
		
		public function get startPoint():Point {
			return startP;
		}
		
		public function get endPoint():Point {
			return endP;
		}
		
		/**
		 * Set the edge as a line.
		 * @param	p1x x of startP
		 * @param	p1y y of startP
		 * @param	p2x x of endP
		 * @param	p2y y of endP
		 */
		public function asLine(p1x:Number, p1y:Number, p2x:Number, p2y:Number):void
		{
			startP   = new Point();
			endP     = new Point();
			startP.x = Math.round(p1x / 20);
			startP.y = Math.round(p1y / 20);
			endP.x   = Math.round(p2x / 20);
			endP.y   = Math.round(p2y / 20);
			deltaX   = endP.x - startP.x;
			deltaY   = endP.y - startP.y;
		}
		
		/**
		 * Set the edge as a curve.
		 * @param	p1x x of start point
		 * @param	p1y y of start point
		 * @param	cpX x of control point
		 * @param	cpY y of control point
		 * @param	p2x x of end point
		 * @param	p2y y of end point
		 */
		public function asCurve(p1x:Number, p1y:Number, cpX:Number, cpY:Number, p2x:Number, p2y:Number):void
		{
			startP   = new Point();
			controlP = new Point();
			endP     = new Point();
			
			startP.x   = Math.round(p1x/20);
			startP.y   = Math.round(p1y/20);
			endP.x     = Math.round(p2x/20);
			endP.y     = Math.round(p2y/20);
			controlP.x = Math.round(cpX/20);
			controlP.y = Math.round(cpY / 20);
			
			deltaX = endP.x - controlP.x;
			deltaY = endP.y - controlP.y;
		}
		
		/**
		 * Draw the arrow of the edge.
		 * @param	graphics Graphics
		 */
		public function drawArrow(graphics:Graphics):void {
			
			// draw arrow
			var n:Point = new Point(-deltaY, deltaX); // normal vector of (deltaX, deltaY)
			n.normalize(2);
				
			// arrow's extended point follow (-deltaX, -deltaY) vector.
			var a:Point = new Point(-deltaX, -deltaY);
			a.normalize(6);
			a.x += endP.x;
			a.y += endP.y;
			
			graphics.moveTo(endP.x, endP.y);
			graphics.beginFill(0xffffff);
			graphics.lineTo(a.x + n.x, a.y + n.y);
			graphics.lineTo(a.x - n.x, a.y - n.y);
			graphics.endFill();
			graphics.moveTo(endP.x, endP.y);
		}
		
		/**
		 * Draw the edge on the graphics.
		 * @param	graphics	The graphics to be drawn.
		 * @param	direction	Direction of this edge (true : startP -> endP, false : endP -> startP)
		 * @return  Cavans string of the edge.
		 */
		public function draw(graphics:Graphics, direction:Boolean):String {
			if (controlP) {
				if (direction) {
					canvasStr = "ctx.quadraticCurveTo(" + controlP.x + ", " + controlP.y + ", " +  endP.x + ", " + endP.y + ");\n";
					graphics.curveTo(controlP.x, controlP.y, endP.x, endP.y);
				} else {
					canvasStr = "ctx.quadraticCurveTo(" + controlP.x + ", " + controlP.y + ", " +  startP.x + ", " + startP.y + ");\n";
					graphics.curveTo(controlP.x, controlP.y, startP.x, startP.y);
				}
			} else {
				if (direction) {
					canvasStr = "ctx.lineTo(" + endP.x + ", " + endP.y + ");\n";
					graphics.lineTo(endP.x, endP.y);
				} else {
					canvasStr = "ctx.lineTo(" + startP.x + ", " + startP.y + ");\n";
					graphics.lineTo(startP.x, startP.y);
				}
			}
			return canvasStr;
		}
	}

}