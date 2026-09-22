package GUI.Events
{
    import flash.events.KeyboardEvent;
    import Communication.VO.dPlayerListItemVO;

    public class MailRecipientEvent extends KeyboardEvent 
    {

        public static const RECIPIENT_ENTERED:String = "recipientEntered";
        public static const SPECIAL_KEY_PRESS:String = "specialKeyPress";
        public static const FOCUS_OUT:String = "recipientFocusOut";
        public static const FOCUS_IN:String = "inputFocusIn";
        public static const DELETE_RECIPIENT:String = "deleteRecipient";

        public var recipientVO:dPlayerListItemVO;
        public var recipientName:String;
        public var charLength:int;

        public function MailRecipientEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

    }
}
