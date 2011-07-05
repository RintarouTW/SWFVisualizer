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
package com.somerandomdude.coordy.nodes.twodee
{
	
	import flash.display.DisplayObject;
	
	final public class EllipseNode extends Node2d implements INode2d
	{
		
		/**
		 * Node used for Ellipse layout
		 * 
		 * @see com.somerandomdude.coordy.layouts.twodee.Ellipse
		 * 
		 * @param link The node's target DisplayObject
		 * @param x Node's x position
		 * @param y Node's y position
		 * @param rotation Node's rotational value
		 * @param jitterX Node's x-jitter value
		 * @param jitterY Node's y-jitter value
		 * 
		 */		
		public function EllipseNode(link:Object=null, x:Number=0, y:Number=0, rotation:Number=0, jitterX:Number=0, jitterY:Number=0)
		{
			super(link, x, y, jitterX, jitterY);
			_rotation=rotation;
		}
		
		/**
		 * Creates an exact copy of node with link and position properties carried over
		 * 
		 * @return Cloned node
		 * 
		 */	
		override public function clone():INode2d { return new EllipseNode(_link, _x, _y, _rotation, _jitterX, _jitterY); }
		
	}
}