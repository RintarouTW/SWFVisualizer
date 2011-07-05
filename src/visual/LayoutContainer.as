﻿package visual{	import flash.display.*;	import flash.events.Event;	import flash.filters.DropShadowFilter;	import flash.geom.*;	/**	 * LayoutContainer is the container of Tables. Manage the column position of each table.	 */	public class LayoutContainer extends Sprite {		private var _config:Object = Global.config.layout;		private var myColSpace:uint;		private var myRowSpace:uint;		private var myColumns:Array;// Indexed by column number				function LayoutContainer() {			addEventListener(Event.ADDED_TO_STAGE, init);		}				private function init(e:Event):void {			myColSpace = _config.colSpace;			myRowSpace = _config.rowSpace;			opaqueBackground = parent.opaqueBackground;			myColumns = new Array();		}				/**		 * Add the table into the column.		 * @param	table Table to be added into the container.		 * @param	colNo Number of the column.		 */		public function addTable(table:Table, colNo:uint):void {			table.x = myColSpace * colNo;						if (myColumns[colNo]) {				var oldColArray:Vector.<Table> = myColumns[colNo];				var lastTable:Table = oldColArray.pop();								var lastY:Number = lastTable.y + lastTable.height + myRowSpace;				table.y = lastY;									oldColArray.push(lastTable, table);			} else {				table.y = 30 / scaleY;				var newVec:Vector.<Table> = new Vector.<Table>();				newVec.push(table);				myColumns[colNo] = newVec;			}						// do not add into the layout container, need a rule to addchild into view port instead of add all child at the beginning.			addChild(table);		}				/**		 * Add the path into the container.		 * @param	path ConnPath to be added.		 */		public function addPath(path:ConnPath):void {						if (path) {				if (path is DisplayObject) {					addChildAt(DisplayObject(path), 0);				}				path.setCanvas(this);			}		}	}}