package com.gskinner.motion.plugins
{
    import com.gskinner.motion.GTween;

    public interface IGTweenPlugin 
    {

        function init(_arg_1:GTween, _arg_2:String, _arg_3:Number):Number;
        function tween(_arg_1:GTween, _arg_2:String, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Boolean):Number;

    }
}
