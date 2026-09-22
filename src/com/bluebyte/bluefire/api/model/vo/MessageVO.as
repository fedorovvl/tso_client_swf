package com.bluebyte.bluefire.api.model.vo
{
    import com.bluebyte.bluefire.api.extensions.IMessageExtension;

    public class MessageVO 
    {

        private var _text:String;
        private var _moderator:Boolean;
        private var _receiver:OccupantVO;
        private var _ownname:Boolean;
        private var _sender:OccupantVO;
        private var _important:Boolean;
        private var _groupMessage:Boolean;
        private var _clickable:Boolean;
        private var _time:Date;
        private var _extensions:Object = {};
        private var _room:String;


        public function set receiver(_arg_1:OccupantVO):void
        {
            this._receiver = _arg_1;
        }

        public function set important(_arg_1:Boolean):void
        {
            this._important = _arg_1;
        }

        public function set ownname(_arg_1:Boolean):void
        {
            this._ownname = _arg_1;
        }

        public function get groupMessage():Boolean
        {
            return (this._groupMessage);
        }

        public function getExtension(name:String):IMessageExtension
        {
            return (this.getAllExtensions().filter(function (_arg_1:IMessageExtension, _arg_2:int, _arg_3:Array):Boolean
            {
                return (_arg_1.getElementName() == name);
            })[0]);
        }

        public function set moderator(_arg_1:Boolean):void
        {
            this._moderator = _arg_1;
        }

        public function set clickable(_arg_1:Boolean):void
        {
            this._clickable = _arg_1;
        }

        public function get clickable():Boolean
        {
            return (this._clickable);
        }

        public function set groupMessage(_arg_1:Boolean):void
        {
            this._groupMessage = _arg_1;
        }

        public function get ownname():Boolean
        {
            return (this._ownname);
        }

        public function set text(_arg_1:String):void
        {
            this._text = _arg_1;
        }

        public function removeExtension(_arg_1:IMessageExtension):Boolean
        {
            var _local_3:String;
            var _local_2:Object = this._extensions[_arg_1.getNS()];
            for (_local_3 in _local_2)
            {
                if (_local_2[_local_3] === _arg_1)
                {
                    _local_2[_local_3].remove();
                    _local_2.splice(parseInt(_local_3), 1);
                    return (true);
                };
            };
            return (false);
        }

        public function get moderator():Boolean
        {
            return (this._moderator);
        }

        public function addExtension(_arg_1:IMessageExtension):IMessageExtension
        {
            if (this._extensions[_arg_1.getNS()] == null)
            {
                this._extensions[_arg_1.getNS()] = [];
            };
            this._extensions[_arg_1.getNS()].push(_arg_1);
            return (_arg_1);
        }

        public function set time(_arg_1:Date):void
        {
            this._time = _arg_1;
        }

        public function getAllExtensionsByNS(_arg_1:String):Array
        {
            return (this._extensions[_arg_1]);
        }

        public function get time():Date
        {
            return (this._time);
        }

        public function get important():Boolean
        {
            return (this._important);
        }

        public function get text():String
        {
            return (this._text);
        }

        public function getAllExtensions():Array
        {
            var _local_2:String;
            var _local_1:Array = [];
            for (_local_2 in this._extensions)
            {
                _local_1 = _local_1.concat(this._extensions[_local_2]);
            };
            return (_local_1);
        }

        public function get receiver():OccupantVO
        {
            return (this._receiver);
        }

        public function removeAllExtensions(_arg_1:String):void
        {
            var _local_2:String;
            for (_local_2 in this._extensions[_arg_1])
            {
                this.removeExtension(this._extensions[_arg_1][_local_2]);
            };
            this._extensions[_arg_1] = [];
        }

        public function get sender():OccupantVO
        {
            return (this._sender);
        }

        public function set room(_arg_1:String):void
        {
            this._room = _arg_1;
        }

        public function set sender(_arg_1:OccupantVO):void
        {
            this._sender = _arg_1;
        }

        public function get room():String
        {
            return (this._room);
        }


    }
}
