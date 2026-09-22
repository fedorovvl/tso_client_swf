package Communication.VO
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    public class dServerAction 
    {

        public var endGrid:int;
        public var grid:int;
        public var data:Object;
        public var type:int;


        public static function create(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:Object):dServerAction
        {
            var _local_5:dServerAction = new (dServerAction)();
            _local_5.type = _arg_1;
            _local_5.grid = _arg_2;
            _local_5.endGrid = _arg_3;
            _local_5.data = _arg_4;
            return (_local_5);
        }


        public function readExternal(_arg_1:IDataInput):void
        {
            this.type = _arg_1.readInt();
            this.grid = _arg_1.readInt();
            this.endGrid = _arg_1.readInt();
            this.data = _arg_1.readObject();
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeInt(this.type);
            _arg_1.writeInt(this.grid);
            _arg_1.writeInt(this.endGrid);
            _arg_1.writeObject(this.data);
        }

        public function toString():String
        {
            return (((((((("<dServerAction type='" + this.type) + "' grid='") + this.grid) + "' endGrid='") + this.endGrid) + "' data='") + this.data) + "' />");
        }


    }
}
