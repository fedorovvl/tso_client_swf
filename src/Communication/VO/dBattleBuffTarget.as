package Communication.VO
{
    import Utils.StringUtils;
    import nLib.gMisc;

    public class dBattleBuffTarget 
    {

        public var max:int;
        public var combatantType:String;
        public var min:int;
        public var unitType:String;


        public function isCombatantType():Boolean
        {
            return (!(StringUtils.isEmpty(this.combatantType)));
        }

        public function isRandomUnit():Boolean
        {
            return (StringUtils.equalsIgnoreCase(this.unitType, "RANDOM"));
        }

        public function isTargetingAllUnits():Boolean
        {
            return ((this.min == -1) && (this.max == -1));
        }

        public function getNumUnitsToTarget(_arg_1:int, _arg_2:int):int
        {
            var _local_3:int;
            var _local_4:int;
            if (this.isTargetingAllUnits())
            {
                return (_arg_1);
            };
            _local_4 = Math.min(this.max, _arg_1);
            if (_local_4 == -1)
            {
                _local_4 = _arg_1;
            };
            _local_3 = this.getMin();
            return (gMisc.getPseudoRandomMinMax(_arg_2, _local_3, _local_4));
        }

        public function getMin():int
        {
            return (Math.max(1, this.min));
        }


    }
}
