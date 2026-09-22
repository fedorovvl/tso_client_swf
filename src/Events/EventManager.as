package Events
{
    import Model.Notifier;
    import __AS3__.vec.Vector;
    import Utils.HashMapWrapper;
    import Interface.cGeneralInterface;
    import Utils.StringUtils;
    import Trigger.TriggerList;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Sound.cSoundManager;
    import mx.collections.ArrayCollection;
    import __AS3__.vec.*;

    public class EventManager extends Notifier 
    {

        public static const EVENT_STARTED:String = "eventStarted";
        public static const EVENT_STOPPED:String = "eventStopped";
        public static const EVENT_START_INFO_IN_LOAD:int = (1 << 0);
        public static const EVENT_START_INFO_IS_OLD_EVENT:int = (1 << 1);

        private var reactors:Vector.<EventReactor>;
        internal var events:HashMapWrapper = new HashMapWrapper();
        protected var gi:cGeneralInterface;
        internal var runningEvents:HashMapWrapper = new HashMapWrapper();

        public function EventManager(_arg_1:cGeneralInterface)
        {
            var _local_2:dEventVO;
            super();
            this.gi = _arg_1;
            this.reactors = new Vector.<EventReactor>();
            for each (_local_2 in global.eventSwitchSettings)
            {
                this.events.putItem(_local_2.event_name_string, _local_2.Clone());
            };
        }

        public function areEventConditionsFulfilled(_arg_1:String):Boolean
        {
            var _local_2:dEventVO;
            for each (_local_2 in this.events.valueSet())
            {
                if (StringUtils.equalsIgnoreCase(_local_2.event_name_string, _arg_1))
                {
                    return (TriggerList.instantCheck(_local_2.conditions, this.gi));
                };
            };
            return (false);
        }

        public function GetTwoStepEventNameFor(_arg_1:String):String
        {
            var _local_2:dEventVO = (this.runningEvents.getItem(_arg_1) as dEventVO);
            if (_local_2 != null)
            {
                if (((!(StringUtils.isEmpty(_local_2.dependantEvent))) && (_arg_1 == _local_2.dependantEvent)))
                {
                    return (_local_2.event_name_string);
                };
            };
            return ("");
        }

        public function GetActiveEventNames():Array
        {
            return (this.runningEvents.keySet());
        }

        public function GetActiveTwoStepEventName():String
        {
            var _local_1:dEventVO;
            for each (_local_1 in this.events.valueSet())
            {
                if (((!(StringUtils.isEmpty(_local_1.dependantEvent))) && (this.isEventStarted(_local_1.dependantEvent))))
                {
                    return (_local_1.event_name_string);
                };
            };
            return ("");
        }

        public function GetEventStartDate(_arg_1:String):Number
        {
            var _local_2:dEventVO = (this.events.getItem(_arg_1) as dEventVO);
            if (_local_2 != null)
            {
                return (_local_2.startDate);
            };
            return (-1);
        }

        public function isEventRunning(_arg_1:String):Boolean
        {
            return (!(this.runningEvents.getItem(_arg_1) == null));
        }

        public function isEventStarted(_arg_1:String):Boolean
        {
            return (this.isEventStartedWithYear(_arg_1, -1));
        }

        public function isEventStartedWithYear(_arg_1:String, _arg_2:int):Boolean
        {
            var _local_3:String;
            if (((!(_arg_1 == null)) && (_arg_1.length > 0)))
            {
                for each (_local_3 in _arg_1.split(","))
                {
                    if (this.isSingleEventStarted(_local_3, _arg_2))
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        public function StopEvent(_arg_1:cGameInterface, _arg_2:String):void
        {
            var _local_4:EventReactor;
            var _local_5:EffectVO;
            var _local_3:dEventVO = (this.runningEvents.getItem(_arg_2) as dEventVO);
            if (_local_3 != null)
            {
                this.runningEvents.remove(_arg_2);
                for each (_local_5 in _local_3.mPostEffects_vector)
                {
                    _arg_1.effectFactory.createEffect(_local_5).apply();
                };
                notifyPropertyObserver(EVENT_STOPPED, _local_3.event_name_string);
                globalFlash.gui.mShopWindow.initBanners();
                globalFlash.gui.mToolboxPanel.Refresh();
                globalFlash.gui.mOptionsPanel.ToggleEventWindowButton();
                globalFlash.gui.mEventInfoPanel.Refresh();
                globalFlash.gui.mEventWidgetList.Refresh();
                global.ui.mCurrentPlayerZone.mSettlerKIManager.clearAnimals(true);
                global.ui.mCurrentPlayer.forceResortBuffsForStarMenu();
                global.ui.mAdventCalendarManager.UpdateHintPointer();
            };
            for each (_local_4 in this.reactors)
            {
                if (((!(_local_4.eventName_string == null)) && (_local_4.eventName_string == _arg_2)))
                {
                    _local_4.dispose();
                };
            };
        }

        public function CleanUp(_arg_1:cGameInterface, _arg_2:String):void
        {
            var _local_4:EffectVO;
            var _local_3:dEventVO = (this.events.getItem(_arg_2) as dEventVO);
            if (((!(_local_3 == null)) && (!(_local_3.eventCleanedUp))))
            {
                for each (_local_4 in _local_3.mCleanUpEffects_vector)
                {
                    _arg_1.effectFactory.createEffect(_local_4).apply();
                };
                _local_3.eventCleanedUp = true;
                globalFlash.gui.mToolboxPanel.Refresh();
            };
        }

        public function isEventStartedAndActive(_arg_1:String):Boolean
        {
            var _local_4:dEventVO;
            if (_arg_1.charAt(0) == "!")
            {
                return (!(this.isEventStarted(_arg_1.substring(1))));
            };
            var _local_2:dEventVO = (this.runningEvents.getItem(_arg_1) as dEventVO);
            if (_local_2 != null)
            {
                if (((_local_2.partner_string == null) || (_local_2.partner_string == "")))
                {
                    return (this.isEventRunning(_local_2.event_name_string));
                };
            };
            var _local_3:Array = this.GetActiveVisibleEvents();
            for each (_local_4 in _local_3)
            {
                if (_local_4.event_name_string == _arg_1)
                {
                    return (this.isEventRunning(_local_4.event_name_string));
                };
            };
            return (false);
        }

        public function GetActiveVisibleEvents():Array
        {
            var _local_2:dEventVO;
            var _local_1:Array = new Array();
            for each (_local_2 in this.runningEvents.valueSet())
            {
                if (((((this.isEventRunning(_local_2.event_name_string)) && (!(_local_2.silent))) && (!(this.isEventStarted(_local_2.dependantEvent)))) && ((_local_2.partner_string == "") || (global.partner == _local_2.partner_string))))
                {
                    _local_1.push(_local_2);
                };
            };
            return (_local_1);
        }

        public function GetEventStopDate(_arg_1:String):Number
        {
            var _local_2:dEventVO = (this.events.getItem(_arg_1) as dEventVO);
            if (_local_2 != null)
            {
                return (_local_2.stopDate);
            };
            return (-1);
        }

        public function StartEvent(gi:cGameInterface, eventName_string:String, stopDate:Number, startDate:Number, prioInGroup:int, percentage:Number, eventInfo:int):void
        {
            var ev:dEventVO;
            var reactor:EventReactorVO;
            var preEffect:EffectVO;
            ev = (this.events.getItem(eventName_string) as dEventVO);
            var inLoadZone:Boolean = ((eventInfo & EVENT_START_INFO_IN_LOAD) == EVENT_START_INFO_IN_LOAD);
            var oldEvent:Boolean = ((eventInfo & EVENT_START_INFO_IS_OLD_EVENT) == EVENT_START_INFO_IS_OLD_EVENT);
            if (ev != null)
            {
                if (((!(this.isEventRunning(ev.event_name_string))) || (((!(ev.partner_string == null)) && (!(ev.partner_string == ""))) && (global.partner == ev.partner_string))))
                {
                    if (!oldEvent)
                    {
                        for each (preEffect in ev.mPreEffects_vector)
                        {
                            gi.effectFactory.createEffect(preEffect).apply();
                        };
                    };
                    for each (reactor in ev.mEventReactors_vector)
                    {
                        this.reactors.push(new EventReactor(gi, reactor, ev.event_name_string));
                    };
                    ev.eventCleanedUp = false;
                    ev.stopDate = stopDate;
                    ev.setStartDate(startDate);
                    ev.prioInGroup = prioInGroup;
                    ev.percentage = percentage;
                    ev.eventInfo = eventInfo;
                    if (!ev.silent)
                    {
                        ev.silent = oldEvent;
                    };
                    this.runningEvents.putItem(ev.event_name_string, ev);
                    notifyPropertyObserver(EVENT_STARTED, ev.event_name_string);
                    if (((!(ev.silent)) && (!(inLoadZone))))
                    {
                        global.getApplication().callLater(function ():void
                        {
                            if (((!(isEventStarted(ev.dependantEvent))) && (isEventStartedAndActive(ev.event_name_string))))
                            {
                                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.EVENT_START, [(ev.event_name_string + "_started"), ev.eventIcon, ev.clickWindowName, ev.clickWindowItem]);
                            };
                        });
                    };
                    globalFlash.gui.mShopWindow.initBanners();
                    globalFlash.gui.mToolboxPanel.Refresh();
                    globalFlash.gui.mOptionsPanel.SetEventWindowButton(true, eventName_string);
                    globalFlash.gui.mEventWidgetList.Refresh();
                    global.ui.mCurrentPlayerZone.mSettlerKIManager.clearAnimals(true);
                    global.ui.mCurrentPlayer.forceResortBuffsForStarMenu();
                    cSoundManager.getInstance().refreshLoopWithEvent(eventName_string);
                };
            };
            if (!oldEvent)
            {
                globalFlash.gui.mEventInfoPanel.Refresh();
            };
            if ((((global.ui.isOnHomzone()) && (!(global.hasEventInfoPanelBeenShown))) && (!(oldEvent))))
            {
                globalFlash.gui.mEventInfoPanel.Show();
            };
        }

        private function isSingleEventStarted(_arg_1:String, _arg_2:int):Boolean
        {
            if (_arg_1.charAt(0) == "!")
            {
                return (!(this.isSingleEventStarted(_arg_1.substring(1), _arg_2)));
            };
            var _local_3:dEventVO = (this.runningEvents.getItem(_arg_1) as dEventVO);
            if (_local_3 != null)
            {
                return ((_arg_2 == -1) || (_local_3.getCachedStartYear() == _arg_2));
            };
            return (false);
        }

        public function isEventCleanedUp(_arg_1:String):Boolean
        {
            var _local_2:dEventVO = (this.events.getItem(_arg_1) as dEventVO);
            if (_local_2 != null)
            {
                return (_local_2.eventCleanedUp);
            };
            return (false);
        }

        public function updateTimes(_arg_1:ArrayCollection):void
        {
            var _local_3:dEventTimeVO;
            var _local_4:dEventVO;
            var _local_5:dEventTimeVO;
            var _local_2:HashMapWrapper = new HashMapWrapper();
            for each (_local_3 in _arg_1)
            {
                _local_2.putItem(_local_3.event_name_string, _local_3);
            };
            for each (_local_4 in this.events)
            {
                if (_local_2.hasKey(_local_4.event_name_string))
                {
                    _local_5 = (_local_2.getItem(_local_4.event_name_string) as dEventTimeVO);
                    if (((!(_local_4.startDate == _local_5.startDate)) && (_local_5.startDate > 0)))
                    {
                        _local_4.startDate = _local_5.startDate;
                    };
                    if (((!(_local_4.stopDate == _local_5.stopDate)) && (_local_5.stopDate > 0)))
                    {
                        _local_4.stopDate = _local_5.stopDate;
                    };
                };
            };
        }


    }
}
