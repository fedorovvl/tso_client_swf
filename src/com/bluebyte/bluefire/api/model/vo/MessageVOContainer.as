package com.bluebyte.bluefire.api.model.vo
{
    public class MessageVOContainer 
    {

        private var _messageVO:MessageVO;

        public function MessageVOContainer(_arg_1:MessageVO)
        {
            super();
            this._messageVO = _arg_1;
        }

        public function set message(_arg_1:MessageVO):void
        {
            this._messageVO = _arg_1;
        }

        public function get message():MessageVO
        {
            return (this._messageVO);
        }


    }
}
