package Communication.VO
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    public class dFreeLandscapeVO 
    {

        public var name_string:String = null;
        public var x:int;
        public var y:int;


        public function readExternal(_arg_1:IDataInput):void
        {
            this.name_string = _arg_1.readUTF();
            this.x = _arg_1.readInt();
            this.y = _arg_1.readInt();
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeUTF(this.name_string);
            _arg_1.writeInt(this.x);
            _arg_1.writeInt(this.y);
        }

        public function toString():String
        {
            var _local_1:String = ("<dLandscapeVO name='" + this.name_string);
            _local_1 = (_local_1 + ("' x='" + this.x));
            _local_1 = (_local_1 + ("' y='" + this.y));
            return (_local_1 + "' />");
        }


    }
}
