package Modifier
{
    import mx.collections.ArrayCollection;
    import Enums.SPECIALIST_TASK_TYPES;
    import nLib.cXML;
    import Communication.VO.EffectVO;

    public final class ModifierVO 
    {

        public var multiplier:Number;
        public var channel:String;
        public var name_string:String;
        public var adder:int;
        public var type_string:String;
        public var rules_string:String;
        public var effects_vector:ArrayCollection = new ArrayCollection();
        public var value:int;
        public var concernedTasks_vector:ArrayCollection = new ArrayCollection();
        public var chance:Number;
        public var id_string:String;
        public var modifier_string:String;
        public var property_string:String;
        public var replace_string:String;
        public var item_string:String;


        private static function parseTaskIDs(_arg_1:String):ArrayCollection
        {
            var _local_3:String;
            var _local_2:ArrayCollection = new ArrayCollection();
            for each (_local_3 in _arg_1.split(","))
            {
                _local_2.addItem(SPECIALIST_TASK_TYPES.parseOldTaskName(_local_3));
            };
            return (_local_2);
        }

        public static function CreateFromXML(_arg_1:cXML):ModifierVO
        {
            var _local_3:cXML;
            var _local_2:ModifierVO = new (ModifierVO)();
            _local_2.modifier_string = _arg_1.GetName_string();
            _local_2.id_string = _arg_1.GetAttributeString_string("id");
            _local_2.rules_string = _arg_1.GetAttributeString_string("rules");
            _local_2.property_string = _arg_1.GetAttributeString_string("property");
            _local_2.channel = _arg_1.GetAttributeString_string("channel");
            _local_2.chance = _arg_1.GetAttributeFloatingPoint("chance", 1);
            _local_2.type_string = _arg_1.GetAttributeString_string("type");
            _local_2.item_string = _arg_1.GetAttributeString_string("item");
            _local_2.name_string = _arg_1.GetAttributeString_string("name");
            _local_2.replace_string = _arg_1.GetAttributeString_string("replace");
            _local_2.adder = _arg_1.GetAttributeInt("adder");
            _local_2.multiplier = _arg_1.GetAttributeFloatingPoint("multiplier", 1);
            _local_2.value = _arg_1.GetAttributeInt("value");
            if (((_local_2.rules_string.toLowerCase().indexOf("effect") >= 0) || (_local_2.rules_string.toLowerCase().indexOf("loot") >= 0)))
            {
                for each (_local_3 in _arg_1.CreateChildrenArray())
                {
                    _local_2.effects_vector.addItem(EffectVO.CreateFromXML(_local_3));
                };
            };
            _local_2.concernedTasks_vector = parseTaskIDs(_local_2.type_string);
            return (_local_2);
        }


        public function toString():String
        {
            return (((((((((((((((((((((((((("<" + this.modifier_string) + " id='") + this.id_string) + "' rules='") + this.rules_string) + "' property='") + this.property_string) + "' channel='") + this.channel) + "' chance='") + this.chance) + "' type='") + this.type_string) + "' item='") + this.item_string) + "' name='") + this.name_string) + "' replace='") + this.replace_string) + "' adder='") + this.adder) + "' multiplier='") + this.multiplier) + "' value='") + this.value) + "' />");
        }


    }
}
