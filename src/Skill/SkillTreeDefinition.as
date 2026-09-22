package Skill
{
    import __AS3__.vec.Vector;
    import nLib.cLog;
    import nLib.cXML;
    import __AS3__.vec.*;

    public class SkillTreeDefinition 
    {

        public var items_vector:Vector.<SkillDefinition> = new Vector.<SkillDefinition>();
        public var name_string:String;
        public var maxPoints:int;
        public var id:int;


        public static function getByName(_arg_1:String):SkillTreeDefinition
        {
            var _local_2:Vector.<SkillTreeDefinition> = global.skillTrees_vector;
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (_local_2[_local_3].name_string == _arg_1)
                {
                    return (_local_2[_local_3]);
                };
                _local_3++;
            };
            cLog.warning(("Unknown Skill Tree defintion (name): " + _arg_1));
            return (new (SkillTreeDefinition)());
        }

        public static function nameToID(_arg_1:String):int
        {
            var _local_2:Vector.<SkillTreeDefinition> = global.skillTrees_vector;
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (_local_2[_local_3].name_string == _arg_1)
                {
                    return (_local_2[_local_3].id);
                };
                _local_3++;
            };
            if (cLog.isInfoEnabled())
            {
                if (_arg_1.length > 0)
                {
                    cLog.info(("No Skill Tree defintion for " + _arg_1));
                };
            };
            return (0);
        }

        public static function CreateFromXML(_arg_1:cXML):SkillTreeDefinition
        {
            var _local_4:cXML;
            var _local_5:int;
            var _local_6:SkillDefinition;
            var _local_2:SkillTreeDefinition = new (SkillTreeDefinition)();
            _local_2.name_string = _arg_1.GetAttributeString_string("name");
            _local_2.id = _arg_1.GetAttributeInt("id");
            _local_2.maxPoints = _arg_1.GetAttributeInt("maxPoints");
            var _local_3:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_4 in _local_3)
            {
                _local_5 = _local_4.GetAttributeInt("id");
                _local_6 = global.skills_vector[_local_5];
                if (((!(_local_6 == null)) && (_local_6.id == _local_5)))
                {
                    _local_2.items_vector.push(_local_6);
                }
                else
                {
                    throw (new Error(("Couldn't find referenced skill in skilltree! ID= " + _local_5)));
                };
            };
            return (_local_2);
        }

        public static function getByID(_arg_1:int):SkillTreeDefinition
        {
            var _local_2:Vector.<SkillTreeDefinition> = global.skillTrees_vector;
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (_local_2[_local_3].id == _arg_1)
                {
                    return (_local_2[_local_3]);
                };
                _local_3++;
            };
            cLog.warning(("Unknown Skill Tree defintion (id): " + _arg_1));
            return (new (SkillTreeDefinition)());
        }


    }
}
