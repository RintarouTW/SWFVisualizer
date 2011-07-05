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
	import com.somerandomdude.coordy.layouts.ILayout;
	import com.somerandomdude.coordy.nodes.threedee.INode3d;
	
	import flash.display.DisplayObject;	

	public interface ILayout3d extends ILayout
	{
		function set x(value:Number):void;
		function get x():Number;
		function set y(value:Number):void;
		function get y():Number;
		function set z(value:Number):void;
		function get z():Number;
		function set width(value:Number):void;
		function get width():Number;
		function set height(value:Number):void;
		function get height():Number;
		function set depth(value:Number):void;
		function get depth():Number;
		function set jitterX(value:Number):void;
		function get jitterX():Number;
		function set jitterY(value:Number):void;
		function get jitterY():Number;
		function set jitterZ(value:Number):void;
		function get jitterZ():Number;
		
		function renderNode(node:INode3d):void;
		
		function clone():ILayout3d
	}
}