package Communication.VO
{
    import mx.collections.ArrayCollection;
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;

    public class dQuestDefinitionVO 
    {

        public var questName_string:String;
        public var questTriggers_vector:ArrayCollection;
        public var questHints:ArrayCollection;
        public var dailyMotherQuest:dQuestDefinitionVO = null;
        public var endConditions_vector:ArrayCollection;
        public var connectedToQuest_string:String;
        public var notifyHomeZone:Boolean;
        public var icon_string:String;
        public var showRewardWindow:Boolean;
        public var preEffects_vector:ArrayCollection;
        public var questPostrequisits:ArrayCollection;
        public var failConditions_vector:ArrayCollection;
        public var npc_string:String;
        public var questReward:ArrayCollection;
        public var showQuestWindow:Boolean;
        public var type_string:String;
        public var failConditionsFailAdventure:Boolean;
        public var specialType_string:String;
        public var helpEffects_vector:ArrayCollection;
        public var helpName_string:String;
        public var questTriggerTypes_map:Object;
        public var questTyp:int = QuestManagerStatic.QUEST_TYPE_DEFAULT;
        public var colorSchema_string:String;
        public var linkEventWindow:Boolean;
        public var cancelable:Boolean;
        public var postEffects_vector:ArrayCollection;
        public var failEffects_vector:EffectListVO;
        public var startConditions_vector:ArrayCollection;
        public var previousQuestDefinition:dQuestDefinitionVO;
        public var questWinGemCosts:int;
        public var repeatable:Boolean;


        public function FindTriggerWithType(_arg_1:int):int
        {
            if ((_arg_1 in this.questTriggerTypes_map))
            {
                return (this.questTriggerTypes_map[_arg_1]);
            };
            return (-1);
        }

        public function toString():String
        {
            return (("<dQuestDefinitionVO name='" + this.questName_string) + "' />");
        }


    }
}
