package Communication.VO
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    public class dDataIntStringVO 
    {

        public var value:int;
        public var string:String;
        public var _string:String;


        public function readExternal(_arg_1:IDataInput):void
        {
            this._string = _arg_1.readUTF();
            this.value = _arg_1.readInt();
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeUTF(this._string);
            _arg_1.writeInt(this.value);
        }

        public function toString():String
        {
            return (((("<dDataIntStringVO string='" + this.string) + "' value='") + this.value) + "' />");
        }


    }
}
