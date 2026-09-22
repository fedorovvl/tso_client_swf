package ServerState
{
    import Communication.VO.dUniqueID;

    public interface LootHolder 
    {

        function hasActivePremiumAccount():Boolean;
        function GetPlayerId():int;
        function GetPlayerLevel():int;
        function GetNewUniqueID():dUniqueID;

    }
}
