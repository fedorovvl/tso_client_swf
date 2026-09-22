package Events
{
    import Communication.VO.TriggerListVO;
    import __AS3__.vec.Vector;
    import Communication.VO.EffectVO;
    import nLib.cXML;
    import __AS3__.vec.*;

    public class dEventVO 
    {

        public var bannerImageString:String;
        private var startYearCache:int = -1;
        public var prioInGroup:int;
        public var percentage:Number;
        public var event_name_string:String;
        public var prio:int;
        public var startDate:Number;
        public var eventIcon:String;
        public var conditions:TriggerListVO = null;
        public var clickWindowName:String;
        public var baseEvent_string:String;
        public var clickWindowItem:String;
        public var numberOfDescriptionItems:int;
        public var silent:Boolean = false;
        public var stopDate:Number;
        public var dependantEvent:String;
        public var widgetImageString:String;
        public var eventCleanedUp:Boolean = false;
        public var partner_string:String;
        public var eventInfo:int;

        public var mPreEffects_vector:Vector.<EffectVO> = new Vector.<EffectVO>();
        public var mPostEffects_vector:Vector.<EffectVO> = new Vector.<EffectVO>();
        public var mCleanUpEffects_vector:Vector.<EffectVO> = new Vector.<EffectVO>();
        public var mEventReactors_vector:Vector.<EventReactorVO> = new Vector.<EventReactorVO>();
        public var eventPanelButtons:Vector.<EventButtonData> = new Vector.<EventButtonData>();


        public static function CreateFromXML(_arg_1:cXML):dEventVO
        {
            var _local_4:cXML;
            var _local_5:Vector.<cXML>;
            var _local_6:cXML;
            var _local_7:Vector.<cXML>;
            var _local_8:cXML;
            var _local_9:Vector.<cXML>;
            var _local_10:cXML;
            var _local_11:Vector.<cXML>;
            var _local_12:cXML;
            var _local_2:dEventVO = new (dEventVO)();
            _local_2.event_name_string = _arg_1.GetAttributeString_string("name");
            _local_2.silent = _arg_1.GetAttributeBool("silent", false);
            _local_2.eventIcon = _arg_1.GetAttributeString_string("icon");
            _local_2.clickWindowName = _arg_1.GetAttributeString_string("clickWindowName");
            _local_2.clickWindowItem = _arg_1.GetAttributeString_string("clickWindowItem");
            _local_2.prio = _arg_1.GetAttributeInt("prio", 0);
            _local_2.numberOfDescriptionItems = _arg_1.GetAttributeInt("numberOfDescriptionItems");
            _local_2.bannerImageString = _arg_1.GetAttributeString_string("banner");
            _local_2.widgetImageString = _arg_1.GetAttributeString_string("widget", "default");
            _local_2.mPreEffects_vector = new Vector.<EffectVO>();
            _local_2.dependantEvent = _arg_1.GetAttributeString_string("dependantEvent", "");
            _local_2.partner_string = _arg_1.GetAttributeString_string("partner", "");
            var _local_3:Vector.<cXML> = _arg_1.MoveToSubNodeAndCreateChildrenArray("preeffect");
            for each (_local_4 in _local_3)
            {
                _local_2.mPreEffects_vector.push(EffectVO.CreateFromXML(_local_4));
            };
            _local_2.mPostEffects_vector = new Vector.<EffectVO>();
            _local_5 = _arg_1.MoveToSubNodeAndCreateChildrenArray("posteffect");
            for each (_local_6 in _local_5)
            {
                _local_2.mPostEffects_vector.push(EffectVO.CreateFromXML(_local_6));
            };
            _local_2.mCleanUpEffects_vector = new Vector.<EffectVO>();
            _local_7 = _arg_1.MoveToSubNodeAndCreateChildrenArray("cleanup");
            for each (_local_8 in _local_7)
            {
                _local_2.mCleanUpEffects_vector.push(EffectVO.CreateFromXML(_local_8));
            };
            _local_2.mEventReactors_vector = new Vector.<EventReactorVO>();
            _local_9 = _arg_1.MoveToSubNodeAndCreateChildrenArray("reactors");
            for each (_local_10 in _local_9)
            {
                _local_2.mEventReactors_vector.push(EventReactorVO.CreateFromXML(_local_10));
            };
            _local_2.eventPanelButtons = new Vector.<EventButtonData>();
            _local_11 = _arg_1.MoveToSubNodeAndCreateChildrenArray("buttons");
            for each (_local_12 in _local_11)
            {
                _local_2.eventPanelButtons.push(EventButtonData.CreateFromXML(_local_12));
            };
            _local_2.conditions = TriggerListVO.fromXML(_arg_1, "startconditions");
            return (_local_2);
        }


        public function getCachedStartYear():int
        {
            return (this.startYearCache);
        }

        public function Clone():dEventVO
        {
            var _local_1:dEventVO = new dEventVO();
            _local_1.event_name_string = this.event_name_string;
            _local_1.mPreEffects_vector = this.mPreEffects_vector;
            _local_1.mPostEffects_vector = this.mPostEffects_vector;
            _local_1.mCleanUpEffects_vector = this.mCleanUpEffects_vector;
            _local_1.mEventReactors_vector = this.mEventReactors_vector;
            _local_1.silent = this.silent;
            _local_1.eventIcon = this.eventIcon;
            _local_1.clickWindowName = this.clickWindowName;
            _local_1.clickWindowItem = this.clickWindowItem;
            _local_1.prio = this.prio;
            _local_1.prioInGroup = this.prioInGroup;
            _local_1.numberOfDescriptionItems = this.numberOfDescriptionItems;
            _local_1.bannerImageString = this.bannerImageString;
            _local_1.widgetImageString = this.widgetImageString;
            _local_1.dependantEvent = this.dependantEvent;
            _local_1.eventPanelButtons = this.eventPanelButtons;
            _local_1.partner_string = this.partner_string;
            if (this.conditions != null)
            {
                _local_1.conditions = (this.conditions.clone() as TriggerListVO);
            };
            _local_1.percentage = this.percentage;
            return (_local_1);
        }

        public function setStartDate(_arg_1:Number):void
        {
            this.startDate = _arg_1;
            var _local_2:Date = new Date(_arg_1);
            this.startYearCache = _local_2.fullYear;
        }


    }
}
