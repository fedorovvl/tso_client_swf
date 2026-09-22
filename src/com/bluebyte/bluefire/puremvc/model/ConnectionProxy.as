package com.bluebyte.bluefire.puremvc.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import flash.events.IEventDispatcher;
    import com.bluebyte.bluefire.api.model.vo.PlayerVO;
    import flash.events.EventDispatcher;
    import com.bluebyte.bluefire.api.model.vo.ServerVO;
    import com.bluebyte.bluefire.api.model.vo.ConstantsVO;
    import __AS3__.vec.Vector;
    import com.bluebyte.bluefire.api.model.vo.MessageVO;
    import mx.collections.ArrayCollection;
    import com.bluebyte.bluefire.api.model.vo.RoomVO;
    import com.bluebyte.bluefire.api.model.vo.ChannelVO;
    import com.bluebyte.bluefire.puremvc.BlueFireFacade;
    import mx.events.PropertyChangeEvent;
    import flash.events.Event;
    import __AS3__.vec.*;

    public class ConnectionProxy extends Proxy implements IProxy, IEventDispatcher 
    {

        public static const NAME:String = "ConnectionProxy";
        public static var VERSION:String = "";

        private var _player:PlayerVO;
        private var _status:int;
        private var _errorCondition:String = "";
        private var _activeChannel:String;
        private var _bindingEventDispatcher:EventDispatcher;
        private var _server:ServerVO;

        private var _constants:ConstantsVO = new ConstantsVO();
        private var _messages:Vector.<MessageVO> = new Vector.<MessageVO>();
        private var _rooms:ArrayCollection = new ArrayCollection();
        private var _channels:ArrayCollection = new ArrayCollection();
        private var _whispers:ArrayCollection = new ArrayCollection();

        public function ConnectionProxy()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super(NAME);
        }

        public function set server(_arg_1:ServerVO):void
        {
            this._server = _arg_1;
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        private function set _892481550status(_arg_1:int):void
        {
            this._status = _arg_1;
        }

        public function isJoiningInProgress():Boolean
        {
            return (false);
        }

        public function addRoom(_arg_1:RoomVO):void
        {
            this._rooms.addItem(_arg_1);
            this.refreshChannels();
        }

        private function addWhisper(_arg_1:String):ChannelVO
        {
            var _local_2:ChannelVO = new ChannelVO();
            _local_2.name = _arg_1;
            _local_2.addRoom(_arg_1);
            _local_2.visible = true;
            this._whispers.addItem(_local_2);
            sendNotification(BlueFireFacade.ADD_WHISPER, _local_2);
            return (_local_2);
        }

        public function addMessage(_arg_1:MessageVO):void
        {
            var _local_2:ChannelVO;
            var _local_3:Boolean;
            var _local_4:ChannelVO;
            var _local_5:ChannelVO;
            var _local_6:ChannelVO;
            if (_arg_1.groupMessage)
            {
                for each (_local_2 in this._channels)
                {
                    if (_local_2.hasRoom(_arg_1.room))
                    {
                        _local_2.addMessage(_arg_1);
                    };
                };
            }
            else
            {
                for each (_local_4 in this._whispers)
                {
                    if (_local_4.name.toLowerCase() == _arg_1.room.toLowerCase())
                    {
                        _local_4.addMessage(_arg_1);
                        _local_3 = true;
                        break;
                    };
                };
                if (!_local_3)
                {
                    _local_6 = this.addWhisper(_arg_1.room);
                    _local_6.addMessage(_arg_1);
                };
                for each (_local_5 in this._channels)
                {
                    if (_local_5.hasRoom("whisper"))
                    {
                        _local_5.addMessage(_arg_1);
                    };
                };
            };
        }

        public function addChannel(_arg_1:ChannelVO):void
        {
            if (this.getChannel(_arg_1.name) == null)
            {
                this._channels.addItem(_arg_1);
            };
        }

        public function get whispers():ArrayCollection
        {
            return (this._whispers);
        }

        public function get CONSTANTS():ConstantsVO
        {
            return (this._constants);
        }

        [Bindable(event="propertyChange")]
        public function set channels(_arg_1:ArrayCollection):void
        {
            var _local_2:Object = this.channels;
            if (_local_2 !== _arg_1)
            {
                this._1432626128channels = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "channels", _local_2, _arg_1));
            };
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function set player(_arg_1:PlayerVO):void
        {
            this._player = _arg_1;
        }

        public function get server():ServerVO
        {
            return (this._server);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        private function refreshChannels():void
        {
            var _local_1:RoomVO;
            var _local_2:ChannelVO;
            for each (_local_1 in this._rooms)
            {
                for each (_local_2 in this._channels)
                {
                    if (_local_2.hasRoom(_local_1.name))
                    {
                        _local_2.visible = true;
                    };
                };
            };
        }

        public function getWhisper(_arg_1:String):ChannelVO
        {
            var _local_2:ChannelVO;
            for each (_local_2 in this._whispers)
            {
                if (_local_2.name.toLowerCase() == _arg_1.toLowerCase())
                {
                    return (_local_2);
                };
            };
            return (this.addWhisper(_arg_1));
        }

        public function getChannel(_arg_1:String):ChannelVO
        {
            var _local_2:ChannelVO;
            for each (_local_2 in this._channels)
            {
                if (_local_2.name == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function getRoom(_arg_1:String):RoomVO
        {
            var _local_2:int;
            while (_local_2 < this._rooms.length)
            {
                if (this._rooms[_local_2].name == _arg_1)
                {
                    return (this._rooms[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function get channels():ArrayCollection
        {
            return (this._channels);
        }

        private function set _1432626128channels(_arg_1:ArrayCollection):void
        {
            this._channels = _arg_1;
        }

        public function set CONSTANTS(_arg_1:ConstantsVO):void
        {
            this._constants = _arg_1;
        }

        public function removeChannel(_arg_1:String):void
        {
            var _local_2:int = this._channels.getItemIndex(this.getChannel(_arg_1));
            if (_local_2 > -1)
            {
                this._channels.removeItemAt(_local_2);
            };
        }

        public function get player():PlayerVO
        {
            return (this._player);
        }

        [Bindable(event="propertyChange")]
        public function set whispers(_arg_1:ArrayCollection):void
        {
            var _local_2:Object = this.whispers;
            if (_local_2 !== _arg_1)
            {
                this._2132162255whispers = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "whispers", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function set status(_arg_1:int):void
        {
            var _local_2:Object = this.status;
            if (_local_2 !== _arg_1)
            {
                this._892481550status = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "status", _local_2, _arg_1));
            };
        }

        public function set errorCondition(_arg_1:String):void
        {
            this._errorCondition = _arg_1;
        }

        public function removeWhisper(_arg_1:String):void
        {
            var _local_2:ChannelVO = this.getWhisper(_arg_1);
            this.whispers.removeItemAt(this.whispers.getItemIndex(_local_2));
            sendNotification(BlueFireFacade.REMOVE_WHISPER, _local_2);
        }

        public function set rooms(_arg_1:ArrayCollection):void
        {
            this._rooms = _arg_1;
        }

        public function get status():int
        {
            return (this._status);
        }

        public function get errorCondition():String
        {
            return (this._errorCondition);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        private function set _2132162255whispers(_arg_1:ArrayCollection):void
        {
            this._whispers = _arg_1;
        }

        public function get rooms():ArrayCollection
        {
            return (this._rooms);
        }

        public function removeRoom(_arg_1:String):void
        {
            var _local_2:int;
            while (_local_2 < this._rooms.length)
            {
                if (this._rooms[_local_2].name == _arg_1)
                {
                    this._rooms.removeItemAt(_local_2);
                    return;
                };
                _local_2++;
            };
        }


    }
}
