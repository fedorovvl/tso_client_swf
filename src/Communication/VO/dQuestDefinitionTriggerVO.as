package Communication.VO
{
    import mx.collections.ArrayCollection;
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;

    public class dQuestDefinitionTriggerVO 
    {

        public var name_string:String;
        public var onComplete_string:String;
        public var resourceType_string:String;
        public var showAsPercentage:Boolean;
        public var time:int;
        public var amount:int;
        public var locaExtension_string:String;
        public var condition:int;
        public var buildingUpgradeLevel:int;
        public var isFailTrigger:Boolean = false;
        public var unlockTooltipLoca_string:String;
        public var actionType_string:String;
        public var icon_string:String;
        public var startConditions_vector:ArrayCollection;
        public var triggerIdx:int;
        public var actionName_string:String;
        public var squadUnitType_string:String;
        public var type:int;


        public function toString():String
        {
            var _local_1:String = QuestManagerStatic.ConvertTypeToString(this.type);
            var _local_2:String = QuestManagerStatic.ConvertConditionToString(this.condition);
            return ((((((((_local_1 + ((_local_2 != "unset") ? ("_" + _local_2) : "")) + (((!(this.name_string == null)) && (!(this.name_string == ""))) ? ("_" + this.name_string) : "")) + (((!(this.actionName_string == null)) && (!(this.actionName_string == ""))) ? ("_" + this.actionName_string) : "")) + (((!(this.actionType_string == null)) && (!(this.actionType_string == ""))) ? ("_" + this.actionType_string) : "")) + (((!(this.resourceType_string == null)) && (!(this.resourceType_string == ""))) ? ("_" + this.resourceType_string) : "")) + (((!(this.squadUnitType_string == null)) && (!(this.squadUnitType_string == ""))) ? ("_" + this.squadUnitType_string) : "")) + (((!(this.locaExtension_string == null)) && (!(this.locaExtension_string == ""))) ? ("_" + this.locaExtension_string) : "")) + (((!(this.icon_string == null)) && (!(this.icon_string == ""))) ? ("_" + this.icon_string) : ""));
        }


    }
}
