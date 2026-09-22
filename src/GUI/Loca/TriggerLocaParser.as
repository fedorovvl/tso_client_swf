package GUI.Loca
{
    import flash.utils.Dictionary;
    import nLib.cXML;
    import __AS3__.vec.Vector;
    import Utils.StringUtils;

    public class TriggerLocaParser 
    {

        private static const NAME_TRIGGER_NAME:String = "name";
        private static const NAME_TRIGGER_LOCAPARAMS:String = "defaultLocaParams";
        private static const NAME_TRIGGER_KEY:String = "key";
        private static const NAME_TRIGGER_ALTKEY:String = "altKey";
        private static const NAME_TRIGGER_EXCEPTION:String = "exception";
        private static const NAME_TRIGGER_LOCAEXT_TYPE:String = "type";
        private static const NAME_TRIGGER_LOCAEXT_PARAM:String = "param";
        private static const NAME_TRIGGER_LOCAEXT_LOCAEXT:String = "locaExt";
        private static const NAME_TRIGGER_LOCAEXT_LOCAPARAMS:String = "addLocaParams";

        private var triggerLocaDictionary:Dictionary = new Dictionary();

        public function TriggerLocaParser(_arg_1:cXML)
        {
            super();
            this.parseTriggers(_arg_1);
        }

        public function buildTriggerLocaManager():TriggerLocaManager
        {
            return (new TriggerLocaManager(this.triggerLocaDictionary));
        }

        private function parseTriggers(_arg_1:cXML):void
        {
            var _local_3:String;
            var _local_4:Array;
            var _local_5:Array;
            var _local_6:Array;
            var _local_7:Boolean;
            var _local_8:cXML;
            var _local_9:TriggerLoca;
            var _local_10:Vector.<cXML>;
            var _local_11:cXML;
            var _local_12:String;
            var _local_13:Array;
            var _local_14:Array;
            var _local_15:Array;
            var _local_16:LocaExtension;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_8 in _local_2)
            {
                _local_3 = _local_8.GetAttributeString_string(NAME_TRIGGER_NAME);
                _local_4 = StringUtils.split(_local_8.GetAttributeString_string(NAME_TRIGGER_LOCAPARAMS), StringUtils.COMMA);
                _local_5 = StringUtils.split(_local_8.GetAttributeString_string(NAME_TRIGGER_KEY), StringUtils.COMMA);
                _local_6 = StringUtils.split(_local_8.GetAttributeString_string(NAME_TRIGGER_ALTKEY), StringUtils.COMMA);
                _local_7 = _local_8.GetAttributeBool(NAME_TRIGGER_EXCEPTION);
                _local_9 = new TriggerLoca(_local_3, _local_4, _local_5, _local_6, _local_7);
                _local_10 = _local_8.CreateChildrenArray();
                for each (_local_11 in _local_10)
                {
                    _local_12 = _local_11.GetAttributeString_string(NAME_TRIGGER_LOCAEXT_TYPE);
                    _local_13 = StringUtils.split(_local_11.GetAttributeString_string(NAME_TRIGGER_LOCAEXT_PARAM), StringUtils.COMMA);
                    _local_14 = StringUtils.split(_local_11.GetAttributeString_string(NAME_TRIGGER_LOCAEXT_LOCAEXT), StringUtils.COMMA);
                    _local_15 = StringUtils.split(_local_11.GetAttributeString_string(NAME_TRIGGER_LOCAEXT_LOCAPARAMS), StringUtils.COMMA);
                    _local_16 = new LocaExtension(_local_12, _local_13, _local_14, _local_15);
                    _local_9.locaExtensions.push(_local_16);
                };
                this.triggerLocaDictionary[_local_3] = _local_9;
            };
        }


    }
}
