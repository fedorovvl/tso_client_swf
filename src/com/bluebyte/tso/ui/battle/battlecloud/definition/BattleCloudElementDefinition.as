package com.bluebyte.tso.ui.battle.battlecloud.definition
{
    import com.bluebyte.tso.util.RandomPointZone;
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import flash.xml.XMLNode;
    import nLib.cXML;
    import flash.utils.Dictionary;
    import __AS3__.vec.*;

    public final class BattleCloudElementDefinition 
    {

        public var loopsMin:int;
        public var zones:RandomPointZone;
        public var position:Point = new Point();
        public var name:String;
        public var debug:Boolean = false;
        public var chance:Number;
        public var loopsMax:Number;
        public var isPicker:Boolean;
        public var condition:String;
        public var list:Vector.<BattleCloudElementDefinition>;
        public var trigger:String;


        public static function fromXML(_arg_1:XMLNode, _arg_2:Boolean=false):BattleCloudElementDefinition
        {
            var _local_4:Vector.<XMLNode>;
            var _local_5:String;
            var _local_6:int;
            var _local_7:XMLNode;
            var _local_3:BattleCloudElementDefinition = new (BattleCloudElementDefinition)();
            _local_3.isPicker = (String(_arg_1.localName) == "picker");
            _local_3.chance = ((_arg_1.attributes["chance"]) ? (Number(_arg_1.attributes["chance"]) / 100) : 1);
            _local_3.trigger = (((_arg_2) && (_arg_1.attributes["trigger"])) ? String(_arg_1.attributes["trigger"]) : null);
            _local_3.condition = String(_arg_1.attributes["condition"]);
            _local_3.debug = (String(_arg_1.attributes["debug"]) == "true");
            if (!_local_3.isPicker)
            {
                _local_3.name = String(_arg_1.attributes["name"]);
                if (_arg_1.attributes["loops"])
                {
                    _local_5 = String(_arg_1.attributes["loops"]);
                    _local_6 = _local_5.indexOf("-");
                    if (_local_6 > -1)
                    {
                        _local_3.loopsMin = int(_local_5.substr(0, _local_6));
                        _local_3.loopsMax = int(_local_5.substr((_local_6 + 1)));
                    }
                    else
                    {
                        _local_3.loopsMin = (_local_3.loopsMax = int(_local_5));
                    };
                }
                else
                {
                    if ((((_arg_2) && (!(_local_3.trigger))) && (!(_local_3.condition))))
                    {
                        _local_3.loopsMin = (_local_3.loopsMax = -1);
                    }
                    else
                    {
                        _local_3.loopsMin = (_local_3.loopsMax = 1);
                    };
                };
                if (((_arg_1.attributes["x"]) || (_arg_1.attributes["y"])))
                {
                    _local_3.position = new Point(_arg_1.attributes["x"], _arg_1.attributes["y"]);
                };
                _local_4 = cXML.getChildNodes(_arg_1, "zone");
                if (_local_4.length > 0)
                {
                    _local_3.zones = new RandomPointZone();
                    _local_3.zones.fromXML(_local_4);
                };
            }
            else
            {
                _local_3.list = new Vector.<BattleCloudElementDefinition>();
                for each (_local_7 in cXML.getAllChildNodes(_arg_1))
                {
                    _local_3.list.push(fromXML(_local_7));
                };
            };
            return (_local_3);
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
