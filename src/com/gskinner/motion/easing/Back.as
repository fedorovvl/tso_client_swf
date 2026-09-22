package com.gskinner.motion.easing
{
    public class Back 
    {

        protected static var s:Number = 1.70158;


        public static function easeIn(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return ((_arg_1 * _arg_1) * (((s + 1) * _arg_1) - s));
        }

        public static function easeOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return (((--_arg_1 * _arg_1) * (((s + 1) * _arg_1) + s)) + 1);
        }

        public static function easeInOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return (((_arg_1 = (_arg_1 * 2)) < 1) ? (0.5 * ((_arg_1 * _arg_1) * ((((s * 1.525) + 1) * _arg_1) - (s * 1.525)))) : (0.5 * ((((_arg_1 = (_arg_1 - 2)) * _arg_1) * ((((s * 1.525) + 1) * _arg_1) + (s * 1.525))) + 2)));
        }


    }
}
