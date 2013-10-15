package common.debug
{
    public class DTraceAppender implements IDLogAppender
    {
        public function addLogMessage(level:String, loggerName:String, message:String):void
        {
            trace(level + ": " + loggerName + " - " + message);
        }
    }
}