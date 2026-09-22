package GO
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;
    import nLib.gMisc;
    import GUI.Loca.cLocaManager;

    public class cBuildSlot implements IEventDispatcher 
    {

        public static const REGULAR_BUILDSLOT:int = 0;
        public static const PERMANENT_BUILDSLOT:int = 1;
        public static const TEMPORARY_BUILDSLOT:int = 2;

        public var mType:int = 0;
        private var _1457004543mTimeLeft:String = "00:00";
        private var mBuildingGridPos:int = 0;
        private var mTimeOfPurchase:Number = 0;
        private var _bindingEventDispatcher:EventDispatcher;
        private var mExpireAt:Number = 0;

        public function cBuildSlot(_arg_1:Number, _arg_2:int, _arg_3:Number)
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            this.mTimeOfPurchase = _arg_1;
            this.mBuildingGridPos = _arg_2;
            this.mExpireAt = _arg_3;
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get mTimeLeft():String
        {
            return (this._1457004543mTimeLeft);
        }

        public function set mTimeLeft(_arg_1:String):void
        {
            var _local_2:Object = this._1457004543mTimeLeft;
            if (_local_2 !== _arg_1)
            {
                this._1457004543mTimeLeft = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mTimeLeft", _local_2, _arg_1));
            };
        }

        public function SetBuildingGridPosition(_arg_1:int):void
        {
            this.mBuildingGridPos = _arg_1;
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function GetExpireAt():Number
        {
            return (this.mExpireAt);
        }

        public function GetTimeOfPurchase():Number
        {
            return (this.mTimeOfPurchase);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function SetExpireAt(_arg_1:Number):void
        {
            this.mExpireAt = _arg_1;
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function updateTimeLeft(_arg_1:Number):Boolean
        {
            var _local_2:Number;
            if (this.isPremiumSlot())
            {
                _local_2 = (this.mExpireAt - gMisc.GetEpochMillis());
            }
            else
            {
                if (this.mTimeOfPurchase > _arg_1)
                {
                    return (true);
                };
                _local_2 = (global.tempSlotDuration - (_arg_1 - this.mTimeOfPurchase));
            };
            if (_local_2 > 0)
            {
                this.mTimeLeft = cLocaManager.GetInstance().FormatDuration(_local_2, cLocaManager.DURATION_FORMAT_NUMERIC_SHORT);
                return (true);
            };
            return (false);
        }

        public function GetGridPosition():int
        {
            return (this.mBuildingGridPos);
        }

        public function isPremiumSlot():Boolean
        {
            return (this.mExpireAt > 0.1);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }


    }
}
