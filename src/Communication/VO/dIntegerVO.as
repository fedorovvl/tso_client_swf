package Communication.VO
{
    public class dIntegerVO 
    {

        public var value:int;

        public function dIntegerVO(_arg_1:int=0)
        {
            super();
            this.value = _arg_1;
        }

        public function toString():String
        {
            return (("<dIntegerVO value='" + this.value) + "' />");
        }


    }
}
