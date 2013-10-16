package common.debug
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;

	public class Logger
	{
		static protected var listeners:Array = [];
		static protected var pendingEntries:Array = [];
		
		private static var _main:DisplayObjectContainer = null;
		private static var started:Boolean = false;
		public function Logger()
		{
		}
		
		public static function startup(stage:DisplayObjectContainer):void{
			_main = stage;
			
			registerListener(new DTraceAppender());
			registerListener(new DUIAppender(_main));
			
			started = true;
		}
		
		public static function registerListener(listener:IDLogAppender):void
		{
			listeners.push(listener);
		}
		
		protected static function processEntry(entry:DLogEntry):void
		{
			if(!started)
			{
				pendingEntries.push(entry);
				return;
			}
			
			for(var i:int=0; i<listeners.length; i++)
				(listeners[i] as IDLogAppender).addLogMessage(entry.type, flash.utils.getQualifiedClassName(entry.reporter), entry.message);
		}
		public static function print(reporter:*, message:String):void
		{
			var entry:DLogEntry = new DLogEntry();
			entry.reporter = getClass(reporter);
			entry.message = message;
			entry.type = DLogEntry.MESSAGE;
			processEntry(entry);
		}
		public static function info(reporter:*, method:String, message:String):void
		{
			var entry:DLogEntry = new DLogEntry();
			entry.reporter = getClass(reporter);
			entry.method = method;
			entry.message = method + " - " + message;
			entry.type = DLogEntry.INFO;
			processEntry(entry);
		}
		
		public static function debug(reporter:*, method:String, message:String):void
		{
			var entry:DLogEntry = new DLogEntry();
			entry.reporter = getClass(reporter);
			entry.method = method;
			entry.message = method + " - " + message;
			entry.type = DLogEntry.DEBUG;
			processEntry(entry);
		}
		public static function warn(reporter:*, method:String, message:String):void
		{
			var entry:DLogEntry = new DLogEntry();
			entry.reporter = getClass(reporter);
			entry.method = method;
			entry.message = method + " - " + message;
			entry.type = DLogEntry.WARNING;
			processEntry(entry);
		}
		
		public static function error(reporter:*, method:String, message:String):void
		{
			var entry:DLogEntry = new DLogEntry();
			entry.reporter = getClass(reporter);
			entry.method = method;
			entry.message = method + " - " + message;
			entry.type = DLogEntry.ERROR;
			processEntry(entry);
		}
		
		public static function printCustom(reporter:*, method:String, message:String, type:String):void
		{			
			var entry:DLogEntry = new DLogEntry();
			entry.reporter = getClass(reporter);
			entry.method = method;
			entry.message = method + " - " + message;
			entry.type = type;
			processEntry(entry);
		}
		
		public static function getClass(item:*):Class
		{
			if(item is Class || item == null)
				return item;
			
			return Object(item).constructor;
		}
	}
}