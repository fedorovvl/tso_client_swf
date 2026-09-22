package Skill
{
    import __AS3__.vec.Vector;
    import nLib.cXML;
    import __AS3__.vec.*;

    public class SkillpointDefinition 
    {

        public var instantFinishCost:int;
        public var levels_vector:Vector.<SkillpointLevelDefinition> = new Vector.<SkillpointLevelDefinition>();
        public var id_string:String;
        public var resetCost:int;


        public static function CreateFromXML(_arg_1:cXML):SkillpointDefinition
        {
            var _local_4:cXML;
            var _local_2:SkillpointDefinition = new (SkillpointDefinition)();
            _local_2.id_string = _arg_1.GetAttributeString_string("id");
            _local_2.instantFinishCost = _arg_1.GetAttributeInt("instantFinishCost");
            _local_2.resetCost = _arg_1.GetAttributeInt("resetCost");
            var _local_3:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_4 in _local_3)
            {
                _local_2.levels_vector.push(SkillpointLevelDefinition.CreateFromXML(_local_4));
            };
            return (_local_2);
        }


    }
}
