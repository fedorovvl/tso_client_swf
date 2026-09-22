package Utils
{
    public class ArrayUtils 
    {


        public static function isEmpty(_arg_1:Array):Boolean
        {
            return (_arg_1.length == 0);
        }

        public static function length(_arg_1:Array):int
        {
            return (_arg_1.length);
        }

        public static function contains(_arg_1:Array, _arg_2:String):Boolean
        {
            return (!(_arg_1.indexOf(_arg_2) == -1));
        }


    }
}
