package ui
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import com.greensock.*;
	import fl.transitions.easing.*;
	import flash.filters.*;
	import com.adobe.serialization.json.*;
	
	import event.AlertEvent;
	
	/**
	 * JSONBox is the popup box for user to input the JSON string.
	 */
	public class JSONBox extends Sprite
	{
		// Event
		/**
		 * @eventType ui.JSONBox.LOAD_JSON User like to load JSON string.
		 */
		public static const LOAD_JSON:String = "LOAD_JSON";
		
		// Graphic Resource
		[Embed(source='../graphics/check_16x13.png')]
		private var AcceptPNG:Class;
		
		private var _config:Object = Global.config.jsonbox;
		private var popped:Boolean = false;
		private var inputBox:TextField, title:TextField;
		private var loadBtn:Sprite;
		private var acceptBmp:Bitmap, closeBmp:Bitmap, openBmp:Bitmap;
		
		private var shadowFilter:DropShadowFilter;
		
		public function JSONBox() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			
			title = UIUtil.createLabel(5, 0, _config.title);
			title.textColor = _config.titleColor;
			
			inputBox = UIUtil.createLabel(5, 22, "{\n\"key1\": \"this is an example.\",\n\"key2\": \"enter your JSON here.\"\n }", TextFieldType.INPUT);
			inputBox.width = _config.width - 10;
			inputBox.height = _config.height - 10;
			inputBox.multiline = true;
			inputBox.border = true;
			inputBox.borderColor = 0x666666;
			inputBox.addEventListener(KeyboardEvent.KEY_DOWN, onKeyInput);
			
			//inputBox.text = JSON.encode(Config.setting);
			
			addChild(title);
			addChild(inputBox);
			draw();
			x = stage.stageWidth - width; //_config.left;
			
			acceptBmp   = new AcceptPNG();
			
			loadBtn = new Sprite();
			UIUtil.drawBmp(loadBtn, acceptBmp);
			loadBtn.x = _config.width - loadBtn.width - 5;
			loadBtn.y = 2;
			loadBtn.addEventListener(MouseEvent.CLICK, dispatchLoadJSONEvent);
			addChild(loadBtn);
			
			// shadow
			shadowFilter = new DropShadowFilter(5, -45);
			filters = [shadowFilter];
			
			// popup/off when mouse over
			addEventListener(MouseEvent.MOUSE_OVER, popUpOff);
			addEventListener(MouseEvent.MOUSE_OUT, popUpOff);
			
			// handle resize event
			stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		/**
		 * Return the string in the input box.
		 */
		public function get JSONString():String {
			return inputBox.text;
		}
		
		private function dispatchLoadJSONEvent(e:Event):void {
			popoff();
			dispatchEvent(new Event(LOAD_JSON));
		}

		
		private function triggerSelf(e:Event):void {
			if (!popped)
				popup();
			else
				popoff();
		}
		
		private function draw():void {
			// draw background
			graphics.beginFill(_config.titleBackgroundColor);
			graphics.drawRect(0, -2, _config.width, 21);
			graphics.beginFill(_config.bodyBackgroundColor);			
			graphics.drawRect(0, 19, _config.width, _config.height);
			graphics.endFill();
		}
		
		private function popUpOff(e:MouseEvent):void {
			if (!popped) {
				if (e.type == MouseEvent.MOUSE_OVER) {
					popup();
				}
			}
			
			if (popped) {
				if (e.type == MouseEvent.MOUSE_OUT) {
					popoff();
				}				
			}
		}
		
		/**
		 * Pop off
		 */
		public function popoff():void {			
			loadBtn.visible = false;
			popped = false;
			alpha = 0.7;
			var cornerY:Number = stage.stageHeight - loadBtn.height - 5;
			TweenLite.to(this, 0.4, { y: cornerY, ease:Strong.easeOut } );
		}
		
		/**
		 * Pop up
		 */
		public function popup():void {						
			loadBtn.visible = true;	
			popped = true;
			alpha = 1;
			var centerY:Number = stage.stageHeight - height + 2;
			TweenLite.to(this, 0.4, { y: centerY, ease:Strong.easeOut } );
		}
		
		private function onKeyInput(e:KeyboardEvent):void {
			if ((stage.displayState != StageDisplayState.NORMAL) && (!e.ctrlKey)) {
				dispatchEvent(new AlertEvent("Only copy and paste supported in full screen mode!"));
			}
		}
		
		private function resizeHandler(e:Event):void {
			x = stage.stageWidth - width;
			popoff();			
		}
	}

}