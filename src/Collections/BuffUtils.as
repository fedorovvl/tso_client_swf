package Collections
{
    import Communication.VO.dBuffVO;
    import BuffSystem.cBuff;
    import Communication.VO.dUniqueID;

    public class BuffUtils 
    {


        public static function createResourceBuffVO(_arg_1:String, _arg_2:int):dBuffVO
        {
            if (_arg_2 == 0)
            {
                return (null);
            };
            var _local_3:dBuffVO = new dBuffVO();
            _local_3.buffName_string = defines.ADD_RESOURCE_BUFF;
            _local_3.recurringChance = 0;
            _local_3.resourceName_string = _arg_1;
            _local_3.amount = _arg_2;
            return (_local_3);
        }

        public static function createBuff(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:String, _arg_5:dUniqueID):cBuff
        {
            var _local_6:dBuffVO = new dBuffVO();
            _local_6.buffName_string = _arg_1;
            _local_6.amount = _arg_2;
            _local_6.resourceName_string = _arg_4;
            _local_6.uniqueId1 = _arg_5.uniqueID1;
            _local_6.uniqueId2 = _arg_5.uniqueID2;
            return (cBuff.CreateBuffFromVO(_local_6));
        }


    }
}
