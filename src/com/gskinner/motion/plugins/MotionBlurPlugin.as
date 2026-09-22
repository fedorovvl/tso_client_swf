package com.gskinner.motion.plugins
{
    import com.gskinner.motion.GTween;
    import flash.filters.BlurFilter;

    public class MotionBlurPlugin implements IGTweenPlugin 
    {

        public static var enabled:Boolean = false;
        public static var strength:Number = 0.6;
        protected static var instance:MotionBlurPlugin;


        public static function install():void
        {
            if (instance)
            {
                return;
            };
            instance = new (MotionBlurPlugin)();
            GTween.installPlugin(instance, ["x", "y"]);
        }


        public function init(_arg_1:GTween, _arg_2:String, _arg_3:Number):Number
        {
            return (_arg_3);
        }

        public function tween(_arg_1:GTween, _arg_2:String, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Boolean):Number
        {
            var _local_11:Number;
            if (!(((enabled) && (_arg_1.pluginData.MotionBlurEnabled == null)) || (_arg_1.pluginData.MotionBlurEnabled)))
            {
                return (_arg_3);
            };
            var _local_8:Object = _arg_1.pluginData.MotionBlurData;
            if (_local_8 == null)
            {
                _local_8 = this.initTarget(_arg_1);
            };
            var _local_9:Array = _arg_1.target.filters;
            var _local_10:BlurFilter = (_local_9[_local_8.index] as BlurFilter);
            if (_local_10 == null)
            {
                return (_arg_3);
            };
            if (_arg_7)
            {
                _local_9.splice(_local_8.index, 1);
                delete _arg_1.pluginData.MotionBlurData;
            }
            else
            {
                _local_11 = Math.abs((((_arg_1.ratioOld - _arg_6) * _arg_5) * strength));
                if (_arg_2 == "x")
                {
                    _local_10.blurX = _local_11;
                }
                else
                {
                    _local_10.blurY = _local_11;
                };
            };
            _arg_1.target.filters = _local_9;
            return (_arg_3);
        }

        protected function initTarget(_arg_1:GTween):Object
        {
            var _local_2:Array = _arg_1.target.filters;
            _local_2.push(new BlurFilter(0, 0, 1));
            _arg_1.target.filters = _local_2;
            return (_arg_1.pluginData.MotionBlurData = {"index":(_local_2.length - 1)});
        }


    }
}
