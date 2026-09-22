package Communication.VO
{
    import mx.collections.ArrayCollection;
    import mx.formatters.DateFormatter;
    import nLib.cXML;
    import Utils.StringUtils;

    public class TriggerVO 
    {

        private static const PARAM_MIN:String = "min";
        private static const PARAM_MAX:String = "max";
        private static const PARAM_AMOUNT:String = "amount";
        private static const PARAM_ID:String = "id";
        private static const PARAM_TRIGGER_IDX:String = "triggerIdx";
        private static const PARAM_ACTION:String = "action_string";
        private static const PARAM_ITEM:String = "item";
        private static const PARAM_ITEM_STRING:String = "item_string";
        private static const PARAM_TARGET:String = "target";
        private static const PARAM_TARGET_STRING:String = "target_string";
        private static const PARAM_LOCA_EXTENSION:String = "locaExtension";
        private static const PARAM_LOCA_STRING:String = "loca_string";
        private static const PARAM_TYPE:String = "type";
        private static const PARAM_TYPE_STRING:String = "type_string";
        private static const PARAM_STATE:String = "state";
        private static const PARAM_MODE:String = "mode";
        private static const PARAM_MODE_STRING:String = "mode_string";
        private static const PARAM_TIER:String = "tier";
        private static const PARAM_NAME:String = "name";
        private static const PARAM_NAME_STRING:String = "name_string";
        private static const PARAM_ICON:String = "icon";
        private static const PARAM_ICON_STRING:String = "icon_string";
        private static const PARAM_INVERT:String = "invert";

        public var achievementTriggerId:int;
        public var state:int;
        public var icon_string:String;
        public var id:int;
        public var untilInMiliseconds:Number;
        public var mode_string:String;
        public var type_string:String;
        public var isFailTrigger:Boolean = false;
        public var action_string:String;
        public var item_string:String;
        public var name_string:String;
        public var targetGridIdx:int = -1;
        public var min:int;
        public var dateInMiliseconds:Number;
        public var invert:Boolean;
        public var amount:int;
        public var tier:int;
        public var max:int;
        public var triggerIdx:int;
        public var id_vector:ArrayCollection = null;
        private var type_vector:ArrayCollection = null;
        public var loca_string:String;
        public var target_string:String;


        public static function createFromXML(_arg_1:cXML, _arg_2:int):TriggerVO
        {
            var _local_7:Date;
            if (((TriggerListVO.AND_LOGIC_OPERATOR == _arg_1.GetName_string().toLowerCase()) || (TriggerListVO.OR_LOGIC_OPERATOR == _arg_1.GetName_string().toLowerCase())))
            {
                return (TriggerListVO.fromXML(_arg_1, ""));
            };
            var _local_3:TriggerVO = new (TriggerVO)();
            _local_3.action_string = _arg_1.GetName_string();
            _local_3.item_string = _arg_1.GetAttributeString_string(PARAM_ITEM);
            _local_3.min = _arg_1.GetAttributeInt(PARAM_MIN);
            _local_3.max = _arg_1.GetAttributeInt(PARAM_MAX);
            _local_3.amount = _arg_1.GetAttributeInt(PARAM_AMOUNT);
            _local_3.target_string = _arg_1.GetAttributeString_string(PARAM_TARGET);
            _local_3.loca_string = _arg_1.GetAttributeString_string(PARAM_LOCA_EXTENSION);
            _local_3.type_string = _arg_1.GetAttributeString_string(PARAM_TYPE);
            _local_3.name_string = _arg_1.GetAttributeString_string(PARAM_NAME);
            _local_3.mode_string = _arg_1.GetAttributeString_string(PARAM_MODE);
            _local_3.icon_string = _arg_1.GetAttributeString_string(PARAM_ICON);
            _local_3.tier = _arg_1.GetAttributeInt(PARAM_TIER, -1);
            _local_3.triggerIdx = _arg_1.GetAttributeInt(PARAM_TRIGGER_IDX, -1);
            _local_3.state = _arg_1.GetAttributeInt(PARAM_STATE);
            _local_3.achievementTriggerId = _arg_2;
            _local_3.invert = _arg_1.GetAttributeBool(PARAM_INVERT);
            var _local_4:String = _arg_1.GetAttributeString_string(PARAM_ID, "");
            if (_local_4.indexOf(",") > -1)
            {
                _local_3.id_vector = new ArrayCollection(_local_4.split(","));
                _local_3.id = -1;
            }
            else
            {
                _local_3.id = _arg_1.GetAttributeInt(PARAM_ID, -1);
            };
            if (_local_3.type_string.indexOf(",") > -1)
            {
                _local_3.type_vector = new ArrayCollection(_local_3.type_string.split(","));
            };
            if (_local_3.triggerIdx == -1)
            {
                _local_3.triggerIdx = _arg_2;
            };
            var _local_5:String = _arg_1.GetAttributeString_string("date");
            var _local_6:String = _arg_1.GetAttributeString_string("until", "31/12/2030");
            if (_local_5.length > 0)
            {
                _local_7 = DateFormatter.parseDateString(_local_5);
                _local_3.dateInMiliseconds = _local_7.dateUTC;
                _local_7 = DateFormatter.parseDateString(_local_6);
                _local_3.untilInMiliseconds = _local_7.dateUTC;
            };
            return (_local_3);
        }


        public function isTypeEmpty():Boolean
        {
            return ((this.type_vector == null) && (StringUtils.isEmpty(this.type_string)));
        }

        public function isParamExisting(_arg_1:String):Boolean
        {
            return (!(this.isParamMissing(_arg_1)));
        }

        public function GetTypeString():String
        {
            return (this.type_string);
        }

        public function clone():TriggerVO
        {
            var _local_1:TriggerVO = new TriggerVO();
            _local_1.action_string = this.action_string;
            _local_1.item_string = this.item_string;
            _local_1.id = this.id;
            if (this.id_vector != null)
            {
                _local_1.id_vector = new ArrayCollection(this.id_vector.source.concat());
            };
            _local_1.min = this.min;
            _local_1.max = this.max;
            _local_1.amount = this.amount;
            _local_1.target_string = this.target_string;
            _local_1.loca_string = this.loca_string;
            if (this.type_vector != null)
            {
                _local_1.type_vector = new ArrayCollection(this.type_vector.source.concat());
            };
            _local_1.state = this.state;
            _local_1.mode_string = this.mode_string;
            _local_1.tier = this.tier;
            _local_1.name_string = this.name_string;
            _local_1.dateInMiliseconds = this.dateInMiliseconds;
            _local_1.untilInMiliseconds = this.untilInMiliseconds;
            _local_1.achievementTriggerId = this.achievementTriggerId;
            _local_1.isFailTrigger = this.isFailTrigger;
            _local_1.triggerIdx = this.triggerIdx;
            _local_1.icon_string = this.icon_string;
            _local_1.targetGridIdx = this.targetGridIdx;
            _local_1.invert = this.invert;
            return (_local_1);
        }

        public function isParamMissing(_arg_1:String):Boolean
        {
            switch (_arg_1)
            {
                case PARAM_MIN:
                case PARAM_MAX:
                case PARAM_AMOUNT:
                case PARAM_STATE:
                    return (this[_arg_1] == 0);
                case PARAM_ID:
                case PARAM_TRIGGER_IDX:
                    return (this[_arg_1] == -1);
                case PARAM_ACTION:
                case PARAM_ITEM_STRING:
                case PARAM_TARGET_STRING:
                case PARAM_LOCA_STRING:
                case PARAM_TYPE_STRING:
                case PARAM_MODE_STRING:
                case PARAM_NAME_STRING:
                case PARAM_ICON_STRING:
                    return (this[_arg_1] == "");
                default:
                    return (true);
            };
        }

        public function toString():String
        {
            return (((((((((((((((((("<TriggerVO " + this.action_string) + " ") + this.item_string) + " ") + this.id) + " ") + this.min) + " ") + this.max) + " ") + this.target_string) + " ") + this.loca_string) + " ") + this.type_string) + " ") + this.triggerIdx) + "/>");
        }

        public function typeContains(_arg_1:String):Boolean
        {
            var _local_2:String;
            if (this.type_vector != null)
            {
                for each (_local_2 in this.type_vector)
                {
                    if (_local_2 == _arg_1)
                    {
                        return (true);
                    };
                    if (((StringUtils.startsWith(_local_2, "%")) && (StringUtils.contains(StringUtils.SubString(_local_2, 1, (_local_2.length - 1)), _arg_1))))
                    {
                        return (true);
                    };
                };
                return (false);
            };
            return (this.type_string == _arg_1);
        }


    }
}
