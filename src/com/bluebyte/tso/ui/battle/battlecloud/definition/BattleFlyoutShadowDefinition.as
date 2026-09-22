package com.bluebyte.tso.ui.battle.battlecloud.definition
{
    import flash.xml.XMLNode;

    public final class BattleFlyoutShadowDefinition 
    {

        public var strength:int = 1;
        public var blur:int = 11;
        public var enabled:Boolean = true;
        public var distance:int = 2;
        public var alpha:Number = 0.8;


        public function fromXML(_arg_1:XMLNode):void
        {
            this.enabled = (String(_arg_1.attributes["enabled"]) == "true");
            this.distance = ((_arg_1.attributes["distance"]) ? int(_arg_1.attributes["distance"]) : 2);
            this.alpha = ((_arg_1.attributes["alpha"]) ? Number(_arg_1.attributes["alpha"]) : 0.7);
            this.blur = ((_arg_1.attributes["blur"]) ? int(_arg_1.attributes["blur"]) : 11);
            this.strength = ((_arg_1.attributes["strength"]) ? int(_arg_1.attributes["strength"]) : 1);
        }


    }
}
