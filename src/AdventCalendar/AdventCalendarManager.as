package AdventCalendar
{
    import Model.Observer;
    import Interface.cGeneralInterface;
    import Communication.VO.dAdventCalendarDoorVO;
    import mx.collections.ArrayCollection;
    import Events.EventManager;
    import Enums.COMMAND;
    import GUI.Effects.gHintManager;
    import Enums.ADVENT_CALENDAR_DOOR_SPECIAL_TYPE;
    import Enums.ADVENT_CALENDAR_DOOR_STATUS;
    import Interface.cGameInterface;
    import flash.display.DisplayObject;
    import GUI.Components.ItemRenderer.AdventDoorRenderer;
    import Model.Notifier;

    public class AdventCalendarManager implements Observer 
    {

        private var eventActive:Boolean = false;
        public var gi:cGeneralInterface;
        public var finalReward:dAdventCalendarDoorVO;
        public var calendarDoors:ArrayCollection = new ArrayCollection();
        public var assetPrefix:String;

        public function AdventCalendarManager(_arg_1:cGeneralInterface)
        {
            super();
            this.gi = _arg_1;
            this.gi.mEventManager.addPropertyObserver(EventManager.EVENT_STARTED, this);
            this.gi.mEventManager.addPropertyObserver(EventManager.EVENT_STOPPED, this);
        }

        public function SelectSpecialDoorReward(_arg_1:String, _arg_2:int):void
        {
            var _local_3:dAdventCalendarDoorVO = this.GetDoorById(_arg_1);
            if (((!(_local_3 == null)) && (_local_3.IsSpecial())))
            {
                _local_3.chosenRewardId = _arg_2;
                global.ui.SendServerActionSimple(COMMAND.SELECT_ADVENT_CALENDAR_DOOR_REWARD, _local_3);
            };
        }

        public function IsEventActive():Boolean
        {
            return (this.eventActive);
        }

        public function GetOpenDoorCount():int
        {
            var _local_2:dAdventCalendarDoorVO;
            var _local_1:int;
            for each (_local_2 in this.calendarDoors)
            {
                if (_local_2.isOpened())
                {
                    _local_1++;
                };
            };
            return (_local_1);
        }

        public function UpdateHintPointer():void
        {
            var _local_1:dAdventCalendarDoorVO;
            if (((!(this.IsActive())) || (!(this.gi.isOnHomzone()))))
            {
                gHintManager.HideCalendarNotification();
                return;
            };
            for each (_local_1 in this.calendarDoors)
            {
                if (this.openable(_local_1))
                {
                    gHintManager.ShowCalendarOpenableNotification();
                    break;
                };
                gHintManager.HideCalendarNotification();
            };
        }

        public function Init(_arg_1:ArrayCollection):void
        {
            var _local_2:Object;
            var _local_3:dAdventCalendarDoorVO;
            this.calendarDoors.removeAll();
            for each (_local_2 in _arg_1)
            {
                _local_3 = (_local_2 as dAdventCalendarDoorVO).Clone();
                this.AddInitialDoor(_local_3);
            };
            globalFlash.gui.mAvatar.Refresh();
            this.UpdateHintPointer();
        }

        public function AddInitialDoor(_arg_1:dAdventCalendarDoorVO):void
        {
            if (_arg_1.specialType == ADVENT_CALENDAR_DOOR_SPECIAL_TYPE.FINAL_REWARD)
            {
                _arg_1.chosenRewardId = 0;
                this.finalReward = _arg_1;
            }
            else
            {
                this.calendarDoors.addItem(_arg_1);
            };
        }

        public function openableWithGems(_arg_1:dAdventCalendarDoorVO):Boolean
        {
            return ((!(_arg_1 == null)) && (_arg_1.status == ADVENT_CALENDAR_DOOR_STATUS.CAN_OPEN_WITH_GEMS));
        }

        public function GetDoorById(_arg_1:String):dAdventCalendarDoorVO
        {
            var _local_2:dAdventCalendarDoorVO;
            if (((this.finalReward) && (_arg_1 == this.finalReward.id)))
            {
                return (this.finalReward);
            };
            for each (_local_2 in this.calendarDoors)
            {
                if (_local_2.id == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function IsActive():Boolean
        {
            return (((!(this.calendarDoors.length == 0)) && ((this.gi as cGameInterface).mRequirements.miscRequirements_vector["AdventCalendarUnlock"].isFulfilled())) && (this.eventActive));
        }

        public function OpenDoor(_arg_1:dAdventCalendarDoorVO, _arg_2:DisplayObject=null):Boolean
        {
            if (this.openable(_arg_1))
            {
                global.ui.SendServerActionSimple(COMMAND.OPEN_ADVENT_CALENDAR_DOOR, _arg_1, new AdventResponder(_arg_1, _arg_2));
                return (true);
            };
            return (false);
        }

        public function OpenDoorWithGems(_arg_1:dAdventCalendarDoorVO, _arg_2:AdventDoorRenderer):Boolean
        {
            if (this.openableWithGems(_arg_1))
            {
                global.ui.SendServerActionSimple(COMMAND.OPEN_ADVENT_CALENDAR_DOOR_WITH_GEMS, _arg_1, new AdventResponder(_arg_1, _arg_2));
                return (true);
            };
            return (false);
        }

        public function openable(_arg_1:dAdventCalendarDoorVO):Boolean
        {
            return ((!(_arg_1 == null)) && (_arg_1.status == ADVENT_CALENDAR_DOOR_STATUS.CAN_OPEN));
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (_arg_3 == global.advent_calendar_required_event)
            {
                if (_arg_2 == EventManager.EVENT_STARTED)
                {
                    this.eventActive = true;
                }
                else
                {
                    if (_arg_2 == EventManager.EVENT_STOPPED)
                    {
                        this.eventActive = false;
                    };
                };
                globalFlash.gui.mAvatar.Refresh();
            };
        }


    }
}
