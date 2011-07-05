﻿package swf{	import flash.display.*;	import flash.geom.*;		/**	 * VShapeWithStyle will draw the SHAPEWITHSTYLE object.	 */	public class VShapeWithStyle extends Shape {				private const _JSON_OBJECT_TYPE_INFO_:String = "__TYPE_INFO__";	// used by swfparser so far, as the name of the json object.				private var ShapeWithStyle:Object;		private var FillStyleArray:Object;		private var LineStyleArray:Object;				private var fillStyles:Array;		private var lineStyles:Array;		private var shapeRecords:Array;				private var penX:Number = 0, penY:Number = 0;		private var fillstyle0:uint = 0, fillstyle1:uint = 0, linestyle:uint = 0;		private var f0edgeList:Array = new Array(), f1edgeList:Array = new Array(); // array edges before fill style change		private var lineEdgeList:Array = new Array();				private var colorInfo:ColorInfo;				private var canvasStr:String = "";						/**		 * @param	shapewithstyle SHAPEWITHSTYLE object		 */		function VShapeWithStyle(shapewithstyle:Object) {			colorInfo = new ColorInfo();						// attach the SHAPEWITHSTYLE object			ShapeWithStyle = shapewithstyle;										FillStyleArray = ShapeWithStyle.FillStyles;			LineStyleArray = ShapeWithStyle.LineStyles;								// real referenced drawing data			if (FillStyleArray["FillStyles"]) {				fillStyles = FillStyleArray["FillStyles"];			}						if (LineStyleArray["LineStyles"]) {				lineStyles = LineStyleArray["LineStyles"];			}						shapeRecords = ShapeWithStyle["Shape"]["ShapeRecords"];						readRecords();		}				/**		 * Get the generated Canvas code.		 * @return generated canvas code string.		 */		public function getCanvasStr():String {			/* translate to the quadrant */			var translate_code:String = "ctx.translate(" + -getBounds(this).x + "," + -getBounds(this).y + ");\n";			return translate_code + canvasStr;		}				private function readRecords():void {			for (var i:uint = 0; i < shapeRecords.length; i++) {				if (shapeRecords[i][_JSON_OBJECT_TYPE_INFO_] == "STYLECHANGERECORD") {					readStyleChangedRecord(shapeRecords[i]);				}				if (shapeRecords[i][_JSON_OBJECT_TYPE_INFO_] == "STRAIGHTEDGERECORD") {					readStraightEdgeRecord(shapeRecords[i]);				}				if (shapeRecords[i][_JSON_OBJECT_TYPE_INFO_] == "CURVEDEDGERECORD") {					readCurvedEdgeRecord(shapeRecords[i]);				}			}			genFillPath(true);			genFillPath(false);			genLinePath();			//drawPathsOfFillStyles();			drawClosedPathsOfFillStyles();			drawPathsOfLineStyles();		}				private function genLinePath():void {						var path:VPath;						if (linestyle > 0) {				// generate lineEdgeList to VPath				if (lineEdgeList.length > 0) {					if (!lineStyles[linestyle - 1]._paths) {						lineStyles[linestyle - 1]._paths = new Array();					}										path = new VPath(lineEdgeList, true);					lineStyles[linestyle - 1]._paths.push(path);					lineEdgeList = new Array();				}			}					}				private function genFillPath(fs1:Boolean):void {						var path:VPath;						if (!fs1) {				if (fillstyle0 > 0) {					// push the f0edgeList to VPath					if (f0edgeList.length > 0) {						if (!fillStyles[fillstyle0 - 1]._paths) {							fillStyles[fillstyle0 - 1]._paths = new Array();						}						//trace("f0 edge num = ", f0edgeList.length, " , f0 = ", fillstyle0);						path = new VPath(f0edgeList, false); // transform the left fill edges to VPath												fillStyles[fillstyle0 - 1]._paths.push(path);						f0edgeList = new Array();					}				}							} else {				if (fillstyle1 > 0) {					// push the f1edgeList to VPath					if (f1edgeList.length > 0) {						if (!fillStyles[fillstyle1 - 1]._paths) {							fillStyles[fillstyle1 - 1]._paths = new Array();						}						path = new VPath(f1edgeList, true); // transform the right fill edges to VPath						fillStyles[fillstyle1 - 1]._paths.push(path);						f1edgeList = new Array();					}				}							}		}				private function readStyleChangedRecord(styleChangedRecord:Object):void {						if (styleChangedRecord["MoveDeltaX"] != null) {				genFillPath(true);				genFillPath(false);				genLinePath();				penX = styleChangedRecord["MoveDeltaX"];	// spec description is wrong				penY = styleChangedRecord["MoveDeltaY"];    // it should be renamed to "MoveToX" and "MoveToY"			}						if (styleChangedRecord["StateLineStyle"]) { 	// 0 : path is not stroked				genLinePath();				linestyle = styleChangedRecord["LineStyle"];			}									// shapes that don't self-intersect or overlap, FillStyle0 should be used.			if (styleChangedRecord["StateFillStyle0"]) { 	// 0 : path is not filled				genFillPath(false);				fillstyle0 = styleChangedRecord["FillStyle0"];			}						if (styleChangedRecord["StateFillStyle1"]) { 	// 0 : path is not filled				genFillPath(true);				fillstyle1 = styleChangedRecord["FillStyle1"];			}						if (styleChangedRecord["StateNewStyles"]) {				// draw the paths of each fill style				genFillPath(true);				genFillPath(false);				genLinePath();				//drawPathsOfFillStyles();				drawClosedPathsOfFillStyles();				drawPathsOfLineStyles();				FillStyleArray = styleChangedRecord["FillStyles"]; // FILLSTYLEARRAY Object				fillStyles = FillStyleArray["FillStyles"]; // Real fillStyles array											LineStyleArray = styleChangedRecord["LineStyles"]; // LINESTYLEARRAY Object				lineStyles = LineStyleArray["LineStyles"]; // Real lineStyles array			}		}				private function readStraightEdgeRecord(straightEdgeRecord:Object):void {			var curPenX:Number = penX, curPenY:Number = penY;						if (straightEdgeRecord["DeltaX"]) {				penX += straightEdgeRecord["DeltaX"];			}			if (straightEdgeRecord["DeltaY"]) {				penY += straightEdgeRecord["DeltaY"];			}						var edge : VEdge = new VEdge();			edge.asLine(curPenX, curPenY, penX, penY);						if (fillstyle0)				f0edgeList.push(edge);			if (fillstyle1)				f1edgeList.push(edge);			if (linestyle)				lineEdgeList.push(edge);		}				private function readCurvedEdgeRecord(curvedEdgeRecord:Object):void {			var cpX:Number, cpY:Number, anchorX:Number, anchorY:Number;						cpX = penX + curvedEdgeRecord["ControlDeltaX"];			cpY = penY + curvedEdgeRecord["ControlDeltaY"];						anchorX = cpX + curvedEdgeRecord["AnchorDeltaX"];			anchorY = cpY + curvedEdgeRecord["AnchorDeltaY"];						var edge : VEdge = new VEdge();			edge.asCurve(penX, penY, cpX, cpY, anchorX, anchorY);			if (fillstyle0)				f0edgeList.push(edge);			if (fillstyle1)				f1edgeList.push(edge);						if (linestyle)				lineEdgeList.push(edge);						penX = anchorX;			penY = anchorY;					}								private function drawPathsOfFillStyles():void {			if(fillStyles) {				for (var i:uint = 0; i < fillStyles.length; i++) {											var pathList:Array = fillStyles[i]._paths; // array of VPath										if (pathList && (pathList.length > 0)) {						canvasStr += "ctx.beginPath();\n";						canvasStr += VStyleUtil.beginFill(fillStyles[i], graphics) + "\n";												for (var j:uint = 0; j < pathList.length; j++) {							if ((pathList[j] as VPath).isRightFill) {								canvasStr += "/* Right Fill VPath[" + j + "] */\n";							} else {								canvasStr += "/* Left Fill VPath[" + j + "] */\n";							}							canvasStr += (pathList[j] as VPath).draw(graphics);						}												canvasStr += "ctx.fill();\n";					}										graphics.endFill();					delete fillStyles[i]._paths; // remove it from the original json data					fillStyles[i]._paths = null;				}			}		}				private function getConnectedPath(endP:Point, pathList:Array):VPath {			for (var j:uint = 0; j < pathList.length; j++) {				var path:VPath = pathList[j];				if (path.startPoint.equals(endP)) {					var resultArray:Array = pathList.splice(j, 1);					return resultArray[0];				}			}			return null;		}				private function drawClosedPathsOfFillStyles():void {			if (fillStyles) {				for (var i:uint = 0; i < fillStyles.length; i++) {										var pathList:Array = fillStyles[i]._paths; // array of VPath										if (pathList && (pathList.length > 0)) {						canvasStr += "ctx.beginPath();\n";						canvasStr += VStyleUtil.beginFill(fillStyles[i], graphics);												while(pathList.length) {							var currPath:VPath = pathList.shift();							var startP:Point = currPath.startPoint;							graphics.moveTo(startP.x, startP.y);														canvasStr += "ctx.moveTo(" + startP.x + ", " + startP.y + ");\n";							canvasStr += currPath.draw2(graphics);														while (!startP.equals(currPath.endPoint)) {								currPath = getConnectedPath(currPath.endPoint, pathList);								if (currPath) {									canvasStr += currPath.draw2(graphics);								} else {									trace("not closed path");									break; // not found... something wrong?								}							}						}												canvasStr += "ctx.fill();\n";					}										graphics.endFill();					delete fillStyles[i]._paths; // remove it from the original json data					fillStyles[i]._paths = null;				}			}		}				private function drawPathsOfLineStyles():void {			if(lineStyles) {				for (var i:uint = 0; i < lineStyles.length; i++) {										var pathList:Array = lineStyles[i]._paths; // array of VPath										if (pathList && (pathList.length > 0)) {						canvasStr += "ctx.beginPath();\n";						canvasStr += VStyleUtil.lineStyle(lineStyles[i], graphics);												for (var j:uint = 0; j < pathList.length; j++) {														canvasStr += (pathList[j] as VPath).draw(graphics);						}												canvasStr += "ctx.stroke();\n";					}					delete lineStyles[i]._paths; // remove it from the original json data					lineStyles[i]._paths = null;				}								// reset the linestyle. or it will effect to the following fill drawing. (Bug fixed - 2011/01/27)				graphics.lineStyle(undefined);			}		}			}}