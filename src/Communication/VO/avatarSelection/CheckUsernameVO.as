package Communication.VO.avatarSelection
{
    public class CheckUsernameVO 
    {

        public var username:String;
        public var errorMessageId:String;
        public var checkOK:Boolean;


        public function init(_arg_1:String):CheckUsernameVO
        {
            this.username = _arg_1;
            return (this);
        }

        public function populate(_arg_1:Boolean, _arg_2:String):void
        {
            this.checkOK = _arg_1;
            this.errorMessageId = _arg_2;
        }


    }
}
