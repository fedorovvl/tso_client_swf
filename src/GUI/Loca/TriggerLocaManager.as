package GUI.Loca
{
    import flash.utils.Dictionary;
    import nLib.gMisc;
    import Utils.StringUtils;
    import Enums.LOCA_GROUP;
    import com.bluebyte.tso.util.ClientLogger;
    import Communication.VO.TriggerVO;
    import Enums.TRIGGER_ACTION;

    public class TriggerLocaManager 
    {

        private static var singletonInstance:TriggerLocaManager;
        public static const SOMETHING_BETWEEN_BRACES:RegExp = new RegExp("{*}");
        private static var triggerVOVariablesDictionary:Dictionary = new Dictionary();

        private var locaExtensionConditionHashMap:Dictionary;
        private var triggerLocaDictionary:Dictionary = new Dictionary();

        {
            triggerVOVariablesDictionary["item"] = "item_string";
            triggerVOVariablesDictionary["target"] = "target_string";
            triggerVOVariablesDictionary["name"] = "name_string";
            triggerVOVariablesDictionary["type"] = "type_string";
            triggerVOVariablesDictionary["min"] = "min";
            triggerVOVariablesDictionary["max"] = "max";
            triggerVOVariablesDictionary["amount"] = "amount";
            triggerVOVariablesDictionary["item"] = "item_string";
        }

        public function TriggerLocaManager(_arg_1:Dictionary)
        {
            super();
            this.triggerLocaDictionary = _arg_1;
            this.buildLocaExtensionConditionHashMap();
        }

        public static function getInstance():TriggerLocaManager
        {
            return (singletonInstance);
        }

        public static function setInstance(_arg_1:TriggerLocaManager):void
        {
            singletonInstance = _arg_1;
        }


        public function getTriggerLocaText(trigger:TriggerVO):String
        {
            var triggerLoca:TriggerLoca;
            var key:String;
            var locaParams:Array;
            var param:String;
            var locaExtension:LocaExtension;
            var locaExtensionConditionChecked:Boolean;
            var checkFunction:Function;
            try
            {
                triggerLoca = this.triggerLocaDictionary[trigger.action_string];
                key = this.parseKey(trigger, triggerLoca.key);
                if (triggerLoca.exception == true)
                {
                    locaParams = this.computeExceptionTriggerLoca(trigger);
                }
                else
                {
                    locaParams = this.parseParams(trigger, triggerLoca.locaParams);
                    param = "";
                    for each (locaExtension in triggerLoca.locaExtensions)
                    {
                        locaExtensionConditionChecked = true;
                        for each (param in locaExtension.params)
                        {
                            checkFunction = this.locaExtensionConditionHashMap[locaExtension.type];
                            if (checkFunction == null)
                            {
                                gMisc.Assert(false, (("Unknown check function for type[" + locaExtension.type) + "]!"));
                            };
                            if (!checkFunction(trigger, param))
                            {
                                locaExtensionConditionChecked = false;
                                break;
                            };
                        };
                        if (locaExtensionConditionChecked)
                        {
                            key = (key + this.parseKey(trigger, locaExtension.locaExt, false));
                            (locaParams.push as Function).apply(this, this.parseParams(trigger, locaExtension.locaParams));
                        };
                    };
                };
                if (!StringUtils.isEmpty(trigger.loca_string))
                {
                    key = (key + ("_" + trigger.loca_string));
                };
                if (((!(cLocaManager.GetInstance().hasText(LOCA_GROUP.QUEST_TRIGGERS, key))) && (triggerLoca.altKey.length > 0)))
                {
                    return (cLocaManager.GetInstance().GetText(LOCA_GROUP.QUEST_TRIGGERS, this.parseKey(trigger, triggerLoca.altKey, false), locaParams));
                };
                return (cLocaManager.GetInstance().GetText(LOCA_GROUP.QUEST_TRIGGERS, key, locaParams));
            }
            catch(e:Error)
            {
                ClientLogger.log(("Error in TriggerLocaManager.getTriggerLocaText(): " + e.message));
                return (cLocaManager.GetInstance().GetText(LOCA_GROUP.QUEST_TRIGGERS, trigger.action_string));
            };
            return ("");
        }

        private function computeExceptionTriggerLoca(_arg_1:TriggerVO):Array
        {
            var _local_2:Array;
            var _local_3:int;
            switch (_arg_1.action_string)
            {
                case TRIGGER_ACTION.ACTION_PRODUCTION_TIME_string:
                    _local_2 = [int((_arg_1.min / 60)), (_arg_1.min % 60)];
                    break;
                case TRIGGER_ACTION.ACTION_PRODUCTION_VALUE_string:
                    _local_3 = int((global.economyCalculationTime / 3600));
                    _local_2 = [(_arg_1.min * _local_3), _local_3];
                    break;
            };
            return (_local_2);
        }

        private function checkLocaExtensionConditionExisting(_arg_1:TriggerVO, _arg_2:String):Boolean
        {
            return (_arg_1.isParamExisting(triggerVOVariablesDictionary[_arg_2]));
        }

        private function checkLocaExtensionConditionMissing(_arg_1:TriggerVO, _arg_2:String):Boolean
        {
            return (_arg_1.isParamMissing(triggerVOVariablesDictionary[_arg_2]));
        }

        private function parseParams(_arg_1:TriggerVO, _arg_2:Array):Array
        {
            var _local_4:String;
            var _local_3:Array = new Array();
            for each (_local_4 in _arg_2)
            {
                _local_3.push(_arg_1[triggerVOVariablesDictionary[_local_4]]);
            };
            return (_local_3);
        }

        private function buildLocaExtensionConditionHashMap():void
        {
            this.locaExtensionConditionHashMap = new Dictionary();
            this.locaExtensionConditionHashMap[LocaExtension.LOCA_EXTENSION_TYPE_MISSING] = this.checkLocaExtensionConditionMissing;
            this.locaExtensionConditionHashMap[LocaExtension.LOCA_EXTENSION_TYPE_EXISTING] = this.checkLocaExtensionConditionExisting;
        }

        private function parseKey(_arg_1:TriggerVO, _arg_2:Array, _arg_3:Boolean=true):String
        {
            var _local_5:int;
            var _local_6:String;
            var _local_4:* = "";
            if (_arg_2.length > 0)
            {
                _local_5 = 0;
                while (_local_5 < _arg_2.length)
                {
                    _local_6 = _arg_2[_local_5];
                    if (_local_6.match(SOMETHING_BETWEEN_BRACES))
                    {
                        _local_4 = (_local_4 + _arg_1[triggerVOVariablesDictionary[_local_6.substring(1, (_local_6.length - 1))]]);
                    }
                    else
                    {
                        _local_4 = (_local_4 + _local_6);
                    };
                    _local_5++;
                };
            }
            else
            {
                if (_arg_3)
                {
                    _local_4 = _arg_1["action_string"];
                };
            };
            return (_local_4);
        }


    }
}
