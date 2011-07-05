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
	import com.somerandomdude.coordy.constants.LayoutType;
	import com.somerandomdude.coordy.events.CoordyNodeEvent;
	import com.somerandomdude.coordy.nodes.INode;
	import com.somerandomdude.coordy.nodes.threedee.ScatterNode3d;

	public class Scatter3d extends Layout3d implements ILayout3d
	{
		
		private var _jitter:Number;
		private var _jitterRotation:Boolean;
		
		/**
		 * Mutator/accessor for jitter property
		 *
		 * @return	Global jitter value of scatter layout   
		 */
		public function get jitter():Number { return this._jitter; } 
		public function set jitter(value:Number):void
		{
			this._jitter=value;
			this._updateFunction();
		}
		
		/**
		 * Mutator/accessor for property determining whether the layout's nodes' rotation is randomly jittered
		 *
		 * @return Boolean value of jitter rotation state 	  
		 */
		public function get jitterRotation():Boolean { return this._jitterRotation; } 
		public function set jitterRotation(value:Boolean):void
		{
			this._jitterRotation=value;
			this._updateFunction();
		}
		
		/**
		 * Distributes nodes in a scattered fashion in all 3 dimensions.
		 * 
		 * @param width 			Width of the scatter
		 * @param height 			Height of the scatter
		 * @param depth 			Depth of the scatter
		 * @param jitter 			Jitter multiplier of scatter
		 * @param x 				x position of the scatter
		 * @param y 				y position of the scatter
		 * @param z 				z position of the scatter
		 * @param jitterRotation	Boolean determining if nodes are randomly rotated
		 * 
		 */		
		public function Scatter3d(width:Number, 
								height:Number, 
								depth:Number, 
								jitter:Number=1, 
								x:Number=0, 
								y:Number=0, 
								z:Number=0, 
								jitterRotation:Boolean=false):void
		{
			this._width = width;
			this._height = height;
			this._depth=depth;
			this._x = x;
			this._y = y;
			this._z = z;
			this._jitter=jitter;
			this._jitterRotation=jitterRotation;
			this._nodes = new Array();
		}
		
		/**
		 * Returns the type of layout in a string format
		 * 
		 * @see com.somerandomdude.coordy.layouts.LayoutType
		 * @return Layout's type
		 * 
		 */
		override public function toString():String { return LayoutType.SCATTER_3D; }
		
		/**
		 * Adds object to layout in next available position.
		 *
		 * @param  object  Object to add to layout
		 * @param  moveToCoordinates  automatically move DisplayObject to corresponding nodes's coordinates
		 * 
		 * @return newly created node object containing a link to the object
		 */
		override public function addNode(object:Object=null, moveToCoordinates:Boolean=true):INode
		{
			if(object&&!validateObject(object)) throw new Error('Object does not implement at least one of the following properties: "x", "y", "z", "rotationX", "rotationY", "rotationZ"');
			if(object&&linkExists(object)) return null;
			var p:int = (Math.round(Math.random())) ? -1:1;
			var xPos:Number = (((Math.random()*_width*_jitter))*p)+_x;
			p = (Math.round(Math.random())) ? -1:1;
			var yPos:Number = (((Math.random()*_height*_jitter))*p)+_y;
			p = (Math.round(Math.random())) ? -1:1;
			var zPos:Number = (((Math.random()*_depth*_jitter))*p)+_z;
			var node:ScatterNode3d = new ScatterNode3d(object,xPos,yPos,zPos,(_jitterRotation)?(Math.random()*p*360):0, (_jitterRotation)?(Math.random()*p*360):0, (_jitterRotation)?(Math.random()*p*360):0);
			node.xRelation=(node.x-this._width/2)/this._width/2;
			node.yRelation=(node.y-this._height/2)/this._height/2;
			node.zRelation=(node.z-this._depth/2)/this._depth/2;
			
			this.storeNode(node);
			
			if(object&&moveToCoordinates) object.x=node.x,object.y=node.y, object.z=node.z;
			
			dispatchEvent(new CoordyNodeEvent(CoordyNodeEvent.ADD, node));
			
			return node;
		}
			
		/**
		 * Adds object to layout in next available position <strong>This method is depreceated.</strong>
		 *
		 * @param  object  Object to add to organizer
		 * @param  moveToCoordinates  automatically move DisplayObject to corresponding cell's coordinates
		 * 
		 * @return newly created node object containing a link to the object
		 */	
		override public function addToLayout(object:Object, moveToCoordinates:Boolean=true):INode
		{
			if(!validateObject(object)) throw new Error('Object does not implement at least one of the following properties: "x", "y", "z", "rotationX", "rotationY", "rotationZ"');
			if(linkExists(object)) return null;
			var p:int = (Math.round(Math.random())) ? -1:1;
			var xPos:Number = (((Math.random()*_width*_jitter))*p)+_x;
			p = (Math.round(Math.random())) ? -1:1;
			var yPos:Number = (((Math.random()*_height*_jitter))*p)+_y;
			p = (Math.round(Math.random())) ? -1:1;
			var zPos:Number = (((Math.random()*_depth*_jitter))*p)+_z;
			var node:ScatterNode3d = new ScatterNode3d(object,xPos,yPos,zPos,(_jitterRotation)?(Math.random()*p*360):0, (_jitterRotation)?(Math.random()*p*360):0, (_jitterRotation)?(Math.random()*p*360):0);
			node.xRelation=(node.x-this._width/2)/this._width/2;
			node.yRelation=(node.y-this._height/2)/this._height/2;
			node.zRelation=(node.z-this._depth/2)/this._depth/2;
			
			this.storeNode(node);
			
			if(moveToCoordinates) node.link.x=node.x,node.link.y=node.y, node.link.z=node.z;
			
			dispatchEvent(new CoordyNodeEvent(CoordyNodeEvent.ADD, node));
			
			return node;
		}
		
		/**
		 * Applies all layout property values to all cells/display objects in the collection
		 *
		 * @param  tweenFunction  function with a Cell parameter for managing the motion of the cell object
		 */
		override public function render():void
		{
			for(var i:int=0; i<this._size; i++)
			{
				if(!_nodes[i].link) continue;
				this._nodes[i].link.x=this._nodes[i].x;
				this._nodes[i].link.y=this._nodes[i].y;
				this._nodes[i].link.z=this._nodes[i].z;
				this._nodes[i].link.rotationX=this._nodes[i].rotationX;
				this._nodes[i].link.rotationY=this._nodes[i].rotationY;
				this._nodes[i].link.rotationZ=this._nodes[i].rotationZ;
			}
		}
		
		/**
		 * Updates the nodes' virtual coordinates. <strong>Note</strong> - this method does not update
		 * the actual objects linked to the layout.
		 * 
		 */	
		override public function update():void
		{
			for(var i:int=0; i<this._size; i++)
			{
				_nodes[i].x=(_nodes[i].xRelation*this._width)+this._x;
				_nodes[i].y=(_nodes[i].yRelation*this._height)+this._y;
				_nodes[i].z=(_nodes[i].zRelation*this._depth)+this._z;
			}
		}
		
		/**
		 * Re-scatters layout and adjusts cell links appropriately
		 *
		 */
		public function scatter():void
		{
			var p:int;
			var xPos:Number;
			var yPos:Number;
			var zPos:Number;
			for(var i:int=0; i<this._size; i++)
			{
				p = (Math.round(Math.random())) ? -1:1;
				xPos = (((Math.random()*_width*_jitter))*p)+_x;
				p = (Math.round(Math.random())) ? -1:1;
				yPos = (((Math.random()*_height*_jitter))*p)+_y;
				p = (Math.round(Math.random())) ? -1:1;
				zPos = (((Math.random()*_depth*_jitter))*p)+_z;
				
				this._nodes[i].x=xPos;
				this._nodes[i].y=yPos;
				this._nodes[i].z=zPos;
			}
			this._updateFunction();
		}
		
		/**
		* Clones the current object's properties (does not include links to DisplayObjects)
		* 
		* @return ScatterOrganizer clone of object
		*/
		override public function clone():ILayout3d
		{
			return new Scatter3d(_width, _height, _depth, _jitter, _x, _y, _z, _jitterRotation);
		}
		
	}
}