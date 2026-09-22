package Communication.VO
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    public class dBackgroundTileVO 
    {

        public var name_string:String = null;


        public function readExternal(_arg_1:IDataInput):void
        {
            this.name_string = _arg_1.readUTF();
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeUTF(this.name_string);
        }

        public function toString():String
        {
            return (("<dBackgroundTileVO name='" + this.name_string) + "' />");
        }


    }
}
