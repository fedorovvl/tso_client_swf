package com.bluebyte.tso.chat
{
    import com.bluebyte.bluefire.api.model.vo.MessageVO;
    import com.bluebyte.bluefire.api.extensions.IMessageExtension;

    public class CustomMessageVO extends MessageVO 
    {

        private var _bluebyte:Boolean;
        private var _communityLead:Boolean;

        public function CustomMessageVO(_arg_1:MessageVO)
        {
            var _local_3:IMessageExtension;
            super();
            this.room = _arg_1.room;
            this.clickable = _arg_1.clickable;
            this.groupMessage = _arg_1.groupMessage;
            this.important = _arg_1.important;
            this.moderator = _arg_1.moderator;
            this.ownname = _arg_1.ownname;
            this.receiver = _arg_1.receiver;
            this.sender = _arg_1.sender;
            this.text = _arg_1.text;
            this.time = _arg_1.time;
            var _local_2:Array = _arg_1.getAllExtensions();
            for each (_local_3 in _local_2)
            {
                this.addExtension(_local_3);
            };
        }

        public function set bluebyte(_arg_1:Boolean):void
        {
            this._bluebyte = _arg_1;
        }

        public function get communityLead():Boolean
        {
            return (this._communityLead);
        }

        public function get bluebyte():Boolean
        {
            return (this._bluebyte);
        }

        public function set communityLead(_arg_1:Boolean):void
        {
            this._communityLead = _arg_1;
        }


    }
}
