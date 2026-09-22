package TimedProduction
{
    import ServerState.cResources;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import Communication.VO.dTimedProductionVO;
    import GO.cBuilding;
    import ServerState.cPlayerData;
    import Interface.cGeneralInterface;
    import Interface.cGameInterface;

    public interface iProductionOrder 
    {

        function Pay(_arg_1:cResources):void;
        function GetOnFinishedAvatarMessageType():String;
        function GetInstantBuildCosts():int;
        function GetInstantBuildCostsUnmodified():int;
        function GetCostsToBuy_vector():Vector.<dResource>;
        function GetProductionVO():dTimedProductionVO;
        function GetDefinition():iTimedProductionDefinition;
        function GetBuilding():cBuilding;
        function GetProductionTime():int;
        function GetResourceName():String;
        function CanAfford(_arg_1:cResources):Boolean;
        function GetResourceAmount():int;
        function CreateItem(_arg_1:cPlayerData, _arg_2:cGeneralInterface, _arg_3:int):void;
        function IsProduceable(_arg_1:cGameInterface):Boolean;
        function GetTimeBonus():Number;

    }
}
