package Communication.VO
{
    public class dUniqueID 
    {

        public var uniqueID1:int = 0;
        public var uniqueID2:int = 0;


        public static function isEmpty(_arg_1:dUniqueID):Boolean
        {
            return ((_arg_1 == null) || ((_arg_1.uniqueID1 == 0) && (_arg_1.uniqueID2 == 0)));
        }

        public static function Create(_arg_1:int, _arg_2:int):dUniqueID
        {
            var _local_3:dUniqueID = new (dUniqueID)();
            _local_3.uniqueID1 = _arg_1;
            _local_3.uniqueID2 = _arg_2;
            return (_local_3);
        }


        public function Init(_arg_1:int, _arg_2:int):dUniqueID
        {
            this.uniqueID1 = _arg_1;
            this.uniqueID2 = _arg_2;
            return (this);
        }

        public function greater(_arg_1:dUniqueID):Boolean
        {
            return ((this.uniqueID2 > _arg_1.uniqueID2) || ((_arg_1.uniqueID2 == this.uniqueID2) && (this.uniqueID1 > _arg_1.uniqueID1)));
        }

        public function toKeyString():String
        {
            return ((this.uniqueID1 + ".") + this.uniqueID2);
        }

        public function toString():String
        {
            return (((("<dUniqueID='" + this.uniqueID1) + ":") + this.uniqueID2) + "'/>");
        }

        public function eq(_arg_1:dUniqueID):Boolean
        {
            return (((!(_arg_1 == null)) && (_arg_1.uniqueID1 == this.uniqueID1)) && (_arg_1.uniqueID2 == this.uniqueID2));
        }

        public function equals(_arg_1:Object):Boolean
        {
            return (this.eq((_arg_1 as dUniqueID)));
        }


    }
}
