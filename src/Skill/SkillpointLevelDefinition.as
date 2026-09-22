package Skill
{
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import nLib.cXML;
    import __AS3__.vec.*;

    public class SkillpointLevelDefinition 
    {

        public var costs:Vector.<dResource> = new Vector.<dResource>();
        public var amountProduced:int;
        public var productionTime:int;


        public static function CreateFromXML(_arg_1:cXML):SkillpointLevelDefinition
        {
            var _local_2:SkillpointLevelDefinition = new (SkillpointLevelDefinition)();
            _local_2.amountProduced = _arg_1.GetAttributeInt("amountProduced");
            _local_2.productionTime = (_arg_1.GetAttributeInt("productionTime") * 1000);
            _local_2.costs = gParse.ParseCosts(_arg_1);
            return (_local_2);
        }


    }
}
