package com.gskinner.motion.easing
{
    public class Sine 
    {


        public static function easeIn(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return (1 - Math.cos((_arg_1 * (Math.PI / 2))));
        }

        public static function easeOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return (Math.sin((_arg_1 * (Math.PI / 2))));
        }

        public static function easeInOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return (-0.5 * (Math.cos((_arg_1 * Math.PI)) - 1));
        }


    }
}
