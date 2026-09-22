package com.bluebyte.bluefire.api.model.vo
{
    import flash.events.IEventDispatcher;
    import mx.collections.ArrayCollection;
    import flash.events.EventDispatcher;
    import mx.events.PropertyChangeEvent;
    import flash.events.Event;

    public class ChannelVO implements IEventDispatcher 
    {

        private var _rooms:ArrayCollection = new ArrayCollection();
        private var _sortingIndex:int;
        private var _important:Boolean;
        private var _messages:ArrayCollection = new ArrayCollection();
        private var _visible:Boolean;
        private var _bindingEventDispatcher:EventDispatcher;
        private var _newMessages:Boolean;
        private var _name:String;
        private var _label:String;

        public function ChannelVO()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function get label():String
        {
            return (this._label);
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function get name():String
        {
            return (this._name);
        }

        private function set _462094004messages(_arg_1:ArrayCollection):void
        {
            throw (new Error("not used, just for data binding!"));
        }

        private function set _102727412label(_arg_1:String):void
        {
            this._label = _arg_1;
        }

        public function get newMessages():Boolean
        {
            return (this._newMessages);
        }

        public function hasRoom(_arg_1:String):Boolean
        {
            var _local_2:String;
            for each (_local_2 in this._rooms)
            {
                if (_local_2.toLowerCase() == _arg_1.toLowerCase())
                {
                    return (true);
                };
            };
            return (false);
        }

        [Bindable(event="propertyChange")]
        public function set name(_arg_1:String):void
        {
            var _local_2:Object = this.name;
            if (_local_2 !== _arg_1)
            {
                this._3373707name = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "name", _local_2, _arg_1));
            };
        }

        private function set _208525278important(_arg_1:Boolean):void
        {
            this._important = _arg_1;
        }

        private function set _3373707name(_arg_1:String):void
        {
            this._name = _arg_1;
        }

        [Bindable(event="propertyChange")]
        public function set newMessages(_arg_1:Boolean):void
        {
            var _local_2:Object = this.newMessages;
            if (_local_2 !== _arg_1)
            {
                this._794652428newMessages = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "newMessages", _local_2, _arg_1));
            };
        }

        public function get important():Boolean
        {
            return (this._important);
        }

        public function addMessage(_arg_1:MessageVO):void
        {
            this._messages.addItem(_arg_1);
        }

        [Bindable(event="propertyChange")]
        public function set messages(_arg_1:ArrayCollection):void
        {
            var _local_2:Object = this.messages;
            if (_local_2 !== _arg_1)
            {
                this._462094004messages = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "messages", _local_2, _arg_1));
            };
        }

        public function get sortingIndex():int
        {
            return (this._sortingIndex);
        }

        public function addRoom(_arg_1:String):void
        {
            this._rooms.addItem(_arg_1);
        }

        public function getRoomCount():int
        {
            return (this._rooms.length);
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function set important(_arg_1:Boolean):void
        {
            var _local_2:Object = this.important;
            if (_local_2 !== _arg_1)
            {
                this._208525278important = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "important", _local_2, _arg_1));
            };
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function get messages():ArrayCollection
        {
            return (this._messages);
        }

        public function set sortingIndex(_arg_1:int):void
        {
            this._sortingIndex = _arg_1;
        }

        public function set visible(_arg_1:Boolean):void
        {
            this._visible = _arg_1;
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        [Bindable(event="propertyChange")]
        public function set label(_arg_1:String):void
        {
            var _local_2:Object = this.label;
            if (_local_2 !== _arg_1)
            {
                this._102727412label = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "label", _local_2, _arg_1));
            };
        }

        private function set _794652428newMessages(_arg_1:Boolean):void
        {
            this._newMessages = _arg_1;
            if (!this._newMessages)
            {
                this.important = false;
            };
        }

        public function get visible():Boolean
        {
            return (this._visible);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }


    }
}
