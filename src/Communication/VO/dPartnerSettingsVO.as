package Communication.VO
{
    public class dPartnerSettingsVO 
    {

        public var hideShareAchievement:Boolean;
        public var hideInviteByMail:Boolean;
        public var hideLogout:Boolean;
        public var hideFullScreen:Boolean;

        public function dPartnerSettingsVO(_arg_1:Boolean, _arg_2:Boolean, _arg_3:Boolean, _arg_4:Boolean)
        {
            super();
            this.hideFullScreen = _arg_1;
            this.hideLogout = _arg_2;
            this.hideInviteByMail = _arg_3;
            this.hideShareAchievement = _arg_4;
        }

    }
}
