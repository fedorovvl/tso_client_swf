package Communication.VO
{
    import Enums.ERROR_CODES;

    public class dServerActionResult 
    {

        public var errorCode:int;
        public var clientTime:Number;
        public var data:Object;

        public function dServerActionResult(_arg_1:int=0, _arg_2:Object=null, _arg_3:Number=0)
        {
            super();
            this.errorCode = _arg_1;
            this.data = _arg_2;
            this.clientTime = _arg_3;
        }

        public function toString():String
        {
            return (((((("<dServerActionResult clientTime=" + this.clientTime) + " errorCode=") + ERROR_CODES.toString(this.errorCode)) + " data=") + this.data) + " >");
        }


    }
}
