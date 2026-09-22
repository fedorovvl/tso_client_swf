package MilitarySystem
{
    import Enums.MILITARY_UNIT_ABILITY;
    import nLib.cXML;

    public class cMilitaryUnitAbility 
    {

        private var mValue:int;
        private var mType:int;

        public function cMilitaryUnitAbility(_arg_1:int, _arg_2:int)
        {
            super();
            this.mType = _arg_1;
            this.mValue = _arg_2;
        }

        public static function create(_arg_1:cXML):cMilitaryUnitAbility
        {
            var _local_2:int = MILITARY_UNIT_ABILITY.parse(_arg_1.GetAttributeString_string("Type"));
            if (_local_2 > 0)
            {
                return (new cMilitaryUnitAbility(_local_2, _arg_1.GetAttributeInt("Value")));
            };
            return (null);
        }


        public function GetType():int
        {
            return (this.mType);
        }

        public function GetValue():int
        {
            return (this.mValue);
        }

        public function toString():String
        {
            return (((("<Ability" + MILITARY_UNIT_ABILITY.toString(this.GetType())) + ", Value=") + this.GetValue()) + ">");
        }


    }
}
