/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.display {
	import net.badimon.five3D.utils.InternalUtils;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;	

	/**
	 * The Bitmap3D class is the equivalent in the FIVe3D package of the Bitmap class in the Flash package.
	 * 
	 * @see http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/display/Bitmap.html
	 */
	public class Bitmap3D extends Shape implements IObject3D {

		private var __visible:Boolean = true;
		private var __x:Number = 0;
		private var __y:Number = 0;
		private var __z:Number = 0;
		private var __scaleX:Number = 1;
		private var __scaleY:Number = 1;
		private var __scaleZ:Number = 1;
		private var __rotationX:Number = 0;
		private var __rotationY:Number = 0;
		private var __rotationZ:Number = 0;
		private var __matrix:Matrix3D;
		private var __concatenatedMatrix:Matrix3D;
		private var __bitmapData:BitmapData;
		private var __smoothing:Boolean;
		private var __singleSided:Boolean = false;
		private var __flatShaded:Boolean = false;
		private var __render:Boolean = true;
		private var __renderCulling:Boolean = false;
		private var __renderTessellation:Boolean = true;
		private var __renderProjection:Boolean = true;
		private var __renderBitmap:Boolean = true;
		private var __drawing:Boolean = false;
		private var __renderShading:Boolean = false;
		private var __flatShading:Boolean = false;
		// Calculation
		private var __isMatrixDirty:Boolean = true;
		private var __autoUpdatePropertiesOnMatrixChange:Boolean = false;
		private var __vectorIn:Vector.<Number>;
		private var __vectorOut:Vector.<Number>;
		private var __normalVector:Vector3D = new Vector3D();
		private var __normalVectorCalculated:Boolean = false;
		private var __cameraVector:Vector3D = new Vector3D();
		private var __culling:Boolean = false;
		private var __width:int;
		private var __height:int;
		private var __verticesIn:Vector.<Number>;
		private var __verticesOut:Vector.<Number>;
		private var __verticesProjected:Vector.<Number>;
		private var __indices:Vector.<int>;
		private var __uvtData:Vector.<Number>;

		/**
		 * Creates a new Bitmap3D instance.
		 * 
		 * @param bitmapData	The BitmapData object being associated with the Bitmap3D instance.
		 * @param smoothing	Whether or not the Bitmap3D instance is smoothed when scaled.
		 */
		public function Bitmap3D(bitmapData:BitmapData = null, smoothing:Boolean = true) {
			__matrix = new Matrix3D();
			__concatenatedMatrix = new Matrix3D();
			__bitmapData = bitmapData;
			__smoothing = smoothing;
			initVectors();
			initVectorsBitmap();
		}

		private function initVectors():void {
			__vectorIn = new Vector.<Number>(6, true);
			__vectorIn[5] = 1;
			__vectorOut = new Vector.<Number>(6, true);
		}

		private function initVectorsBitmap():void {
			__verticesIn = new Vector.<Number>(12, true);
			__verticesOut = new Vector.<Number>(12, true);
			__verticesProjected = new Vector.<Number>(8, true);
			__indices = new Vector.<int>(6, true);
			__indices[1] = 1;
			__indices[2] = 2;
			__indices[3] = 1;
			__indices[4] = 2;
			__indices[5] = 3;
			__uvtData = new Vector.<Number>(12, true);
			__uvtData[3] = 1;
			__uvtData[7] = 1;
			__uvtData[9] = 1;
			__uvtData[10] = 1;
		}

		//----------------------------------------------------------------------------------------------------
		// Properties (from normal "Bitmap" class)
		//----------------------------------------------------------------------------------------------------
		/**
		 * Whether or not the Bitmap3D instance is visible. When the Bitmap3D instance is not visible, 3D calculation and rendering are not executed.
		 * Any change of this property takes effect the next time the instance is being rendered. 
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>visible</code> property.</p>
		 */
		override public function get visible():Boolean {
			return __visible;
		}

		override public function set visible(value:Boolean):void {
			__visible = value;
		}

		/**
		 * Indicates the x coordinate (in pixels) of the mouse position on the 3D plane defined by the Bitmap3D instance.
		 * 
		 * <p>This property calculation is intensive and requires the same matrix transformations than the <code>mouseY</code> property calculation.
		 * Therefore using <code>mouseXY</code> is faster than <code>mouseX</code> and <code>mouseY</code> separately.</p>
		 * 
		 * @see #mouseXY
		 */
		override public function get mouseX():Number {
			var scene:Scene3D = InternalUtils.getScene(this);
			if (scene == null) {
				return NaN;
			} else {
				return InternalUtils.getInverseCoordinates(__concatenatedMatrix, scene.mouseX, scene.mouseY, scene.viewDistance).x;
			}
		}

		/**
		 * Indicates the y coordinate (in pixels) of the mouse position on the 3D plane defined by the Bitmap3D instance.
		 * 
		 * <p>This property calculation is intensive and requires the same matrix transformations than the <code>mouseY</code> property calculation.
		 * Therefore using <code>mouseXY</code> is faster than <code>mouseX</code> and <code>mouseY</code> separately.</p>
		 * 
		 * @see #mouseXY
		 */
		override public function get mouseY():Number {
			var scene:Scene3D = InternalUtils.getScene(this);
			if (scene == null) {
				return NaN;
			} else {
				return InternalUtils.getInverseCoordinates(__concatenatedMatrix, scene.mouseX, scene.mouseY, scene.viewDistance).y;
			}
		}

		/**
		 * Indicates the x and y coordinates (in pixels) of the mouse position on the 3D plane defined by the Bitmap3D instance.
		 */
		public function get mouseXY():Point {
			var scene:Scene3D = InternalUtils.getScene(this);
			if (scene == null) {
				return null;
			} else {
				return InternalUtils.getInverseCoordinates(__concatenatedMatrix, scene.mouseX, scene.mouseY, scene.viewDistance);
			}
		}

		/**
		 * Indicates the x coordinate along the x-axis of the Bitmap3D instance relative to the local coordinate system of the 3D parent container.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>x</code> property.</p>
		 */
		override public function get x():Number {
			return __x;
		}

		override public function set x(value:Number):void {
			__x = value;
			__isMatrixDirty = true;
			askRendering();
		}

		/**
		 * Indicates the y coordinate along the y-axis of the Bitmap3D instance relative to the local coordinate system of the 3D parent container.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>y</code> property.</p>
		 */
		override public function get y():Number {
			return __y;
		}

		override public function set y(value:Number):void {
			__y = value;
			__isMatrixDirty = true;
			askRendering();
		}

		/**
		 * Indicates the z coordinate along the z-axis of the Bitmap3D instance relative to the local coordinate system of the 3D parent container.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>z</code> property.</p>
		 */
		override public function get z():Number {
			return __z;
		}

		override public function set z(value:Number):void {
			__z = value;
			__isMatrixDirty = true;
			askRendering();
		}

		/**
		 * Indicates the x-axis scale (percentage) of the Bitmap3D instance from its registration point relative to the local coordinate system of the 3D parent container.
		 * A value of 0.0 equals a 0% scale and a value of 1.0 equals a 100% scale.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>scaleX</code> property.</p>
		 */
		override public function get scaleX():Number {
			return __scaleX;
		}

		override public function set scaleX(value:Number):void {
			__scaleX = value;
			__isMatrixDirty = true;
			askRendering();
		}

		/**
		 * Indicates the y-axis scale (percentage) of the Bitmap3D instance from its registration point relative to the local coordinate system of the 3D parent container.
		 * A value of 0.0 equals a 0% scale and a value of 1.0 equals a 100% scale.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>scaleY</code> property.</p>
		 */
		override public function get scaleY():Number {
			return __scaleY;
		}

		override public function set scaleY(value:Number):void {
			__scaleY = value;
			__isMatrixDirty = true;
			askRendering();
		}

		/**
		 * Indicates the z-axis scale (percentage) of the Bitmap3D instance from its registration point relative to the local coordinate system of the 3D parent container.
		 * A value of 0.0 equals a 0% scale and a value of 1.0 equals a 100% scale.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>scaleZ</code> property.</p>
		 */
		override public function get scaleZ():Number {
			return __scaleZ;
		}

		override public function set scaleZ(value:Number):void {
			__scaleZ = value;
			__isMatrixDirty = true;
			askRendering();
		}

		/**
		 * Indicates the x-axis rotation (in degrees) of the Bitmap3D instance from its original orientation relative to the local coordinate system of the 3D parent container.
		 * Values go from -180 (included) to 180 (included). Values outside this range will be formated to fit in.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>rotationX</code> property.</p>
		 */
		override public function get rotationX():Number {
			return __rotationX;
		}

		override public function set rotationX(value:Number):void {
			__rotationX = InternalUtils.formatRotation(value);
			__isMatrixDirty = true;
			askRendering();
		}

		/**
		 * Indicates the y-axis rotation (in degrees) of the Bitmap3D instance from its original orientation relative to the local coordinate system of the 3D parent container.
		 * Values go from -180 (included) to 180 (included). Values outside this range will be formated to fit in.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>rotationY</code> property.</p>
		 */
		override public function get rotationY():Number {
			return __rotationY;
		}

		override public function set rotationY(value:Number):void {
			__rotationY = InternalUtils.formatRotation(value);
			__isMatrixDirty = true;
			askRendering();
		}

		/**
		 * Indicates the z-axis rotation (in degrees) of the Bitmap3D instance from its original orientation relative to the local coordinate system of the 3D parent container.
		 * Values go from -180 (included) to 180 (included). Values outside this range will be formated to fit in.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>rotationZ</code> property.</p>
		 */
		override public function get rotationZ():Number {
			return __rotationZ;
		}

		override public function set rotationZ(value:Number):void {
			__rotationZ = InternalUtils.formatRotation(value);
			__isMatrixDirty = true;
			askRendering();
		}

		/**
		 * Indicates the BitmapData object being associated with the Bitmap3D instance.
		 * 
		 * * <p>This property has the same behavior than the normal Bitmap <code>bitmapData</code> property.</p>
		 */
		public function get bitmapData():BitmapData {
			return __bitmapData;
		}

		public function set bitmapData(value:BitmapData):void {
			__bitmapData = value;
			if (__bitmapData == null) {
				if (__drawing) removeBitmap();
			} else {
				if (__bitmapData.width != __width || __bitmapData.height != __height) {
					__renderTessellation = true;
					__renderProjection = true;
				}
			}
			__renderBitmap = true;
		}

		/**
		 * Whether or not the Bitmap3D instance is smoothed when scaled.
		 * If true, the bitmap is smoothed when scaled. If false, the bitmap is not smoothed when scaled.
		 */
		public function get smoothing():Boolean {
			return __smoothing;
		}

		public function set smoothing(value:Boolean):void {
			__smoothing = value;
			__renderBitmap = true;
		}

		//----------------------------------------------------------------------------------------------------
		// Properties (new)
		//----------------------------------------------------------------------------------------------------
		/**
		 * Indicates a Matrix3D object representing the combined transformation matrixes of the Bitmap3D instance and all of its parent 3D objects, back to the scene level.
		 */
		public function get concatenatedMatrix():Matrix3D {
			return __concatenatedMatrix;
		}

		/**
		 * A Matrix3D object containing values that affect the scaling, rotation, and translation of the Bitmap3D instance.
		 */
		public function get matrix():Matrix3D { 
			if (__isMatrixDirty) {
				InternalUtils.setMatrix(__matrix, __x, __y, __z, __rotationX, __rotationY, __rotationZ, __scaleX, __scaleY, __scaleZ);
				__isMatrixDirty = false;
			}
			return __matrix; 
		}

		public function set matrix(value:Matrix3D):void { 
			__matrix = value;
			__isMatrixDirty = false;
			askRendering(); 
			if (autoUpdatePropertiesOnMatrixChange) {
				updatePropertiesFromMatrix();
			}
		}

		/**
		 * Whether or not the Bitmap3D instance transformation properties (x, y, z, scaleX, scaleY, scaleZ, rotationX, rotationY, rotationZ) are updated immediately after the matrix has been changed manually.
		 * 
		 * @see #matrix
		 * @see #updatePropertiesFromMatrix()
		 */
		public function get autoUpdatePropertiesOnMatrixChange():Boolean {
			return __autoUpdatePropertiesOnMatrixChange;
		}

		public function set autoUpdatePropertiesOnMatrixChange(value:Boolean):void {
			__autoUpdatePropertiesOnMatrixChange = value;
		}

		/**
		 * Whether or not the Bitmap3D instance is visible when not facing the screen.
		 */
		public function get singleSided():Boolean {
			return __singleSided;
		}

		public function set singleSided(value:Boolean):void {
			__singleSided = value;
			if (__singleSided) {
				__renderCulling = true;
			} else {
				__renderCulling = false;
				__culling = false;
			}
		}

		/**
		 * Whether or not the Bitmap3D instance colors are being altered by the scene ligthing parameters.
		 * 
		 * @see net.badimon.five3D.display.Scene3D.#ambientLightVector
		 * @see net.badimon.five3D.display.Scene3D.#ambientLightIntensity
		 */
		public function get flatShaded():Boolean {
			return __flatShaded;
		}

		public function set flatShaded(value:Boolean):void {
			__flatShaded = value;
			if (__flatShaded) {
				__renderShading = true;
			} else {
				__renderShading = false;
				if (__flatShading) removeFlatShading();
			}
		}

		//----------------------------------------------------------------------------------------------------
		// Methods (new)
		//----------------------------------------------------------------------------------------------------
		/**
		 * Updates the transformation properties (x, y, z, scaleX, scaleY, scaleZ, rotationX, rotationY, rotationZ) of the Bitmap3D instance according to the matrix values.
		 * 
		 * @see #matrix
		 * @see #autoUpdatePropertiesOnMatrixChange
		 */
		public function updatePropertiesFromMatrix():void {
			var matrixVector:Vector.<Vector3D> = __matrix.decompose();
			var translationVector:Vector3D = matrixVector[0];
			var rotationVector:Vector3D = matrixVector[1];
			var scaleVector:Vector3D = matrixVector[2];
			__x = translationVector.x;
			__y = translationVector.y;
			__z = translationVector.z;
			__rotationX = InternalUtils.formatRotation(rotationVector.x * InternalUtils.RAD_TO_DEG);
			__rotationY = InternalUtils.formatRotation(rotationVector.y * InternalUtils.RAD_TO_DEG);
			__rotationZ = InternalUtils.formatRotation(rotationVector.z * InternalUtils.RAD_TO_DEG);
			__scaleX = scaleVector.x;
			__scaleY = scaleVector.y;
			__scaleZ = scaleVector.z;
		}

		//----------------------------------------------------------------------------------------------------
		// Workflow
		//----------------------------------------------------------------------------------------------------
		/**
		 * @private
		 */
		public function askRendering():void {
			__render = true;
			if (__singleSided) __renderCulling = true;
			__renderProjection = true;
			__renderBitmap = true;
			if (__flatShaded) __renderShading = true;
		}

		/**
		 * @private
		 */
		public function askRenderingShading():void {
			if (__flatShaded) __renderShading = true;
		}

		/**
		 * @private
		 */
		public function render(scene:Scene3D):void {
			if (!__visible && super.visible) super.visible = false;
			else if (__visible) {
				if (__render) {
					if (__isMatrixDirty) {	
						InternalUtils.setMatrix(__matrix, __x, __y, __z, __rotationX, __rotationY, __rotationZ, __scaleX, __scaleY, __scaleZ);
						__isMatrixDirty = false;
					}
					InternalUtils.setConcatenatedMatrix(__concatenatedMatrix, parent, __matrix);
					__normalVectorCalculated = false;
					__render = false;
				}
				if (__renderCulling) {
					setNormalVector();
					setCulling(scene.viewDistance);
					__normalVectorCalculated = true;
					__renderCulling = false;
				}
				if (__culling) {
					if (super.visible) super.visible = false;
				} else {
					if (!super.visible) super.visible = true;
					if (__bitmapData != null) {
						if (__renderTessellation) {
							setTessellation();
							__renderTessellation = false;
						}
						if (__renderProjection) {
							setProjection(scene.viewDistance);
							__renderProjection = false;
						}
						if (__renderBitmap) {
							drawBitmap();
							__renderBitmap = false;
						}
						if (__renderShading) {
							setNormalVector();
							applyFlatShading(scene);
							__renderShading = false;
						}
					}
				}
			}
		}

		private function setNormalVector():void {
			__concatenatedMatrix.transformVectors(__vectorIn, __vectorOut);
			__normalVector.x = __vectorOut[3] - __vectorOut[0];
			__normalVector.y = __vectorOut[4] - __vectorOut[1];
			__normalVector.z = __vectorOut[5] - __vectorOut[2];
		}

		private function setCulling(viewDistance:Number):void {
			__cameraVector.x = __vectorOut[0];
			__cameraVector.y = __vectorOut[1];
			__cameraVector.z = __vectorOut[2] + viewDistance;
			__culling = __normalVector.dotProduct(__cameraVector) < 0;
		}

		private function setTessellation():void {
			__width = __bitmapData.width;
			__height = __bitmapData.height; 
			__verticesIn[3] = __width;
			__verticesIn[7] = __height;
			__verticesIn[9] = __width;
			__verticesIn[10] = __height;
		}

		private function setProjection(viewDistance:Number):void {
			var perspective:Number;
			__concatenatedMatrix.transformVectors(__verticesIn, __verticesOut);
			perspective = viewDistance / (__verticesOut[2] + viewDistance);
			__verticesProjected[0] = __verticesOut[0] * perspective;
			__verticesProjected[1] = __verticesOut[1] * perspective;
			__uvtData[2] = perspective;
			perspective = viewDistance / (__verticesOut[5] + viewDistance);
			__verticesProjected[2] = __verticesOut[3] * perspective;
			__verticesProjected[3] = __verticesOut[4] * perspective;
			__uvtData[5] = perspective;
			perspective = viewDistance / (__verticesOut[8] + viewDistance);
			__verticesProjected[4] = __verticesOut[6] * perspective;
			__verticesProjected[5] = __verticesOut[7] * perspective;
			__uvtData[8] = perspective;
			perspective = viewDistance / (__verticesOut[11] + viewDistance);
			__verticesProjected[6] = __verticesOut[9] * perspective;
			__verticesProjected[7] = __verticesOut[10] * perspective;
			__uvtData[11] = perspective;
		}

		private function drawBitmap():void {
			super.graphics.clear();
			super.graphics.beginBitmapFill(__bitmapData, null, false, __smoothing);
			super.graphics.drawTriangles(__verticesProjected, __indices, __uvtData);
			__drawing = true;
		}

		private function removeBitmap():void {
			super.graphics.clear();
			__drawing = false;
		}

		private function applyFlatShading(scene:Scene3D):void {
			__normalVector.normalize();
			InternalUtils.setFlatShading(this, __normalVector, scene.ambientLightVectorNormalized, scene.ambientLightIntensity, alpha);
			__flatShading = true;
		}

		private function removeFlatShading():void {
			transform.colorTransform = new ColorTransform();
			__flatShading = false;
		}

		//----------------------------------------------------------------------------------------------------
		// Errors
		//----------------------------------------------------------------------------------------------------
		/**
		 * @private
		 */
		override public function get height():Number {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set height(value:Number):void {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function get rotation():Number {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set rotation(value:Number):void {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function get scale9Grid():Rectangle {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set scale9Grid(value:Rectangle):void {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function get scrollRect():Rectangle {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set scrollRect(value:Rectangle):void {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function get width():Number {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set width(value:Number):void {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function globalToLocal(point:Point):Point {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function localToGlobal(point:Point):Point {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function get graphics():Graphics {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}
	}
}