package Communication.VO
{
    public class CombatKillStatsVO 
    {

        public var initial:int = 0;
        public var lost:int = 0;
        public var killed:int = 0;
        public var unitType:String = null;


        public static function Create(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:int):CombatKillStatsVO
        {
            var _local_5:CombatKillStatsVO = new (CombatKillStatsVO)();
            _local_5.unitType = _arg_1;
            _local_5.initial = _arg_2;
            _local_5.killed = _arg_3;
            _local_5.lost = _arg_4;
            return (_local_5);
        }


        public function toString():String
        {
            return (((((((('<CombatKillStatsVO unitType="' + this.unitType) + '" initial="') + this.initial) + '" killed="') + this.killed) + '" lost="') + this.lost) + '" />');
        }


    }
}
