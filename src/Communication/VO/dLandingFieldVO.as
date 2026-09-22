package Communication.VO
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    public class dLandingFieldVO 
    {

        public var id:int;
        public var grid:int;


        public function readExternal(_arg_1:IDataInput):void
        {
            this.grid = _arg_1.readInt();
            this.id = _arg_1.readInt();
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeInt(this.grid);
            _arg_1.writeInt(this.id);
        }

        public function toString():String
        {
            var _local_1:String = ("<dLandingFieldVO grid='" + this.grid);
            _local_1 = (_local_1 + ("' id='" + this.id));
            return (_local_1 + "' />");
        }


    }
}
