package nLib
{
    import flash.utils.ByteArray;
    import flash.utils.*;
    import flash.net.*;

    public class gBinaryStream 
    {

        private static var p:ByteArray;
        private static var initP:ByteArray;
        public static var a:int;


        public static function InitBinaryStream(_arg_1:ByteArray, _arg_2:int=0):void
        {
            p = _arg_1;
            a = _arg_2;
        }

        public static function ReadShort():int
        {
            var _local_1:int = (p[a] + (0x0100 * p[(a + 1)]));
            a = (a + 2);
            return (_local_1);
        }

        public static function ReadInt():int
        {
            return (ReadShort() + (0x10000 * ReadShort()));
        }

        public static function ReadCStringAtPos_string(_arg_1:int):String
        {
            var _local_2:* = "";
            var _local_3:int;
            while (true)
            {
                if (p[(_arg_1 + _local_3)] == 0) break;
                _local_2 = (_local_2 + String.fromCharCode(p[(_arg_1 + _local_3)]));
                _local_3++;
            };
            return (_local_2);
        }


    }
}
