package event 
{
	import flash.events.Event;
	
	/**
	 * AlertEvent contains a string message only.
	 */
	public class AlertEvent extends Event
	{
		/**
		 * @eventType event.AlertEvent.MESSAGE
		 */
		public static const MESSAGE:String = "alertMessage";
		
		/**
		 * The message of AlertEvent.
		 */
		public var message:String;
		
		/**
		 * @param	msg			Message
		 * @param	bubble		bubble
		 * @param	cancelable  cancelable
		 */
		public function AlertEvent(msg:String, bubble:Boolean = true, cancelable:Boolean = false)
		{
			super(MESSAGE, bubbles, cancelable);
			message = msg;
		}		
	}

}