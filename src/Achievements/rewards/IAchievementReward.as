package Achievements.rewards
{
    import nLib.cXML;
    import Interface.cGeneralInterface;
    import Communication.VO.dUniqueID;

    public interface IAchievementReward 
    {

        function init(_arg_1:cXML):void;
        function reward(_arg_1:cGeneralInterface, _arg_2:dUniqueID):void;

    }
}
