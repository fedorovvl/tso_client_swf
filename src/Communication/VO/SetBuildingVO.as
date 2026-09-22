package Communication.VO
{
    public class SetBuildingVO 
    {

        public var buildingUniqueId:dUniqueID;
        public var buffUniqueId:dUniqueID;


        public static function Init(_arg_1:dUniqueID):SetBuildingVO
        {
            var _local_2:SetBuildingVO = new (SetBuildingVO)();
            _local_2.buffUniqueId = _arg_1;
            return (_local_2);
        }


    }
}
