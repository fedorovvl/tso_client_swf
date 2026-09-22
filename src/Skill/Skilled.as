package Skill
{
    import Communication.VO.dUniqueID;
    import Model.Notifier;

    public interface Skilled 
    {

        function getName(_arg_1:Boolean):String;
        function getPlayerID():int;
        function getOwnerType():int;
        function getOwnerID():dUniqueID;
        function getSkillTree():cSkillTree;
        function getIconID():String;
        function getNotifier():Notifier;
        function setSkillTree(_arg_1:cSkillTree):void;

    }
}
