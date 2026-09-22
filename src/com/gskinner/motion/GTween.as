package com.gskinner.motion
{
    import flash.events.EventDispatcher;
    import flash.display.Shape;
    import flash.utils.Dictionary;
    import flash.events.Event;
    import flash.utils.getTimer;
    import flash.events.IEventDispatcher;

    public class GTween extends EventDispatcher 
    {

        public static var version:Number = 2.01;
        public static var defaultDispatchEvents:Boolean = false;
        public static var defaultEase:Function = linearEase;
        public static var pauseAll:Boolean = false;
        public static var timeScaleAll:Number = 1;
        protected static var hasStarPlugins:Boolean = false;
        protected static var plugins:Object = {};
        protected static var shape:Shape;
        protected static var time:Number;
        protected static var tickList:Dictionary = new Dictionary(true);
        protected static var gcLockList:Dictionary = new Dictionary(false);

        protected var _delay:Number = 0;
        protected var _values:Object;
        protected var _paused:Boolean = true;
        protected var _position:Number;
        protected var _inited:Boolean;
        protected var _initValues:Object;
        protected var _rangeValues:Object;
        protected var _proxy:TargetProxy;
        public var autoPlay:Boolean = true;
        public var data:*;
        public var duration:Number;
        public var ease:Function;
        public var nextTween:GTween;
        public var pluginData:Object;
        public var reflect:Boolean;
        public var repeatCount:int = 1;
        public var target:Object;
        public var useFrames:Boolean;
        public var timeScale:Number = 1;
        public var positionOld:Number;
        public var ratio:Number;
        public var ratioOld:Number;
        public var calculatedPosition:Number;
        public var calculatedPositionOld:Number;
        public var suppressEvents:Boolean;
        public var dispatchEvents:Boolean;
        public var onComplete:Function;
        public var onChange:Function;
        public var onInit:Function;

        {
            staticInit();
        }

        public function GTween(_arg_1:Object=null, _arg_2:Number=1, _arg_3:Object=null, _arg_4:Object=null, _arg_5:Object=null)
        {
            var _local_6:Boolean;
            super();
            this.ease = defaultEase;
            this.dispatchEvents = defaultDispatchEvents;
            this.target = _arg_1;
            this.duration = _arg_2;
            this.pluginData = this.copy(_arg_5, {});
            if (_arg_4)
            {
                _local_6 = _arg_4.swapValues;
                delete _arg_4.swapValues;
            };
            this.copy(_arg_4, this);
            this.resetValues(_arg_3);
            if (_local_6)
            {
                this.swapValues();
            };
            if ((((this.duration == 0) && (this.delay == 0)) && (this.autoPlay)))
            {
                this.position = 0;
            };
        }

        public static function installPlugin(_arg_1:Object, _arg_2:Array, _arg_3:Boolean=false):void
        {
            var _local_5:String;
            var _local_4:uint;
            while (_local_4 < _arg_2.length)
            {
                _local_5 = _arg_2[_local_4];
                if (_local_5 == "*")
                {
                    hasStarPlugins = true;
                };
                if (plugins[_local_5] == null)
                {
                    plugins[_local_5] = [_arg_1];
                }
                else
                {
                    if (_arg_3)
                    {
                        plugins[_local_5].unshift(_arg_1);
                    }
                    else
                    {
                        plugins[_local_5].push(_arg_1);
                    };
                };
                _local_4++;
            };
        }

        public static function linearEase(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return (_arg_1);
        }

        protected static function staticInit():void
        {
            (shape = new Shape()).addEventListener(Event.ENTER_FRAME, staticTick);
            time = (getTimer() / 1000);
        }

        protected static function staticTick(_arg_1:Event):void
        {
            var _local_4:Object;
            var _local_5:GTween;
            var _local_2:Number = time;
            time = (getTimer() / 1000);
            if (pauseAll)
            {
                return;
            };
            var _local_3:Number = ((time - _local_2) * timeScaleAll);
            for (_local_4 in tickList)
            {
                _local_5 = (_local_4 as GTween);
                _local_5.position = (_local_5._position + (((_local_5.useFrames) ? timeScaleAll : _local_3) * _local_5.timeScale));
            };
        }


        public function get paused():Boolean
        {
            return (this._paused);
        }

        public function set paused(_arg_1:Boolean):void
        {
            if (_arg_1 == this._paused)
            {
                return;
            };
            this._paused = _arg_1;
            if (this._paused)
            {
                delete tickList[this];
                if ((this.target is IEventDispatcher))
                {
                    this.target.removeEventListener("_", this.invalidate);
                };
                delete gcLockList[this];
            }
            else
            {
                if (((isNaN(this._position)) || ((!(this.repeatCount == 0)) && (this._position >= (this.repeatCount * this.duration)))))
                {
                    this._inited = false;
                    this.calculatedPosition = (this.calculatedPositionOld = (this.ratio = (this.ratioOld = (this.positionOld = 0))));
                    this._position = -(this.delay);
                };
                tickList[this] = true;
                if ((this.target is IEventDispatcher))
                {
                    this.target.addEventListener("_", this.invalidate);
                }
                else
                {
                    gcLockList[this] = true;
                };
            };
        }

        public function get position():Number
        {
            return (this._position);
        }

        public function set position(_arg_1:Number):void
        {
            var _local_4:String;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Array;
            var _local_9:uint;
            var _local_10:uint;
            this.positionOld = this._position;
            this.ratioOld = this.ratio;
            this.calculatedPositionOld = this.calculatedPosition;
            var _local_2:Number = (this.repeatCount * this.duration);
            var _local_3:Boolean = ((_arg_1 >= _local_2) && (this.repeatCount > 0));
            if (_local_3)
            {
                if (this.calculatedPositionOld == _local_2)
                {
                    return;
                };
                this._position = _local_2;
                this.calculatedPosition = (((this.reflect) && (!(this.repeatCount & 0x01))) ? 0 : this.duration);
            }
            else
            {
                this._position = _arg_1;
                this.calculatedPosition = ((this._position < 0) ? 0 : (this._position % this.duration));
                if (((this.reflect) && ((this._position / this.duration) & 0x01)))
                {
                    this.calculatedPosition = (this.duration - this.calculatedPosition);
                };
            };
            this.ratio = (((this.duration == 0) && (this._position >= 0)) ? 1 : this.ease((this.calculatedPosition / this.duration), 0, 1, 1));
            if ((((this.target) && ((this._position >= 0) || (this.positionOld >= 0))) && (!(this.calculatedPosition == this.calculatedPositionOld))))
            {
                if (!this._inited)
                {
                    this.init();
                };
                for (_local_4 in this._values)
                {
                    _local_5 = this._initValues[_local_4];
                    _local_6 = this._rangeValues[_local_4];
                    _local_7 = (_local_5 + (_local_6 * this.ratio));
                    _local_8 = plugins[_local_4];
                    if (_local_8)
                    {
                        _local_9 = _local_8.length;
                        _local_10 = 0;
                        while (_local_10 < _local_9)
                        {
                            _local_7 = _local_8[_local_10].tween(this, _local_4, _local_7, _local_5, _local_6, this.ratio, _local_3);
                            _local_10++;
                        };
                        if (!isNaN(_local_7))
                        {
                            this.target[_local_4] = _local_7;
                        };
                    }
                    else
                    {
                        this.target[_local_4] = _local_7;
                    };
                };
            };
            if (hasStarPlugins)
            {
                _local_8 = plugins["*"];
                _local_9 = _local_8.length;
                _local_10 = 0;
                while (_local_10 < _local_9)
                {
                    _local_8[_local_10].tween(this, "*", NaN, NaN, NaN, this.ratio, _local_3);
                    _local_10++;
                };
            };
            if (!this.suppressEvents)
            {
                if (this.dispatchEvents)
                {
                    this.dispatchEvt("change");
                };
                if (this.onChange != null)
                {
                    this.onChange(this);
                };
            };
            if (_local_3)
            {
                this.paused = true;
                if (this.nextTween)
                {
                    this.nextTween.paused = false;
                };
                if (!this.suppressEvents)
                {
                    if (this.dispatchEvents)
                    {
                        this.dispatchEvt("complete");
                    };
                    if (this.onComplete != null)
                    {
                        this.onComplete(this);
                    };
                };
            };
        }

        public function get delay():Number
        {
            return (this._delay);
        }

        public function set delay(_arg_1:Number):void
        {
            if (this._position <= 0)
            {
                this._position = -(_arg_1);
            };
            this._delay = _arg_1;
        }

        public function get proxy():TargetProxy
        {
            if (this._proxy == null)
            {
                this._proxy = new TargetProxy(this);
            };
            return (this._proxy);
        }

        public function setValue(_arg_1:String, _arg_2:Number):void
        {
            this._values[_arg_1] = _arg_2;
            this.invalidate();
        }

        public function getValue(_arg_1:String):Number
        {
            return (this._values[_arg_1]);
        }

        public function deleteValue(_arg_1:String):Boolean
        {
            delete this._rangeValues[_arg_1];
            delete this._initValues[_arg_1];
            return (delete this._values[_arg_1]);
        }

        public function setValues(_arg_1:Object):void
        {
            this.copy(_arg_1, this._values, true);
            this.invalidate();
        }

        public function resetValues(_arg_1:Object=null):void
        {
            this._values = {};
            this.setValues(_arg_1);
        }

        public function getValues():Object
        {
            return (this.copy(this._values, {}));
        }

        public function getInitValue(_arg_1:String):Number
        {
            return (this._initValues[_arg_1]);
        }

        public function swapValues():void
        {
            var _local_2:String;
            var _local_3:Number;
            if (!this._inited)
            {
                this.init();
            };
            var _local_1:Object = this._values;
            this._values = this._initValues;
            this._initValues = _local_1;
            for (_local_2 in this._rangeValues)
            {
                this._rangeValues[_local_2] = (this._rangeValues[_local_2] * -1);
            };
            if (this._position < 0)
            {
                _local_3 = this.positionOld;
                this.position = 0;
                this._position = this.positionOld;
                this.positionOld = _local_3;
            }
            else
            {
                this.position = this._position;
            };
        }

        public function init():void
        {
            var _local_1:String;
            var _local_2:Array;
            var _local_3:uint;
            var _local_4:Number;
            var _local_5:uint;
            this._inited = true;
            this._initValues = {};
            this._rangeValues = {};
            for (_local_1 in this._values)
            {
                if (plugins[_local_1])
                {
                    _local_2 = plugins[_local_1];
                    _local_3 = _local_2.length;
                    _local_4 = ((_local_1 in this.target) ? this.target[_local_1] : NaN);
                    _local_5 = 0;
                    while (_local_5 < _local_3)
                    {
                        _local_4 = _local_2[_local_5].init(this, _local_1, _local_4);
                        _local_5++;
                    };
                    if (!isNaN(_local_4))
                    {
                        this._rangeValues[_local_1] = (this._values[_local_1] - (this._initValues[_local_1] = _local_4));
                    };
                }
                else
                {
                    this._rangeValues[_local_1] = (this._values[_local_1] - (this._initValues[_local_1] = this.target[_local_1]));
                };
            };
            if (hasStarPlugins)
            {
                _local_2 = plugins["*"];
                _local_3 = _local_2.length;
                _local_5 = 0;
                while (_local_5 < _local_3)
                {
                    _local_2[_local_5].init(this, "*", NaN);
                    _local_5++;
                };
            };
            if (!this.suppressEvents)
            {
                if (this.dispatchEvents)
                {
                    this.dispatchEvt("init");
                };
                if (this.onInit != null)
                {
                    this.onInit(this);
                };
            };
        }

        public function beginning():void
        {
            this.position = 0;
            this.paused = true;
        }

        public function end():void
        {
            this.position = ((this.repeatCount > 0) ? (this.repeatCount * this.duration) : this.duration);
        }

        protected function invalidate():void
        {
            this._inited = false;
            if (this._position > 0)
            {
                this._position = 0;
            };
            if (this.autoPlay)
            {
                this.paused = false;
            };
        }

        protected function copy(_arg_1:Object, _arg_2:Object, _arg_3:Boolean=false):Object
        {
            var _local_4:String;
            for (_local_4 in _arg_1)
            {
                if (((_arg_3) && (_arg_1[_local_4] == null)))
                {
                    delete _arg_2[_local_4];
                }
                else
                {
                    _arg_2[_local_4] = _arg_1[_local_4];
                };
            };
            return (_arg_2);
        }

        protected function dispatchEvt(_arg_1:String):void
        {
            if (hasEventListener(_arg_1))
            {
                dispatchEvent(new Event(_arg_1));
            };
        }


    }
}//package com.gskinner.motion

import flash.utils.Proxy;
import com.gskinner.motion.GTween;
import flash.utils.flash_proxy; 

use namespace flash.utils.flash_proxy;

dynamic class TargetProxy extends Proxy 
{

    /*private*/ var tween:GTween;

    public function TargetProxy(_arg_1:GTween):void
    {
        super();
        this.tween = _arg_1;
    }

    override flash_proxy function callProperty(_arg_1:*, ... _args):*
    {
        return (this.tween.target[_arg_1].apply(null, _args));
    }

    override flash_proxy function getProperty(_arg_1:*):*
    {
        var _local_2:Number = this.tween.getValue(_arg_1);
        return ((isNaN(_local_2)) ? this.tween.target[_arg_1] : _local_2);
    }

    override flash_proxy function setProperty(_arg_1:*, _arg_2:*):void
    {
        if ((((_arg_2 is Boolean) || (_arg_2 is String)) || (isNaN(_arg_2))))
        {
            this.tween.target[_arg_1] = _arg_2;
        }
        else
        {
            this.tween.setValue(String(_arg_1), Number(_arg_2));
        };
    }

    override flash_proxy function deleteProperty(_arg_1:*):Boolean
    {
        this.tween.deleteValue(_arg_1);
        return (true);
    }


}


