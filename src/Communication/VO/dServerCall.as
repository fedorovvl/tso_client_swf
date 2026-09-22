package Communication.VO
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;

    public class dServerCall implements IEventDispatcher 
    {

        private var _bindingEventDispatcher:EventDispatcher;
        private var _1646180527dsoAuthToken:String;
        private var _3575610type:int;
        private var _696323641zoneID:int;
        private var _1992731789dsoAuthUser:int;
        private var _3076010data:Object;
        private var _462553521dsoAuthRandomClientID:int;

        public function dServerCall()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get zoneID():int
        {
            return (this._696323641zoneID);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function set zoneID(_arg_1:int):void
        {
            var _local_2:Object = this._696323641zoneID;
            if (_local_2 !== _arg_1)
            {
                this._696323641zoneID = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "zoneID", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get dsoAuthToken():String
        {
            return (this._1646180527dsoAuthToken);
        }

        public function set data(_arg_1:Object):void
        {
            var _local_2:Object = this._3076010data;
            if (_local_2 !== _arg_1)
            {
                this._3076010data = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "data", _local_2, _arg_1));
            };
        }

        public function set dsoAuthToken(_arg_1:String):void
        {
            var _local_2:Object = this._1646180527dsoAuthToken;
            if (_local_2 !== _arg_1)
            {
                this._1646180527dsoAuthToken = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dsoAuthToken", _local_2, _arg_1));
            };
        }

        public function set dsoAuthUser(_arg_1:int):void
        {
            var _local_2:Object = this._1992731789dsoAuthUser;
            if (_local_2 !== _arg_1)
            {
                this._1992731789dsoAuthUser = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dsoAuthUser", _local_2, _arg_1));
            };
        }

        public function set dsoAuthRandomClientID(_arg_1:int):void
        {
            var _local_2:Object = this._462553521dsoAuthRandomClientID;
            if (_local_2 !== _arg_1)
            {
                this._462553521dsoAuthRandomClientID = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dsoAuthRandomClientID", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get data():Object
        {
            return (this._3076010data);
        }

        [Bindable(event="propertyChange")]
        public function get dsoAuthRandomClientID():int
        {
            return (this._462553521dsoAuthRandomClientID);
        }

        [Bindable(event="propertyChange")]
        public function get dsoAuthUser():int
        {
            return (this._1992731789dsoAuthUser);
        }

        [Bindable(event="propertyChange")]
        public function get type():int
        {
            return (this._3575610type);
        }

        public function set type(_arg_1:int):void
        {
            var _local_2:Object = this._3575610type;
            if (_local_2 !== _arg_1)
            {
                this._3575610type = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "type", _local_2, _arg_1));
            };
        }


    }
}
