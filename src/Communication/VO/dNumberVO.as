package Communication.VO
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    public class dNumberVO 
    {

        public var value:Number;


        public function readExternal(_arg_1:IDataInput):void
        {
            this.value = _arg_1.readDouble();
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeDouble(this.value);
        }

        public function toString():String
        {
            return (("<dNumberVO value='" + this.value) + "' />");
        }


    }
}
