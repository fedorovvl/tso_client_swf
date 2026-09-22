package Communication.VO
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    public class dLandscapeVO 
    {

        public var name_string:String = null;
        public var grid:int;


        public function readExternal(_arg_1:IDataInput):void
        {
            this.name_string = _arg_1.readUTF();
            this.grid = _arg_1.readInt();
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeUTF(this.name_string);
            _arg_1.writeInt(this.grid);
        }

        public function toString():String
        {
            var _local_1:String = ("<dLandscapeVO name='" + this.name_string);
            _local_1 = (_local_1 + ("' grid='" + this.grid));
            return (_local_1 + "' />");
        }


    }
}
