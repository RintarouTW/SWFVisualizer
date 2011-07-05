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
	import com.somerandomdude.coordy.constants.PathAlignType;
	import com.somerandomdude.coordy.constants.WaveFunction;
	import com.somerandomdude.coordy.events.CoordyNodeEvent;
	import com.somerandomdude.coordy.nodes.INode;
	import com.somerandomdude.coordy.nodes.threedee.INode3d;
	import com.somerandomdude.coordy.nodes.threedee.Node3d;

	public class Wave3d extends Layout3d implements ILayout3d
	{
		private var _frequency:Number;
		private var _waveFunctionY:String;
		private var _waveFunctionZ:String;
		private var _functionY:Function=Math.sin;
		private var _functionZ:Function=Math.cos;
		
		private var _heightMultiplier:Number=0;
		private var _depthMultiplier:Number=0;
		
		private static const PI:Number = Math.PI;
		private static const PI_180:Number = PI/180;
		
		private var _alignType:String;
		private var _alignAngleOffset:Number;
		
		/**
		 * The additional angle offset of each node from it's original path-aligned angle (in degrees)
		 * @return Angle in degrees
		 * 
		 */		
		public function get alignAngleOffset():Number { return this._alignAngleOffset; }
		public function set alignAngleOffset(value:Number):void
		{
			this._alignAngleOffset=value;
			this._updateFunction();
		}
		
		/**
		 * The type of path alignment each node executes (parallel or perpendicular)
		 * 
		 * @see com.somerandomdude.coordy.layouts.PathAlignType
		 * 
		 * @return String value of the path alignment type
		 * 
		 */	
		public function get alignType():String { return this._alignType; }
		public function set alignType(value:String):void
		{
			this._alignType=value;
			this._updateFunction();
		}

		/**
		 * Mutator/accessor for waveFunctionY property
		 *
		 * @return	Wave function for the Y-axis   
		 */
		public function get waveFunctionY():String { return _waveFunctionY; }
		public function set waveFunctionY(value:String):void
		{
			switch(value)
			{
				case WaveFunction.SINE:
					_waveFunctionY=value;
					_functionY=Math.sin;
					break;
				case WaveFunction.COSINE:
					_waveFunctionY=value;
					_functionY=Math.cos;
					break;
				case WaveFunction.TAN:
					_waveFunctionY=value;
					_functionY=Math.tan;
					break;
				case WaveFunction.ARCSINE:
					_waveFunctionY=value;
					_functionY=Math.asin;
					break;
				case WaveFunction.ARCCOSINE:
					_waveFunctionY=value;
					_functionY=Math.acos;
					break;
				case WaveFunction.ARCTAN:
					_waveFunctionY=value;
					_functionY=Math.atan;
					break;
				default:
					_waveFunctionY=WaveFunction.SINE;
					_functionY=Math.sin;
			}
			this._updateFunction();
		}
		
		/**
		 * Mutator/accessor for waveFunctionZ property
		 *
		 * @return	Wave function for the Z-axis    
		 */
		public function get waveFunctionZ():String { return _waveFunctionZ; }
		public function set waveFunctionZ(value:String):void
		{
			switch(value)
			{
				case WaveFunction.SINE:
					_waveFunctionZ=value;
					_functionZ=Math.sin;
					break;
				case WaveFunction.COSINE:
					_waveFunctionZ=value;
					_functionZ=Math.cos;
					break;
				case WaveFunction.TAN:
					_waveFunctionZ=value;
					_functionZ=Math.tan;
					break;
				case WaveFunction.ARCSINE:
					_waveFunctionZ=value;
					_functionZ=Math.asin;
					break;
				case WaveFunction.ARCCOSINE:
					_waveFunctionZ=value;
					_functionZ=Math.acos;
					break;
				case WaveFunction.ARCTAN:
					_waveFunctionZ=value;
					_functionZ=Math.atan;
					break;
				default:
					_waveFunctionZ=WaveFunction.SINE;
					_functionZ=Math.sin;
			}
			this._updateFunction();
		}

		/**
		 * Accessor for frequency property
		 *
		 * @return	Frequency of wave   
		 */
		public function get frequency():Number { return _frequency; }
		public function set frequency(value:Number):void
		{
			this._frequency=value;
			this._updateFunction();
		}
		
		/**
		 * Accessor for heightMultiplier property
		 *
		 * @return	HeightMultipler of wave   
		 */
		public function get heightMultiplier():Number { return _heightMultiplier; }
		public function set heightMultiplier(value:Number):void
		{
			this._heightMultiplier=value;
			this._updateFunction();
		}
		
		/**
		 * Accessor for depthMultiplier property
		 *
		 * @return	DepthMultipler of wave   
		 */
		public function get depthMultiplier():Number { return _depthMultiplier; }
		public function set depthMultiplier(value:Number):void
		{
			this._depthMultiplier=value;
			this._updateFunction();
		}
		
		/**
		 * Distributes nodes in a 3d wave.
		 * 
		 * @param width				Width of the wave
		 * @param height			Height of the wave
		 * @param depth				Depth of the wave
		 * @param x					x position of the wave
		 * @param y					y position of the wave
		 * @param z					z position of the wave
		 * @param frequency			Frequency of the wave
		 * @param waveFunctionY		Wave function (sin,cos,tan,etc.) applied along the y-axis
		 * @param waveFunctionZ		Wave function (sin,cos,tan,etc.) applied along the z-axis
		 * @param jitterX			Jitter multiplier for the layout's nodes on the x axis
		 * @param jitterY			Jitter multiplier for the layout's nodes on the y axis
		 * @param jitterZ			Jitter multiplier for the layout's nodes on the z axis
		 * 
		 */		
		public function Wave3d(width:Number, 
							height:Number, 
							depth:Number, 
							x:Number=0, 
							y:Number=0, 
							z:Number=0, 
							frequency:Number=1, 
							waveFunctionY:String=WaveFunction.SINE,  
							waveFunctionZ:String=WaveFunction.COSINE,
							jitterX:Number=0, 
							jitterY:Number=0, 
							jitterZ:Number=0,
							alignType:String=PathAlignType.ALIGN_PERPENDICULAR, 
							alignOffset:Number=0):void
		{

			this._width=width;
			this._height=height;
			this._depth=depth;
			this._x=x;
			this._y=y;
			this._z=z;
			this._jitterX=jitterX;
			this._jitterY=jitterY;
			this._jitterZ=jitterZ;
			this._frequency=frequency;
			this.waveFunctionY=waveFunctionY;
			this.waveFunctionZ=waveFunctionZ;
			this._alignType=alignType;
			this.alignAngleOffset=alignOffset;
		}
		
		/**
		 * Returns the type of layout in a string format
		 * 
		 * @see com.somerandomdude.coordy.layouts.LayoutType
		 * @return Layout's type
		 * 
		 */
		override public function toString():String { return LayoutType.WAVE_3D; }
		
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
			var node:Node3d = new Node3d(object,0,0,0,((Math.random()>.5)?-1:1)*Math.random(),((Math.random()>.5)?-1:1)*Math.random(),((Math.random()>.5)?-1:1)*Math.random());
			this.storeNode(node as INode3d);
			this.update();
			
			if(object&&moveToCoordinates) this.render();
			
			dispatchEvent(new CoordyNodeEvent(CoordyNodeEvent.ADD, node));
			
			return node;
		}
		
		
		/**
		 * Adds object to layout in next available position <strong>This method is depreceated.</strong>
		 *
		 * @param  object  Object to add to layout
		 * @param  moveToCoordinates  automatically move DisplayObject to corresponding node's coordinates
		 * 
		 * @return newly created node object containing a link to the object
		 */
		override public function addToLayout(object:Object,  moveToCoordinates:Boolean=true):INode
		{
			if(!validateObject(object)) throw new Error('Object does not implement at least one of the following properties: "x", "y", "z", "rotationX", "rotationY", "rotationZ"');
			if(linkExists(object)) return null;
			
			var node:Node3d = new Node3d(object,0,0,0,((Math.random()>.5)?-1:1)*Math.random(),((Math.random()>.5)?-1:1)*Math.random(),((Math.random()>.5)?-1:1)*Math.random());
			this.storeNode(node as INode3d);
			this.update();
			
			if(moveToCoordinates) this.render();
			
			dispatchEvent(new CoordyNodeEvent(CoordyNodeEvent.ADD, node));
			
			return node;
		}
		
		/**
		* Clones the current object's properties (does not include links to DisplayObjects)
		* 
		* @return Wave3d clone of object
		*/
		override public function clone():ILayout3d
		{
			return new Wave3d(_width, _height, _depth, _x, _y, _z, _frequency, _waveFunctionY, _waveFunctionZ, _jitterX, _jitterY, _jitterZ);
		}
		
		/**
		 * Updates the nodes' virtual coordinates. <strong>Note</strong> - this method does not update
		 * the actual objects linked to the layout.
		 * 
		 */	
		override public function update():void
		{
			var c:Node3d;
			var r:Number = this._rotation*PI_180;
			
			for(var i:int=0; i<this._size; i++)
			{
				c = this._nodes[i];
				c.x = (i*(this._width/this._size))+_x+(c.jitterX*this._jitterX);
				c.y = ((_functionY((Math.PI*(i+1)/(this._size/2)+r)*_frequency)*((this._height+(_heightMultiplier*i))/2)))+_y+(c.jitterY*this._jitterY);
				
				//in future, add option to align wave to center or top by adding height/2 to all nodes' y property
				
				c.z = ((_functionZ((Math.PI*(i+1)/(this._size/2)+r)*_frequency)*((this._depth+(_depthMultiplier*i))/2)))+_z+(c.jitterZ*this._jitterZ);
				
				if(_functionY==Math.sin) c.rotationZ = Math.cos(PI*(i+1)/(_size/2)*_frequency)*180/PI;
				else if(_functionY==Math.cos) c.rotationZ = Math.sin(PI*(i+1)/(_size/2)*_frequency)*180/PI;
				else c.rotationZ = 0;
				
				if(this._alignType==PathAlignType.ALIGN_PERPENDICULAR) c.rotationZ+=90; 
				c.rotationZ+=this._alignAngleOffset;
			}
		}
		
		/**
		 * Applies all layout property values to all cells/display objects in the collection
		 *
		 */
		override public function render():void
		{
			var c:Node3d;
			for(var i:int=0; i<this._size; i++)
			{
				c=this._nodes[i];
				if(!c.link) continue;
				c.link.x=c.x;
				c.link.y=c.y;
				c.link.z=c.z;
				
				if(this._alignType==PathAlignType.NONE) continue;
				
				c.link.rotationZ=c.rotationZ;
			}
		}

	}
}