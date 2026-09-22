package Communication.VO
{
    public class HandShakeVO 
    {

        public var chatPassword:String;
        public var chatConnection:String;
        public var chatName:String;


        public function toString():String
        {
            return ((((("chatName:" + this.chatName) + " chatPassword:") + this.chatPassword) + " chatConnection:") + this.chatConnection);
        }


    }
}
