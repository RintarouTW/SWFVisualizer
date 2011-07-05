package ui
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.*;
	import flash.system.*;
	import flash.utils.*;
	
	/**
	 * InfoBox is a pure information bar to show the current status for users.
	 */
	public class InfoBox extends Sprite
	{
		private var _backgroundColor:uint;
		private var _borderColor:uint;
		private var _defaultTextHeight:uint;
		
		private var fpsMeter:TextField, numObjectText:TextField, memoryUsage:TextField, numConnections:TextField, numTagsText:TextField;
		private var zoomText:TextField, positionText:TextField;
		private var useGPU:TextField;
		private var textFormat:TextFormat;
		
		// used by onEnterFrame handler
		private var frames:int = 0;
		private var prevTimer:Number = 0;
		private var curTimer:Number = 0;
		private var shadowFilter:DropShadowFilter = new DropShadowFilter();
		
		
		public function InfoBox() 
		{
			// load default settings
			var _config:Object = Global.config.infobox;
			
			_backgroundColor = _config.backgroundColor;
			_borderColor = _config.borderColor;
			_defaultTextHeight = _config.defaultTextHeight;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function createLabel(left:int, top:int, txt:String):TextField {
			var label:TextField = new TextField();
			label.text = txt;
			label.x = left;
			label.y = top;
			label.textColor = 0xffffff;
			label.autoSize = TextFieldAutoSize.LEFT;
			return label;
		}
		
		private function init(event:Event):void {
			draw();
			
			// create labels
			fpsMeter = createLabel(stage.stageWidth - 50, 0, "FPS : 0");			
			addChild(fpsMeter);
			
			memoryUsage = createLabel(fpsMeter.x - 150, 0, "Memory : 0");			
			addChild(memoryUsage);

			useGPU = createLabel(memoryUsage.x - 100, 0, "UseGPU : false");
			addChild(useGPU);
			
			numObjectText = createLabel( 0, 0, "Objects : 0");			
			addChild(numObjectText);			
			
			numConnections = createLabel( 100, 0, "Connections : 0");
			addChild(numConnections);

			numTagsText = createLabel(220, 0, "Tags : 0");
			addChild(numTagsText);
			
			zoomText = createLabel(300, 0, "Zoom : 60%");
			addChild(zoomText);
			
			positionText = createLabel(400, 0, "Position : ( 0 , 0 )");
			addChild(positionText);
			
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			filters = [shadowFilter];
			alpha = 0.6;
		}

		///// onEnterFrame Handler //////////////
		// Update FPS and Memory usage by myself.
		//
		private function onEnterFrame(e:Event):void {
			frames++;
			curTimer = getTimer();
			if(curTimer - prevTimer >= 1000){
				memoryUsage.text = "Memory : " + (System.totalMemory >> 10) + " KB";
				fpsMeter.text = "FPS:" + Math.round(frames * 1000 / (curTimer - prevTimer));
				useGPU.text = "UseGPU : " + stage.wmodeGPU;
				prevTimer = curTimer;
				frames = 0;
			}
		}
		
		///// Update APIs exported /////
		/**
		 * Update the number of objects.
		 * @param	num number of objects.
		 */
		public function updateNumOfObject(num:int):void {
			numObjectText.text = "Objects : " + num;
		}
		/**
		 * Update the number of links.
		 * @param	num number of links.
		 */
		public function updateNumOfConnection(num:int):void {
			numConnections.text = "Connections : " + num;			
		}
		
		/**
		 * Update the number of tags.
		 * @param	num number of tags.
		 */
		public function updateNumOfTag(num:int):void {
			numTagsText.text = "Tags : " + num;
		}
		
		/**
		 * Update the zoom ratio.
		 * @param	num ratio of zooming scale.
		 */
		public function updateZoomText(num:Number):void {			
			zoomText.text = "Zoom : " + (num * 100).toPrecision(4) + "%";
		}
		
		/**
		 * Update the position of the content.
		 * @param	x left of the content.
		 * @param	y top of the content.
		 */
		public function updatePositionText(x:int, y:int):void {
			positionText.text = "Position : ( " + x +" , " + y + " )";			
		}
		
		
		
		/// Background Drawing ///
		private function draw():void {
			graphics.beginFill(_backgroundColor);
			graphics.drawRect(1, 1, stage.stageWidth - 1, _defaultTextHeight - 1);
			graphics.endFill();
			graphics.lineStyle(1, _borderColor);
			graphics.drawRect(0, 0, stage.stageWidth, _defaultTextHeight);
			graphics.endFill();
		}
	}

}