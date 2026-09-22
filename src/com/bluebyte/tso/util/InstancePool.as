package com.bluebyte.tso.util
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import mx.events.PropertyChangeEvent;
    import flash.events.Event;

    public class InstancePool implements IEventDispatcher 
    {

        private static var inst:InstancePool;
        private static var _29097598instances:uint = 0;
        private static var _staticBindingEventDispatcher:EventDispatcher = new EventDispatcher();

        private var pool:Dictionary = new Dictionary(true);
        private var _bindingEventDispatcher:EventDispatcher;

        public function InstancePool(_arg_1:SingletonEnforcer)
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            if (inst)
            {
                throw (new Error("There is already an instance of InstancePool()!"));
            };
        }

        public static function freeInstance(_arg_1:Class, _arg_2:IPoolable):void
        {
            getInstance()._freeInstance(_arg_1, _arg_2);
        }

        private static function getInstance():InstancePool
        {
            if (!inst)
            {
                inst = new InstancePool(new SingletonEnforcer());
            };
            return (inst);
        }

        public static function get staticEventDispatcher():IEventDispatcher
        {
            return (_staticBindingEventDispatcher);
        }

        public static function newInstance(_arg_1:Class, _arg_2:Object=null):IPoolable
        {
            return (getInstance()._newInstance(_arg_1, _arg_2));
        }

        public static function set instances(_arg_1:uint):void
        {
            var _local_3:IEventDispatcher;
            var _local_2:Object = InstancePool._29097598instances;
            if (_local_2 !== _arg_1)
            {
                InstancePool._29097598instances = _arg_1;
                _local_3 = InstancePool.staticEventDispatcher;
                if (_local_3 != null)
                {
                    _local_3.dispatchEvent(PropertyChangeEvent.createUpdateEvent(InstancePool, "instances", _local_2, _arg_1));
                };
            };
        }

        [Bindable(event="propertyChange")]
        public static function get instances():uint
        {
            return (InstancePool._29097598instances);
        }


        private function _freeInstance(_arg_1:Class, _arg_2:IPoolable):void
        {
            var _local_3:Array;
            if ((_arg_1 in this.pool))
            {
                _local_3 = (this.pool[_arg_1] as Array);
            }
            else
            {
                _local_3 = new Array();
                this.pool[_arg_1] = _local_3;
            };
            _local_3.push(_arg_2);
            _arg_2.reset();
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        private function _newInstance(_arg_1:Class, _arg_2:Object):IPoolable
        {
            var _local_4:Array;
            var _local_3:IPoolable;
            if ((_arg_1 in this.pool))
            {
                _local_4 = (this.pool[_arg_1] as Array);
                _local_3 = _local_4.pop();
            };
            if (!_local_3)
            {
                _local_3 = new (_arg_1)();
                instances++;
            };
            _local_3.init(_arg_2);
            return (_local_3);
        }


    }
}//package com.bluebyte.tso.util

class SingletonEnforcer 
{

    public function SingletonEnforcer()
    {
        super();
    }

}


