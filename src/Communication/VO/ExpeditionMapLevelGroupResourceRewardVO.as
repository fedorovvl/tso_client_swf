package Communication.VO
{
    public class ExpeditionMapLevelGroupResourceRewardVO 
    {

        public var duration:int = 0;
        public var amount:int = 0;
        public var resourceName:String = null;
        public var id:int = 0;


        public static function Create(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int):ExpeditionMapLevelGroupResourceRewardVO
        {
            var _local_5:ExpeditionMapLevelGroupResourceRewardVO = new (ExpeditionMapLevelGroupResourceRewardVO)();
            _local_5.id = _arg_1;
            _local_5.resourceName = _arg_2;
            _local_5.amount = _arg_3;
            _local_5.duration = _arg_4;
            return (_local_5);
        }


        public function GetDuration():int
        {
            return (this.duration);
        }

        public function toString():String
        {
            return (((((((('<ExpeditionMapLevelGroupResourceRewardVO id="' + this.id) + ' resourceName="') + this.resourceName) + '" amount="') + this.amount) + '" duration="') + this.duration) + '" />');
        }

        public function GetAmount():int
        {
            return (this.amount);
        }

        public function GetResourceName():String
        {
            return (this.resourceName);
        }


    }
}
