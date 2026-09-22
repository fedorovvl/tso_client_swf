package Communication.VO.UpdateVO
{
    public class dAlertMessageVO 
    {

        public var intData:int;
        public var alertMessage:String;


        public function Init(_arg_1:String, _arg_2:int):dAlertMessageVO
        {
            this.alertMessage = _arg_1;
            this.intData = _arg_2;
            return (this);
        }

        public function toString():String
        {
            return (((("<dAlertMessageVO alertMessage='" + this.alertMessage) + "' intData='") + this.intData) + "' />");
        }


    }
}
