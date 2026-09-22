package TimedProduction
{
    import __AS3__.vec.Vector;
    import ServerState.dResource;

    public interface iTimedProductionDefinition 
    {

        function GetType():String;
        function IsProducible():Boolean;
        function GetCosts_vector():Vector.<dResource>;
        function GetInstantBuildCosts():int;
        function GetProductionName_string():String;
        function GetProductionAmount():int;
        function GetProductionSourceName_string():String;
        function GetProductionTime():int;

    }
}
