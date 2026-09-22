package Communication.VO
{
    public class ExpeditionMapLevelGroupCostVO 
    {

        public var resourceType:String = null;
        public var amount:int = 0;


        public static function Create(_arg_1:String, _arg_2:int):ExpeditionMapLevelGroupCostVO
        {
            var _local_3:ExpeditionMapLevelGroupCostVO = new (ExpeditionMapLevelGroupCostVO)();
            _local_3.resourceType = _arg_1;
            _local_3.amount = _arg_2;
            return (_local_3);
        }


        public function toString():String
        {
            return (((('<ExpeditionMapLevelGroupCostVO resourceType="' + this.resourceType) + '" amount="') + this.amount) + '" />');
        }


    }
}
