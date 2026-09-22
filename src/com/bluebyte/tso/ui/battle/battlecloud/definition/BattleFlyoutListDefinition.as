package com.bluebyte.tso.ui.battle.battlecloud.definition
{
    import __AS3__.vec.Vector;
    import flash.xml.XMLNode;
    import nLib.cXML;
    import __AS3__.vec.*;

    public final class BattleFlyoutListDefinition 
    {

        public var items:Vector.<BattleFlyoutDefinition> = new Vector.<BattleFlyoutDefinition>();
        public var event:String;


        public static function fromXML(_arg_1:XMLNode):BattleFlyoutListDefinition
        {
            var _local_3:XMLNode;
            var _local_2:BattleFlyoutListDefinition = new (BattleFlyoutListDefinition)();
            for each (_local_3 in cXML.getChildNodes(_arg_1, "spawn"))
            {
                _local_2.items.push(BattleFlyoutDefinition.fromXML(_local_3));
            };
            _local_2.event = ((_arg_1.attributes["requiresEvent"]) ? _arg_1.attributes["requiresEvent"] : "");
            return (_local_2);
        }


    }
}
