package Skill
{
    import flash.geom.Point;
    import mx.collections.ArrayCollection;
    import __AS3__.vec.Vector;
    import Modifier.ModifierVO;
    import nLib.cLog;
    import nLib.cXML;
    import __AS3__.vec.*;

    public class SkillDefinition 
    {

        public static const TYPE_BRONZE:String = "bronze";
        public static const TYPE_SILVER:String = "silver";
        public static const TYPE_GOLD:String = "gold";
        public static const BRONZE_COLOR:uint = 13408108;
        public static const SILVER_COLOR:uint = 11450812;
        public static const GOLD_COLOR:uint = 16111192;
        public static const BRONZE_RESOURCE:String = "Manuscript";
        public static const SILVER_RESOURCE:String = "Tome";
        public static const GOLD_RESOURCE:String = "Codex";

        public var concerningResource_string:String;
        public var name_string:String;
        public var minimumLevel:int;
        public var icon_string:String;
        public var id:int;
        public var position:Point;
        public var conceringColor:uint;
        public var skillPointType_string:String;
        public var numPointsAccumulated:int;

        public var unlockedTreeItemIds:ArrayCollection = new ArrayCollection();
        public var pointsAccumulatedReferenceIds:ArrayCollection = new ArrayCollection();
        public var level_vector:Vector.<Vector.<ModifierVO>> = new Vector.<Vector.<ModifierVO>>();
        public var arrows:ArrayCollection = new ArrayCollection();


        public static function getByID(_arg_1:int):SkillDefinition
        {
            var _local_4:Vector.<SkillDefinition>;
            var _local_5:int;
            var _local_2:Vector.<SkillTreeDefinition> = global.skillTrees_vector;
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                _local_4 = _local_2[_local_3].items_vector;
                _local_5 = 0;
                while (_local_5 < _local_4.length)
                {
                    if (_local_4[_local_5].id == _arg_1)
                    {
                        return (_local_4[_local_5]);
                    };
                    _local_5++;
                };
                _local_3++;
            };
            cLog.warning(("Unknown Skill defintion: " + _arg_1));
            return (null);
        }

        public static function getByName(_arg_1:String):SkillDefinition
        {
            var _local_4:Vector.<SkillDefinition>;
            var _local_5:int;
            var _local_2:Vector.<SkillTreeDefinition> = global.skillTrees_vector;
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                _local_4 = _local_2[_local_3].items_vector;
                _local_5 = 0;
                while (_local_5 < _local_4.length)
                {
                    if (_local_4[_local_5].name_string == _arg_1)
                    {
                        return (_local_4[_local_5]);
                    };
                    _local_5++;
                };
                _local_3++;
            };
            cLog.warning(("Unknown Skill defintion: " + _arg_1));
            return (null);
        }

        public static function getColorByType(_arg_1:String):uint
        {
            if (_arg_1 == SkillDefinition.TYPE_BRONZE)
            {
                return (BRONZE_COLOR);
            };
            if (_arg_1 == SkillDefinition.TYPE_SILVER)
            {
                return (SILVER_COLOR);
            };
            if (_arg_1 == SkillDefinition.TYPE_GOLD)
            {
                return (GOLD_COLOR);
            };
            return (0);
        }

        public static function CreateFromXML(_arg_1:cXML):SkillDefinition
        {
            var _local_3:Vector.<cXML>;
            var _local_4:cXML;
            var _local_5:cXML;
            var _local_6:cXML;
            var _local_7:cXML;
            var _local_8:Vector.<ModifierVO>;
            var _local_2:SkillDefinition = new (SkillDefinition)();
            _local_2.name_string = _arg_1.GetAttributeString_string("name");
            _local_2.id = _arg_1.GetAttributeInt("id");
            if (_arg_1.HasSubNode("requirements"))
            {
                _local_5 = _arg_1.MoveToSubNode("requirements");
                _local_6 = _local_5.MoveToSubNode("minimumLevel");
                _local_2.minimumLevel = _local_6.GetAttributeInt("level");
                _local_6 = _local_5.MoveToSubNode("skillPointType");
                _local_2.skillPointType_string = _local_6.GetAttributeString_string("type");
                _local_2.concerningResource_string = getResourceByType_string(_local_2.skillPointType_string);
                _local_2.conceringColor = getColorByType(_local_2.skillPointType_string);
                if (_local_5.HasSubNode("unlockedSkills"))
                {
                    _local_6 = _local_5.MoveToSubNode("unlockedSkills");
                    _local_3 = _local_6.CreateChildrenArray();
                    for each (_local_4 in _local_3)
                    {
                        _local_2.unlockedTreeItemIds.addItem(_local_4.GetAttributeInt("id"));
                    };
                };
                if (_local_5.HasSubNode("pointsAccumulated"))
                {
                    _local_6 = _local_5.MoveToSubNode("pointsAccumulated");
                    _local_2.numPointsAccumulated = _local_6.GetAttributeInt("amount");
                    _local_3 = _local_6.CreateChildrenArray();
                    for each (_local_4 in _local_3)
                    {
                        _local_2.pointsAccumulatedReferenceIds.addItem(_local_4.GetAttributeInt("id"));
                    };
                };
            };
            _local_5 = _arg_1.MoveToSubNode("levels");
            _local_3 = _local_5.CreateChildrenArray();
            for each (_local_7 in _local_3)
            {
                _local_8 = new Vector.<ModifierVO>();
                for each (_local_4 in _local_7.CreateChildrenArray())
                {
                    _local_8.push(ModifierVO.CreateFromXML(_local_4));
                };
                _local_2.level_vector.push(_local_8);
            };
            if (_arg_1.HasSubNode("layout"))
            {
                _local_5 = _arg_1.MoveToSubNode("layout");
                _local_6 = _local_5.MoveToSubNode("icon");
                _local_2.icon_string = _local_6.GetAttributeString_string("name");
                _local_6 = _local_5.MoveToSubNode("position");
                _local_2.position = new Point(_local_6.GetAttributeInt("x"), _local_6.GetAttributeInt("y"));
                _local_6 = _local_5.MoveToSubNode("arrows");
                _local_3 = _local_6.CreateChildrenArray();
                for each (_local_4 in _local_3)
                {
                    _local_2.arrows.addItem(_local_4.GetAttributeString_string("type"));
                };
            };
            return (_local_2);
        }

        public static function getResourceByType_string(_arg_1:String):String
        {
            if (_arg_1 == SkillDefinition.TYPE_BRONZE)
            {
                return (BRONZE_RESOURCE);
            };
            if (_arg_1 == SkillDefinition.TYPE_SILVER)
            {
                return (SILVER_RESOURCE);
            };
            if (_arg_1 == SkillDefinition.TYPE_GOLD)
            {
                return (GOLD_RESOURCE);
            };
            return (null);
        }


        public function toString():String
        {
            return (((((("<Skill id=" + this.id) + " name=") + this.name_string) + " minLvl: ") + this.minimumLevel) + ">");
        }


    }
}
