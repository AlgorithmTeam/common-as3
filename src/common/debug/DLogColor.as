package common.debug
{
    public class DLogColor
    {
        public static const DEBUG:String 	= "#DDDDDD";
        public static const INFO:String 	= "#BBBBBB";
        public static const WARN:String 	= "#FF6600";
        public static const ERROR:String 	= "#FF0000";
        public static const MESSAGE:String 	= "#FFFFFF";
        public static const CMD:String 		= "#00DD00";
        
        public static function getColor(level:String):String
        {
            switch(level)
            {
                case DLogEntry.DEBUG:
                    return DEBUG;
                case DLogEntry.INFO:
                    return INFO;
                case DLogEntry.WARNING:
                    return WARN;
                case DLogEntry.ERROR:
                    return ERROR;
                case DLogEntry.MESSAGE:
                    return MESSAGE;
                case "CMD":
                    return CMD;
                default:
                    return MESSAGE;
            }
        }
    }
}