package Communication.VO
{
    import MilitarySystem.cMilitaryUnitData;
    import Enums.COMMAND;

    public class CombatCommandVO 
    {

        public var value:String;
        public var generalUniqueId:dUniqueID;
        public var commandId:int;


        public static function Create(_arg_1:dUniqueID, _arg_2:int, _arg_3:String):CombatCommandVO
        {
            var _local_4:CombatCommandVO = new (CombatCommandVO)();
            _local_4.generalUniqueId = _arg_1;
            _local_4.commandId = _arg_2;
            _local_4.value = _arg_3;
            return (_local_4);
        }


        public function toString():String
        {
            return (((("<CombatCommandVO commandId='" + this.commandId) + "' value='") + ((this.value != null) ? this.value : "null")) + "' />");
        }

        public function IsValid():Boolean
        {
            return (((this.commandId == COMMAND.COMBAT_UNIT_SWITCH) && (!(this.value == null))) && (!(cMilitaryUnitData.GetUnitDataForType(this.value) == null)));
        }


    }
}
