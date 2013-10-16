package common.debug
{
   public class DLogEntry
   {
      public static const ERROR:String = "ERROR";
      public static const WARNING:String = "WARNING";
	  public static const DEBUG:String = "DEBUG";
	  public static const INFO:String = "INFO";
      public static const MESSAGE:String = "MESSAGE";
      public var reporter:Class = null;
      public var method:String = "";
      public var message:String = "";
      public var type:String = null;
      public var depth:int = 0;
	  public function get formattedMessage():String
      {
         var deep:String = "";
         for (var i:int = 0; i < depth; i++)
            deep += "   ";
         
         var reporter:String = "";
         if (reporter)
            reporter = reporter + ": ";
         
         var method:String = "";
         if (method != null && method != "")
            method = method + " - ";
         
         return deep + reporter + method + message;
      }
   }
}