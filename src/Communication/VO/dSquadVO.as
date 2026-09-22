package Communication.VO
{
    import MilitarySystem.cMilitaryUnitBase;
    import MilitarySystem.cMilitaryUnitDescription;
    import MilitarySystem.cMilitaryUnitData;

    public class dSquadVO 
    {

        private var militaryUnitBase:cMilitaryUnitBase;
        public var name_string:String;
        public var type_int:int;
        public var mTotalHealth:int = 0;
        public var amount:int;
        public var currentHitPoints:int;


        public static function Create(_arg_1:String, _arg_2:int, _arg_3:int):dSquadVO
        {
            var _local_4:dSquadVO = new (dSquadVO)();
            _local_4.init(_arg_1, _arg_2, _arg_3);
            return (_local_4);
        }


        public function GetType():String
        {
            return (this.GetUnitBase().GetType());
        }

        public function GetUnitDescription():cMilitaryUnitDescription
        {
            return (this.GetUnitBase() as cMilitaryUnitDescription);
        }

        public function GetCurrentHitPoints():int
        {
            return (this.currentHitPoints);
        }

        public function GetAmount():int
        {
            return (this.amount);
        }

        public function GetUnitBase():cMilitaryUnitBase
        {
            if (this.militaryUnitBase == null)
            {
                this.militaryUnitBase = cMilitaryUnitBase.GetUnitBaseForType(this.name_string);
            };
            return (this.militaryUnitBase);
        }

        public function IsCombat3():Boolean
        {
            return (this.militaryUnitBase is cMilitaryUnitData);
        }

        public function init(_arg_1:String, _arg_2:int, _arg_3:int):dSquadVO
        {
            this.amount = _arg_2;
            this.currentHitPoints = _arg_3;
            this.name_string = _arg_1;
            this.militaryUnitBase = cMilitaryUnitBase.GetUnitBaseForType(_arg_1);
            return (this);
        }

        public function GetUnitData():cMilitaryUnitData
        {
            return (this.GetUnitBase() as cMilitaryUnitData);
        }

        public function SetCurrentHitPoints(_arg_1:int):void
        {
            this.currentHitPoints = _arg_1;
        }


    }
}
