package common.debug
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.external.ExternalInterface;

	public class DConsole
	{		
		protected static var commandList:Array = [];
		protected static var commands:Object = {};
		protected static var commandListOrdered:Boolean = false;
		protected static var _hotKeyCode:uint = 192;
		
		public static var verbosity:int = 0;
		public function DConsole()
		{
		}
		
		public static function registerCommand(name:String, callback:Function, docs:String = null):void{
			if (callback == null)
				Logger.error(DConsole, "registerCommand", "Command '" + name + "' has no callback!");
			
			if (!name || name.length == 0)
				Logger.error(DConsole, "registerCommand", "Command has no name!");
			
			if (name.indexOf(" ") != -1)
				Logger.error(DConsole, "registerCommand", "Command '" + name + "' has a space in it, it will not work.");
			
			var c:ConsoleCommand = new ConsoleCommand();
			c.name = name;
			c.callback = callback;
			c.docs = docs;
			
			if (commands[name.toLowerCase()])
				Logger.warn(DConsole, "registerCommand", "Replacing existing command '" + name + "'.");
			
			commands[name.toLowerCase()] = c;
			
			commandList.push(c);
			commandListOrdered = false;
		}
		
		public static function getCommandList():Array
		{
			ensureCommandsOrdered();			
			return commandList;
		}
		
		protected static function ensureCommandsOrdered():void
		{
			if (commandListOrdered == true)
				return;
			
			if (commands.help == null)
				init();
			
			commandListOrdered = true;
			
			commandList.sort(function(a:ConsoleCommand, b:ConsoleCommand):int
			{
				if (a.name > b.name)
					return 1;
				else
					return -1;
			});
		}
		
		protected static function _listDisplayObjects(current:DisplayObject, indent:int):int
		{
			if (!current)
				return 0;
			
			Logger.print(DConsole,
				DConsole.generateIndent(indent) +
				current.name +
				" (" + current.x + "," + current.y + ") visible=" +
				current.visible);
			
			var parent:DisplayObjectContainer = current as DisplayObjectContainer;
			if (!parent)
				return 1;
			
			var sum:int = 1;
			for (var i:int = 0; i < parent.numChildren; i++)
				sum += _listDisplayObjects(parent.getChildAt(i), indent + 1);
			return sum;
		}
		protected static function generateIndent(indent:int):String
		{
			var str:String = "";
			for (var i:int = 0; i < indent; i++)
			{
				// Add 2 spaces for indent
				str += "  ";
			}
			
			return str;
		}
		
		public static function init():void
		{
			/*** THESE ARE THE DEFAULT CONSOLE COMMANDS ***/
			registerCommand("help", function(prefix:String = null):void
			{
				// Get commands in alphabetical order.
				ensureCommandsOrdered();
				
				Logger.print(DConsole, "快捷键: ");
				Logger.print(DConsole, "[SHIFT]-TAB			- 循环执行command.");
				Logger.print(DConsole, "PageUp/PageDown			- 日志翻上页/下页");
				Logger.print(DConsole, "");
				
				// Display results.
				Logger.print(DConsole, "Commands:");
				for (var i:int = 0; i < commandList.length; i++)
				{
					var cc:ConsoleCommand = commandList[i] as ConsoleCommand;
					
					// Do prefix filtering.
					if (prefix && prefix.length > 0 && cc.name.substr(0, prefix.length) != prefix)
						continue;
					
					Logger.print(DConsole, "   " + cc.name + "			- " + (cc.docs ? cc.docs : ""));
				}
			}, "查看命令列表");
			
			registerCommand("verbose", function(level:int):void
			{
				DConsole.verbosity = level;
				Logger.print(DConsole, "Verbosity set to " + level);
			}, "Set verbosity level of console output.");
			
			if(ExternalInterface.available)
			{
				registerCommand("exit", _exitMethod,
					"Attempts to exit the application using ExternalInterface if avaliable");
			}
		}
		protected static function _exitMethod():void
		{
			if(ExternalInterface.available)
			{
				Logger.info(DConsole, "exit", ExternalInterface.call("window.close"));	
			}
			else
			{
				Logger.warn(DConsole, "exit", "ExternalInterface is not avaliable");
			}
		}
		public static function processLine(line:String):void
		{
			// Make sure everything is in order.
			ensureCommandsOrdered();
			
			// Match Tokens, this allows for text to be split by spaces excluding spaces between quotes.
			// TODO Allow escaping of quotes
			var pattern:RegExp = /[^\s"']+|"[^"]*"|'[^']*'/g;
			var args:Array = [];
			var test:Object = {};
			while (test)
			{
				test = pattern.exec(line);
				if (test)
				{
					var str:String = test[0];
					str = PBUtil.trim(str, "'");
					str = PBUtil.trim(str, "\"");
					args.push(str);	// If no more matches can be found, test will be null
				}
			}
			
			// Look up the command.
			if (args.length == 0)
				return;
			var potentialCommand:ConsoleCommand = commands[args[0].toString().toLowerCase()];
			
			if (!potentialCommand)
			{
				Logger.warn(DConsole, "processLine", "No such command '" + args[0].toString() + "'!");
				return;
			}
			
			// Now call the command.
			try
			{
				potentialCommand.callback.apply(null, args.slice(1));
			}
			catch(e:Error)
			{
				var errorStr:String = "Error: " + e.toString();
				errorStr += " - " + e.getStackTrace();
				Logger.error(DConsole, args[0], errorStr);
			}
		}
		
		/**
		 * The keycode to toggle the Console interface.
		 */
		public static function set hotKeyCode(value:uint):void
		{
			Logger.print(DConsole, "Setting hotKeyCode to: " + value);
			_hotKeyCode = value;
		}
		
		public static function get hotKeyCode():uint
		{
			return _hotKeyCode;
		}
	}
}

final class ConsoleCommand
{
	public var name:String;
	public var callback:Function;
	public var docs:String;
}