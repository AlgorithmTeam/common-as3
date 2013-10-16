package common.debug
{
	public interface IDLogAppender
	{
		function addLogMessage(level:String, loggerName:String, message:String):void;
	}
}