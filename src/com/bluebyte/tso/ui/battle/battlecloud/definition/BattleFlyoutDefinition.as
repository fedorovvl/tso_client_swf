package com.bluebyte.tso.ui.battle.battlecloud.definition
{
    import com.bluebyte.tso.util.IRandomItem;
    import flash.xml.XMLNode;
    import flash.utils.Dictionary;

    public final class BattleFlyoutDefinition implements IRandomItem 
    {

        public var lifetime:int;
        public var chance:Number;
        public var name:String;
        public var condition:String;


        public static function fromXML(_arg_1:XMLNode):BattleFlyoutDefinition
        {
            var _local_2:BattleFlyoutDefinition = new (BattleFlyoutDefinition)();
            _local_2.name = _arg_1.attributes["name"];
            _local_2.chance = (Number(_arg_1.attributes["chance"]) / 100);
            _local_2.lifetime = ((_arg_1.attributes["lifetime"]) ? Math.max(1, int(_arg_1.attributes["lifetime"])) : 4);
            _local_2.condition = String(_arg_1.attributes["condition"]);
            return (_local_2);
        }


        public function getChance():Number
        {
            return (this.chance);
        }

        public function isConditionValid(_arg_1:Dictionary):Boolean
        {
            if (!this.condition)
            {
                return (true);
            };
            if (this.condition.charAt(0) == "!")
            {
                return (!(this.condition in _arg_1));
            };
            return (this.condition in _arg_1);
        }


    }
}
