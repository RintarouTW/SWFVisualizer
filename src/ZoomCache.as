package  
{
	import flash.display.*;	
	import flash.geom.*;
	import flash.events.*;
	import fl.motion.MatrixTransformer;
	import flash.utils.Timer;
	
	/**
	 * ZoomCache is a Sprite automatically mapped to the cordinate space of the scale target's parent.
	 * This is reusable since all the matrix trasformation are done in Zoom().
	 */
	public class ZoomCache extends Sprite
	{	
		private var _cachedBitmap:Bitmap;
		private var _cachedBitmapData:BitmapData;
		private var _target:DisplayObject, _targetParent:DisplayObjectContainer;
		private var scaleOverTimer:Timer;
		private var _tempShape:Shape = new Shape();
		
		public function ZoomCache()
		{
			visible = false; // default hidden
			scaleOverTimer = new Timer(600, 1);
			scaleOverTimer.addEventListener(TimerEvent.TIMER, onZoomOver);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {			
			_cachedBitmapData = new BitmapData(stage.fullScreenWidth, stage.fullScreenHeight, true, 0x000000);
			_cachedBitmap = new Bitmap(_cachedBitmapData, "auto", true);
			addChild(_cachedBitmap);
			
			_tempShape.visible = false;
			addChild(_tempShape);			
		}
		
		/**
		 * Zoom in/out the target by scale and using the bitmap cache while zooming.
		 * @param	target  The target you want to zoom in or out.
		 * @param	scale	Scale of the indicated target, if > 1.0 then zoom in, else zoom out.
		 * @return Final scaled number in the matrix.
		 */
		public function Zoom(target:DisplayObject, scale:Number):Number {
			_target = target;
			_targetParent = target.parent;
			
			if (!scaleOverTimer.running) {				
				transform.matrix = _targetParent.transform.matrix; // sync to the target's parent position
				_tempShape.transform.matrix = _target.transform.matrix.clone(); // sync _tempShape to target
				drawScaleCache(_targetParent);
				_targetParent.visible   = false;
				visible = true;
			} 
			
			/* Calculate the final matrix on _tempShape (as a replacement of swfViewer.container)
			 * _tempShape has no childs at all, it would be scaled fast to get the transformed matrix.
			 * In the mean time, _scaleCache will be used to show the scaled bitmap instead of real container scaling.
			 * Once time out, _tempShape's matrix will be assigned to the swfViewer.container to do the real scaling.
			 */
			var externalCenter:Point = new Point(mouseX,mouseY);
			var internalCenter:Point = new Point(_tempShape.mouseX, _tempShape.mouseY);
			var mat:Matrix           = _tempShape.transform.matrix.clone();			
			
			mat.scale(scale, scale);
			MatrixTransformer.matchInternalPointWithExternal(mat, internalCenter, externalCenter);			
			_tempShape.transform.matrix = mat;
			
			/* Calculate the transform matrix of _cachedBitmap */
			externalCenter = new Point(mouseX, mouseY);
			internalCenter = new Point(_cachedBitmap.mouseX, _cachedBitmap.mouseY);
			mat = _cachedBitmap.transform.matrix.clone();
			
			mat.scale(scale, scale);
			MatrixTransformer.matchInternalPointWithExternal(mat, internalCenter, externalCenter);
			_cachedBitmap.transform.matrix = mat;

			/* start the timer in case more scale events coming */
			scaleOverTimer.reset();
			scaleOverTimer.start();
			return mat.a;
		}
		
		private function onZoomOver(e:Event):void {
			_target.transform.matrix = _tempShape.transform.matrix; /* real heavy load scaling */
			_targetParent.visible = true;
			visible = false;
		}
		
		private function drawScaleCache(target:DisplayObject):void {
			var mat:Matrix = new Matrix();
			_cachedBitmap.transform.matrix = mat; // reset before drawing
			var clipRect:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			_cachedBitmapData.fillRect(clipRect, 0x151515);
			_cachedBitmapData.draw(_targetParent, null, null, null, clipRect, true);
		}
	}
}