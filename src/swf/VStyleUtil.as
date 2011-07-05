package swf
{
	import flash.display.*;
	import flash.geom.*;
	/**
	 * VStyleUtil provides the ability to decode the line style and fill style, then set the graphics to the corresponding line/fill style.
	 */
	public class VStyleUtil
	{	
		private static const JSON_OBJECT_TYPE_INFO:String = Global.config.system.JSON_OBJECT_TYPE_INFO;
		
		/**
		 * Decode the line style object and setup the graphics, return the corresponding Canvas code.
		 * @param	lineStyle		Line style object.
		 * @param	graphics		Graphics to be set.
		 * @param	overrideMatrix	Override the matrix in Line style object.
		 * @return generated Canvas code
		 */
		public static function lineStyle(lineStyle:Object, graphics:Graphics, overrideMatrix:Matrix = null):String {
			
			var canvasStr:String = "";
			var thickness:Number;
			var color:uint;
			var line_alpha:Number = 1.0;
			
			var pixelHinting:Boolean = false;
			var scaleMode:String 	= LineScaleMode.NORMAL;
			var caps:String 		= null;
			var joints:String 		= null;
			var miterLimit:Number 	= 3;			
			
			var colorInfo:ColorInfo = new ColorInfo();
			
			
			/* LINESTYLE2 */
			if (lineStyle[JSON_OBJECT_TYPE_INFO] == "LINESTYLE2") {
				
				thickness = lineStyle["Width"] / 20; // in twips => pixels				
				
				// StartCapStyle
				switch(lineStyle["StartCapStyle"]) {
					case 0:
						caps = CapsStyle.ROUND;
					break;
					case 1:
						caps = CapsStyle.NONE;
					break;
					case 2:
						caps = CapsStyle.SQUARE;
					break;
				}
				
				// JoinStyle
				switch(lineStyle["JoinStyle"]) {
					case 0:
						joints = JointStyle.ROUND;
					break;
					case 1:
						joints = JointStyle.BEVEL;
					break;
					case 2:
						joints = JointStyle.MITER;
						miterLimit = lineStyle["MiterLimitFactor"];
					break;
				}
				
				// scaleMode
				if (lineStyle["NoHScaleFlag"] & lineStyle["NoVScaleFlag"]) {
					scaleMode = LineScaleMode.NONE;
				} else if (lineStyle["NoHScaleFlag"]) {
						scaleMode = LineScaleMode.HORIZONTAL;
				} else if (lineStyle["NoVScaleFlag"]) {
						scaleMode = LineScaleMode.VERTICAL;
				}
				
				
				pixelHinting = lineStyle["PixelHintingFlag"];				
				
				if (lineStyle["HasFillFlag"] == 0) {
					colorInfo.string2Color(lineStyle["Color"]);
					if (colorInfo.hasAlpha) {
						line_alpha = colorInfo.Alpha;
					}
					
					color = colorInfo.Color;			
					
					//lineStyle(thickness:Number, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3)
					canvasStr = "ctx.lineWidth = " + thickness + ";\n";
					canvasStr += "ctx.lineCap = \"" + caps + "\";\n";
					canvasStr += "ctx.lineJoin = \"" + joints + "\";\n";	
					canvasStr += "ctx.miterLimit = " +  miterLimit + ";\n";
					canvasStr += "ctx.strokeStyle = \"" + colorInfo.getRGBA() + "\";\n";
					
					graphics.lineStyle(thickness, color, line_alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
					
				} else { // lineStyle["FillType"] : FILLSTYLE
					var params:Object = getGradient(lineStyle["FillType"], overrideMatrix);
					
					canvasStr += params.canvasStr;
					
					// Chrome's bug, gradient must be created completely before assigning to the context's fillStyle.
					// Which means addColorStop() must be called before assigning to the context's fillStyle.
					canvasStr += "ctx.strokeStyle = gradient;\n"; 
					graphics.lineGradientStyle(params.type, params.colors, params.alphas, params.ratios, params.matrix, 
											   params.spreadMethod, params.interpolationMethod, params.focalPointRatio);
				}
				
			}
			
			/* LINESTYLE */
			if (lineStyle[JSON_OBJECT_TYPE_INFO] == "LINESTYLE") {
			
				thickness = lineStyle["Width"] / 20; // in twips => pixels
				
				colorInfo.string2Color(lineStyle["Color"]);
				if (colorInfo.hasAlpha) {
					line_alpha = colorInfo.Alpha;
				}
				color = colorInfo.Color;
				
				canvasStr = "ctx.lineWidth = " + thickness + ";\n";
				canvasStr += "ctx.strokeStyle = \"" + colorInfo.getRGBA() + "\";\n";
				
				graphics.lineStyle(thickness, color, line_alpha);
			}
			
			return canvasStr;
		}	
		
		/**
		 * Decode the fill style object and setup the graphics, return the corresponding Canvas code.
		 * @param	fillstyle		Fill style object to be decoded.
		 * @param	graphics		Graphics to be set.
		 * @param	overrideMatrix	Override the matrix in fill style object if set.
		 * @return generated Canvas code
		 */
		public static function beginFill(fillstyle:Object, graphics:Graphics, overrideMatrix:Matrix = null):String {
			
			var canvasStr:String = "";
			var colorInfo:ColorInfo = new ColorInfo();
			
			////// Solid Fill /////
			if (fillstyle["FillStyleType"] == 0) { // solid fill
				colorInfo.string2Color(fillstyle.Color);
				if (colorInfo.hasAlpha) {					
					canvasStr = "ctx.fillStyle = \"" + colorInfo.getRGBA() + "\";\n";
					graphics.beginFill(colorInfo.Color, colorInfo.Alpha);
				} else {					
					canvasStr = "ctx.fillStyle = \"" + colorInfo.getRGB() + "\";\n";
					graphics.beginFill(colorInfo.Color);
				}
			}
						
			////// Gradient Fill //////
			// 0x10 = linear gradient fill, 0x12 = redial, 0x13 = focal radial
			if (fillstyle["FillStyleType"] & 0x10) { 
				
				var params:Object = getGradient(fillstyle, overrideMatrix);
				
				graphics.beginGradientFill(params.type, params.colors, params.alphas, params.ratios, params.matrix, 
				                           params.spreadMethod, params.interpolationMethod, params.focalPointRatio);
				canvasStr += params.canvasStr;
				
				// Chrome's bug, gradient must be created completely before assigning to the context's fillStyle.
				// Which means addColorStop() must be called before assigning to the context's fillStyle.
				canvasStr += "ctx.fillStyle = gradient;\n";
				
			} // End of Gradient
			
			
			/////// Bitmap Fill ///////
			// 0x40 = repeating bitmap fill, 0x41 clipped bitmap fill, 0x42 = non-smoothed repeating, 0x43 = non-smoothed clipped
			if (fillstyle["FillStyleType"] & 0x40) { 
				trace ("Bitmap Fill is not supported");
			}
			
			return canvasStr;
		}
		
		private static function getGradient(fillstyle:Object, overrideMatrix:Matrix = null):Object {
			
			var type:String, canvasStr:String;
			var colors:Array = new Array();
			var alphas:Array = new Array();
			var ratios:Array = new Array();
				
			var matrix:Matrix;
				
			var spreadMethod:String;
			var interpolationMethod:String;
			var focalPointRatio:Number = 0; // default
			
			var colorInfo:ColorInfo = new ColorInfo();
			
			//////// Linear gradient fill ////////////
			if (fillstyle["FillStyleType"] == 0x10) { // linear
				type = GradientType.LINEAR; // GradientType.LINEAR
			}
				
			//////// Radial & Focal Radial gradient fill ////////////
			if ((fillstyle["FillStyleType"] == 0x12) || (fillstyle["FillStyleType"] == 0x13) ){ // radial
				type = GradientType.RADIAL;
			} // End of Radial
			
			// GradientMatrix
			if (overrideMatrix) {
				matrix = overrideMatrix;
			} else {
				var gradientMatrix:Object = fillstyle["GradientMatrix"];
				
				//matrix = new Matrix(gradientMatrix["ScaleX"], gradientMatrix["RotateSkew0"], gradientMatrix["RotateSkew1"], gradientMatrix["ScaleY"], gradientMatrix["TranslateX"], gradientMatrix["TranslateY"]);
				var sx:Number = 0, sy:Number = 0, r0:Number = 0, r1:Number = 0, tx:Number = 0, ty:Number = 0;
				const scaler:uint = 2 << 16; // convert FIXED(16.16) to float, swfparser's bug although it was fixed in another branch.
				
				//
				//  x' = x * ScaleX      + y * RotateSkew1 + tx
				//  y' = x * RotateSkew0 + y * ScaleY      + ty
				//  x' = ax + cy + tx
				//  y' = bx + dy + ty
				//
				if (gradientMatrix["HasScale"]) {
					sx = gradientMatrix["ScaleX"] / scaler;
					sy = gradientMatrix["ScaleY"] / scaler;
				}
				if (gradientMatrix["HasRotate"]) {
					r0 = gradientMatrix["RotateSkew0"] / scaler; // b
					r1 = gradientMatrix["RotateSkew1"] / scaler; // c
				}
				
				tx = gradientMatrix["TranslateX"] / 20;// / 20;
				ty = gradientMatrix["TranslateY"] / 20;// / 20;
				
				matrix = new Matrix(sx, r0 , r1, sy, tx, ty);
				                  // a,   b,  c,  d, tx, ty
								  // c = RotateSkew1
								  // b = RotateSkew0
			}
				
			// Gradient
			var gradient:Object = fillstyle["Gradient"];
				
			if (fillstyle["FillStyleType"] == 0x13) {
				focalPointRatio = gradient["FocalPoint"];
			}
				
				
			var sp:Point, ep:Point;
				
			if (type == GradientType.LINEAR) {
				sp = new Point( ( -16384 / 20), 0),
				ep = new Point( (16384 / 20), 0);
				
				sp = matrix.transformPoint(sp);
				ep = matrix.transformPoint(ep);
				canvasStr = "gradient = ctx.createLinearGradient(" + sp.x + "," + sp.y + "," + ep.x + "," + ep.y +");\n";
			} else {
				sp = new Point(0, 0), // the center point
				ep = new Point( (16384 / 20), 0);
				
				sp = matrix.transformPoint(sp);
				ep = matrix.transformPoint(ep); // (ep.x - sp.x) = r (r of the circle)
				
				// FIXME, need FocalPoint support
				// without focal
				canvasStr = "gradient = ctx.createRadialGradient(" + sp.x + "," + sp.y + "," + "0" + "," + sp.x + "," + sp.y + "," + (ep.x - sp.x) + ");\n";
			}
				
				
				
			// SpreadMode
			switch (gradient["SpreadMode"]) {
				case 0:
					spreadMethod = SpreadMethod.PAD;
				break;
				case 1:
					spreadMethod = SpreadMethod.REFLECT;
				break;
				case 2:
					spreadMethod = SpreadMethod.REPEAT;
				break;
				case 3: // Reserved
				default:
					trace("reserved SpreadMode");
				break;
			}
				
			// InterpolationMode
			switch (gradient["InterpolationMode"]) {
				case 0:
					interpolationMethod = InterpolationMethod.RGB;
				break;
				case 1:
					interpolationMethod = InterpolationMethod.LINEAR_RGB;
				break;
				case 2:
				case 3:
				default:
					trace ("reserved InterpolationMode");
				break;
			}
				
			// GradientRecords
			var gradientRecords:Array = gradient["GradientRecords"];				
				
			for (var i:uint = 0; i < gradientRecords.length; i++) {
				ratios[i] = gradientRecords[i]["Ratio"];
				
				colorInfo.string2Color(gradientRecords[i]["Color"]);
				if (colorInfo.hasAlpha) {
					alphas[i] = colorInfo.Alpha;
				} else {
					alphas[i] = 1.0;
				}
				
				colors[i] = colorInfo.Color;
				canvasStr += "gradient.addColorStop(" + ratios[i] / 255 + ",\"" + colorInfo.getRGBA() + "\");\n";
			}
			
			return { type: type, 
			         colors:colors, 
					 alphas:alphas, 
					 ratios:ratios, 
					 matrix:matrix, 
					 spreadMethod:spreadMethod, 
					 interpolationMethod:interpolationMethod,
					 focalPointRatio:focalPointRatio,
					 canvasStr:canvasStr
					 };
		}
	}

}