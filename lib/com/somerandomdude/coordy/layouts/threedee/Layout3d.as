 /*
The MIT License

Copyright (c) 2009 P.J. Onori (pj@somerandomdude.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

  /**
 *
 *
 * @author      P.J. Onori
 * @version     0.1
 * @description
 * @url 
 */
package com.somerandomdude.coordy.layouts.threedee {
	import com.somerandomdude.coordy.constants.LayoutUpdateMethod;
	import com.somerandomdude.coordy.events.CoordyNodeEvent;
	import com.somerandomdude.coordy.layouts.Layout;
	import com.somerandomdude.coordy.nodes.INode;
	import com.somerandomdude.coordy.nodes.threedee.INode3d;
	import com.somerandomdude.coordy.proxyupdaters.IProxyUpdater;

	public class Layout3d extends Layout implements ILayout3d
	{
		protected var _x:Number;
		protected var _y:Number;
		protected var _z:Number;
		protected var _width:Number;
		protected var _height:Number;
		protected var _depth:Number;
		protected var _rotation:Number=0;
		protected var _jitterX:Number;
		protected var _jitterY:Number;
		protected var _jitterZ:Number;
		
		protected var _updateMethod:String=LayoutUpdateMethod.UPDATE_AND_RENDER;
		protected var _updateFunction:Function=updateAndRender;
		
		protected var _proxyUpdater:IProxyUpdater;
		
		/**
		 * Sets a proxy update method for altering layouts as opposed to internal update methods
		 * such as update(), render() or updateAndRender()
		 * 
		 * This allows more customization for the updating sequence.
		 * 
		 * @see com.somerandomdude.coordy.proxyupdaters.IProxyUpdater
		 * @see #updateMethod
		 * 
		 */
		public function get proxyUpdater():IProxyUpdater { return _proxyUpdater; }
		public function set proxyUpdater(value:IProxyUpdater):void
		{
			this._updateMethod=value.name;
			this._updateFunction=value.update;
		}
		
		/**
		 * Specifies whether layout properties (x, y, width, height, etc.) adjust the layout 
		 * automatically without calling apply() method.
		 * 
		 * An alternative method for updating layouts is to define a proxy updater using 
		 * the proxyUpdater property 
		 * 
		 * @see com.somerandomdude.coordy.layouts.LayoutUpdateMethod
		 * @see #proxyUpdater
		 * 
		 * @return  Current setting of auto-adjust (defaults to false)   
		 */
		public function get updateMethod():String { return this._updateMethod; }
		public function set updateMethod(value:String):void 
		{ 
			this._updateMethod = value; 
			switch(value)
			{
				case LayoutUpdateMethod.NONE:
					this._updateFunction=function():void {};
					break;
				case LayoutUpdateMethod.UPDATE_ONLY:
					this._updateFunction=update;
					break;
				default :
					this._updateFunction=updateAndRender;
			}
		}
		
		/**
		 * Accessor for rotation property
		 * 
		 * @return Global rotation position of layout
		 * 
		 */		
		public function get rotation():Number { return this._rotation; }
		public function set rotation(value:Number):void
		{
			this._rotation=value;
			this._updateFunction();
		}
		
		/**
		 * Mutator/accessor for layout x property
		 *
		 * @return	X position of layout organizer   
		 */
		public function get x():Number { return this._x; }	
		public function set x(value:Number):void
		{
			this._x=value;
			this._updateFunction();
		}
		
		/**
		 * Mutator/accessor for layout y property
		 *
		 * @return	Y position of layout organizer   
		 */
		public function get y():Number { return this._y; }
		public function set y(value:Number):void
		{
			this._y=value;
			this._updateFunction();
		}
		
		/**
		 * Mutator/accessor for layout z property
		 *
		 * @return	Z position of layout organizer   
		 */
		public function get z():Number { return this._z; }
		public function set z(value:Number):void
		{
			this._z=value;
			this._updateFunction();
		}
		
		/**
		 * Mutator/accessor for layout width property
		 *
		 * @return	Width of layout organizer   
		 */
		public function get width():Number { return this._width; }
		public function set width(value:Number):void
		{
			this._width=value;
			this._updateFunction();
		}
		
		/**
		 * Mutator/accessor for layout height property
		 *
		 * @return	Height of layout organizer   
		 */
		public function get height():Number { return this._height; }
		public function set height(value:Number):void
		{
			this._height=value;
			this._updateFunction();
		}		
		
		/**
		 * Mutator/accessor for layout depth property
		 *
		 * @return	Depth of layout organizer   
		 */
		public function get depth():Number { return this._depth; }
		public function set depth(value:Number):void
		{
			this._depth=value;
			this._updateFunction();
		}
		
		/**
		 * Mutator/accessor for the jitterX property. This value then mulitplied by each node's 
		 * corresponding jitterX multiplier value to get its jitter offset.
		 * 
		 * @return Global x-axis jitter base value 
		 * 
		 */		
		public function get jitterX():Number { return this._jitterX; }
		public function set jitterX(value:Number):void
		{
			this._jitterX=value;
			this._updateFunction();
		}
		
		/**
		 * Mutator/accessor for the jitterY property. This value then mulitplied by each node's 
		 * corresponding jitterY multiplier value to get its jitter offset.
		 *  
		 * @return Global y-axis jitter base value 
		 * 
		 */		
		public function get jitterY():Number { return this._jitterY; }	
		public function set jitterY(value:Number):void
		{
			this._jitterY=value;
			this._updateFunction();
		}
		
		/**
		 * Mutator/accessor for the jitterZ property. This value then mulitplied by each node's 
		 * corresponding jitterZ multiplier value to get its jitter offset.
		 *  
		 * @return Global z-axis jitter base value  
		 * 
		 */		
		public function get jitterZ():Number { return this._jitterZ; }	
		public function set jitterZ(value:Number):void
		{
			this._jitterZ=value;
			this._updateFunction();
		}
		
		/**
		 * Core class for all 3D layouts. Cannot be instantiated as is - use child classes.
		 * 
		 */		
		public function Layout3d() {}
		
		/**
		 * Adds object to layout in next available position. <strong>Note</strong> - This method is to be 
		 * overridden by child classes for implmentation.
		 *
		 * @param  object  Object to add to layout
		 * @param  moveToCoordinates  automatically move DisplayObject to corresponding node's coordinates
		 * 
		 * @return newly created node object containing a link to the object
		 */		
		override public function addToLayout(object:Object,  moveToCoordinates:Boolean=true):INode
		{
			throw(new Error('Method must be overriden by child class'));
			return null;
		}
		
		/**
		 * Removes specified cell and its link from layout organizer and adjusts layout appropriately
		 *
		 * @param  cell  cell object to remove
		 */
		override public function removeNode(node:INode):void
		{
			super.removeNode(node);
			this._updateFunction();
			dispatchEvent(new CoordyNodeEvent(CoordyNodeEvent.REMOVE, node));
		}
		
		/**
		* Clones the current object's properties (does not include links to DisplayObjects)
		* 
		* @return Wave3d clone of object
		*/
		public function clone():ILayout3d
		{
			throw(new Error('Method must be overriden by child class'));
			return null;
		}
		
		/**
		 * Performs the update method defined by the <em>updateMethod</em> property. Is helpful for 
		 * for behaviors and proxy updaters to work within the defined functiality set at runtime.
		 * 
		 * @see com.somerandomdude.coordy.layouts.LayoutUpdateMethod
		 * @see #updateMethod
		 * 
		 */
		public function executeUpdateMethod():void
		{
			_updateFunction();
		}
		
		/**
		 * Performs an update on all the nodes' positions and renders each node's corresponding link
		 * 
		 */		
		public function updateAndRender():void
		{
			this.update();
			this.render();
		}
		
		/**
		 * Updates the nodes' virtual coordinates. <strong>Note</strong> - this method does not update
		 * the actual objects linked to the layout.
		 * 
		 */		
		public function update():void 
		{
			throw(new Error('Method must be overriden by child class'));
		}
		
		/**
		 * Renders all layout property values to all objects in the collection
		 *
		 */
		public function render():void
		{
			var n:INode3d;
			for(var i:int=0; i<_size; i++)
			{
				n = this._nodes[i];
				if(!n.link) continue;
				n.link.x=n.x, n.link.y=n.y, n.link.z=n.z;
			}
			
		}
		
		/**
		 * Renders all layout property values of a specified node
		 * @param node
		 * 
		 */		
		public function renderNode(node:INode3d):void
		{
			node.link.x=node.x, node.link.y=node.y, node.link.z=node.z;
		}
		
		/**
		 * Determines if an object added to the layout contains the properties/methods 
		 * required from the layout.
		 *
		 * @see #addToLayout()
		 */
		protected function validateObject(object:Object):Boolean
		{
			if(	object.hasOwnProperty('x')&&
				object.hasOwnProperty('y')&&
				object.hasOwnProperty('z')&&
				object.hasOwnProperty('rotationX')&&
				object.hasOwnProperty('rotationY')&&
				object.hasOwnProperty('rotationZ')
			) return true;
			
			return false;
		}

	}
}