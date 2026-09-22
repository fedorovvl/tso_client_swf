package MilitarySystem
{
    import Communication.VO.dSpecialCombatPreviewVO;

    public class cSpecialCombatPreview 
    {

        private var combatPreviewText_string:String;
        private var unitType_string:String;
        private var amount:int;


        public function getCombatPreviewText_string():String
        {
            return (this.combatPreviewText_string);
        }

        public function GetUnitType():String
        {
            return (this.unitType_string);
        }

        public function createVO():dSpecialCombatPreviewVO
        {
            return (new dSpecialCombatPreviewVO().init(this.unitType_string, this.amount, this.combatPreviewText_string));
        }

        public function isValid(_arg_1:cArmy):Boolean
        {
            var _local_2:cSquad;
            for each (_local_2 in _arg_1.GetSquads_vector())
            {
                if (_local_2.name_string == this.unitType_string)
                {
                    if (_local_2.amount > this.amount)
                    {
                        return (true);
                    };
                    return (false);
                };
            };
            return (false);
        }

        public function GetUnitCount():int
        {
            return (this.amount);
        }

        public function createFromVO(_arg_1:dSpecialCombatPreviewVO):cSpecialCombatPreview
        {
            this.unitType_string = _arg_1.unitType_string;
            this.amount = _arg_1.amount;
            this.combatPreviewText_string = _arg_1.combatPreviewText_string;
            return (this);
        }


    }
}
