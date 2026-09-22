package Communication.VO.avatarSelection
{
    import Communication.VO.HandShakeVO;

    public class UpdateUsernameAndAvatarVO 
    {

        public var changeSuccessful:Boolean;
        public var handShakeVO:HandShakeVO;
        public var isUsernameUpdateOnly:Boolean = false;
        public var username:String;
        public var errorMessageId:String;
        public var avatarId:int;
        public var localizedDomain:String;


        public function init(_arg_1:String, _arg_2:int, _arg_3:String, _arg_4:Boolean):UpdateUsernameAndAvatarVO
        {
            this.username = _arg_1;
            this.avatarId = _arg_2;
            this.localizedDomain = _arg_3;
            this.isUsernameUpdateOnly = _arg_4;
            return (this);
        }


    }
}
