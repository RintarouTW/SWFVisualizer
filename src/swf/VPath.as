package swf
{
	import flash.display.Graphics;
	import flash.geom.Point;
	/**
	 * VPath contains a list of continuous edges. There are two kinds of VPath: 1. Right fill path, 2. Left fill path.
	 * Left fill path is seen as normalized to right fill path in this class.
	 * <p> Right fill edges will be drawn in order, and left fill edges will be drawn in reversed order. </p>
	 */
	public class VPath
	{
		private var edgeList:Array;
		private var direction:Boolean; /* right fill = true, left fill = false */
		private var canvasStr:String = "";
		
		/**
		 * 
		 * @param	edges     The edge list (Array), each element is a VEdge.
		 * @param	rightFill set if is right fill path.
		 */
		public function VPath(edges:Array, rightFill:Boolean)
		{
			edgeList = edges;
			direction = rightFill;
		}
		
		public function get isRightFill():Boolean {
			return direction;
		}
		
		// normalized: left fill path is converted to right fill path although the edge sequence in the edgeList is not changed, but we reverse the way to traverse the edgeList.
		// get start point of the path (in normalized view).
		public function get startPoint():Point {
			if (direction) {
				return (edgeList[0] as VEdge).startPoint;
			} else {
				return (edgeList[edgeList.length - 1] as VEdge).endPoint;
			}
		}
		
		// normalized: left fill path is converted to right fill path although the edge sequence in the edgeList is not changed, but we reverse the way to traverse the edgeList.
		// get end point of the path (in normalized view).
		public function get endPoint():Point {
			if (direction) {
				return (edgeList[edgeList.length - 1] as VEdge).endPoint;
			} else {
				return (edgeList[0] as VEdge).startPoint;
			}			
		}
		
		/**
		 * Draw the VPath on the graphics.
		 * @param	graphics the graphics to be drawn.
		 * @return canvas code string to draw the path.
		 */
		public function draw(graphics:Graphics):String {
			var i:uint;
			var startP:Point;
			
			if (direction) {
				startP = (edgeList[0] as VEdge).startPoint;
				graphics.moveTo(startP.x, startP.y);
				
				canvasStr = "ctx.moveTo(" + startP.x + ", " + startP.y + ");\n";
				
				for (i = 0; i < edgeList.length; i++) {
					canvasStr += edgeList[i].draw(graphics, direction);
				}
			} else {
				startP = (edgeList[edgeList.length - 1] as VEdge).endPoint;
				graphics.moveTo(startP.x, startP.y);
				
				canvasStr = "ctx.moveTo(" + startP.x + ", " + startP.y + ");\n";
				
				for (i = edgeList.length; i > 0; i--) {
					canvasStr += edgeList[i-1].draw(graphics, direction);
				}
			}
			
			return canvasStr;
		}		
		
		public function draw2(graphics:Graphics):String {
			var i:uint;
			
			if (direction) {				
				for (i = 0; i < edgeList.length; i++) {
					canvasStr += edgeList[i].draw(graphics, direction);
				}
			} else {
				for (i = edgeList.length; i > 0; i--) {
					canvasStr += edgeList[i-1].draw(graphics, direction);
				}
			}
			
			return canvasStr;
		}		
	}
}