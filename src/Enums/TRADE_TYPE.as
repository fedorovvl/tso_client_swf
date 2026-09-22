package Enums
{
    public class TRADE_TYPE 
    {

        public static const TRADE_RES_FOR_RES:int = 0;
        public static const TRADE_RES_FOR_BUFF:int = 1;
        public static const TRADE_BUFF_FOR_RES:int = 2;
        public static const TRADE_BUFF_FOR_BUFF:int = 3;
        public static const TRADE_ACCEPT:int = 4;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case TRADE_RES_FOR_RES:
                    return ("TradeResourceForResource");
                case TRADE_RES_FOR_BUFF:
                    return ("TradeResourceForBuff");
                case TRADE_BUFF_FOR_RES:
                    return ("TradeBuffForResource");
                case TRADE_BUFF_FOR_BUFF:
                    return ("TradeBuffForBuff");
                case TRADE_ACCEPT:
                    return ("TradeAccept");
                default:
                    return ("UnknownTradeType" + _arg_1);
            };
        }

        public static function parse(_arg_1:String):int
        {
            if (_arg_1 == toString(TRADE_RES_FOR_RES))
            {
                return (TRADE_RES_FOR_RES);
            };
            if (_arg_1 == toString(TRADE_RES_FOR_BUFF))
            {
                return (TRADE_RES_FOR_BUFF);
            };
            if (_arg_1 == toString(TRADE_BUFF_FOR_RES))
            {
                return (TRADE_BUFF_FOR_RES);
            };
            if (_arg_1 == toString(TRADE_BUFF_FOR_BUFF))
            {
                return (TRADE_BUFF_FOR_BUFF);
            };
            if (_arg_1 == toString(TRADE_ACCEPT))
            {
                return (TRADE_ACCEPT);
            };
            return (-1);
        }


    }
}
