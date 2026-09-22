package converted.bluebyte.tso.quests.logic
{
    import Communication.VO.dQuestDefinitionVO;
    import Communication.VO.dQuestElementVO;
    import Communication.VO.dUniqueID;
    import Utils.HashMapWrapper;
    import Communication.VO.dQuestPoolVO;

    public interface IQuestManager 
    {

        function startQuest(_arg_1:dQuestDefinitionVO, _arg_2:int):void;
        function cleanUpQuestNew(_arg_1:String, _arg_2:String):void;
        function hasQuest(_arg_1:String):Boolean;
        function getQuest(_arg_1:String):dQuestElementVO;
        function getQuestByUID(_arg_1:dUniqueID):dQuestElementVO;
        function cancelQuest(_arg_1:String, _arg_2:String):void;
        function resetQuest(_arg_1:String, _arg_2:int):void;
        function GetCompletedAdventureSquads():HashMapWrapper;
        function finishQuest(_arg_1:String):void;
        function GetQuestPool():dQuestPoolVO;
        function cleanUpQuest(_arg_1:String, _arg_2:String):void;

    }
}
