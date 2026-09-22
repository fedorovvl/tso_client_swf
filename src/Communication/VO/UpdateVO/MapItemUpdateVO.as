package Communication.VO.UpdateVO
{
    import Communication.VO.dUniqueID;

    public class MapItemUpdateVO 
    {

        public var uniqueId:dUniqueID;
        public var mapLevel:int;


        public static function Create(_arg_1:dUniqueID, _arg_2:int):MapItemUpdateVO
        {
            var _local_3:MapItemUpdateVO = new (MapItemUpdateVO)();
            _local_3.uniqueId = _arg_1;
            _local_3.mapLevel = _arg_2;
            return (_local_3);
        }


        public function toString():String
        {
            var _local_1:* = "<MapItemUpdateVO ";
            _local_1 = (_local_1 + (("uniqueId1='" + this.uniqueId.uniqueID1) + "' "));
            _local_1 = (_local_1 + (("uniqueId2='" + this.uniqueId.uniqueID2) + "' "));
            _local_1 = (_local_1 + (("mapLevel='" + this.mapLevel) + "' "));
            return (_local_1 + "/>");
        }


    }
}
