package TimedProduction
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import nLib.cLog;
    import flash.events.Event;
    import Communication.VO.dUniqueID;
    import Communication.VO.dTimedProductionVO;
    import Enums.DIRTY_INDICATOR;
    import mx.events.PropertyChangeEvent;

    public class cTimedProduction implements IEventDispatcher 
    {

        private var _bindingEventDispatcher:EventDispatcher;
        private var mHasStarted:Boolean = false;
        private var mProductionOrder:iProductionOrder;
        public var mDirtyIndicator:int;
        private var mWaitingForServer:Boolean;
        private var _1098885459mProductionProgress:Number = 0;
        public var readyForDeliver:Boolean = false;

        public function cTimedProduction(_arg_1:iProductionOrder)
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            if (((_arg_1 == null) || (_arg_1.GetProductionVO() == null)))
            {
                cLog.warning(("No production Order for TimedProduction set! Ignoring." + _arg_1));
                return;
            };
            this.mProductionOrder = _arg_1;
            this.mProductionProgress = Math.min((this.mProductionOrder.GetProductionVO().collectedTime / this.GetProductionTime()), 1);
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function SetWaitingForServer(_arg_1:Boolean):void
        {
            this.mWaitingForServer = _arg_1;
        }

        public function GetUniqueID():dUniqueID
        {
            return (this.mProductionOrder.GetProductionVO().uniqueId);
        }

        public function GetProducedItems():int
        {
            return (this.mProductionOrder.GetProductionVO().producedItems);
        }

        public function CreateTimedProductionVO():dTimedProductionVO
        {
            return (this.mProductionOrder.GetProductionVO());
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function GetPlayerID():int
        {
            return (this.mProductionOrder.GetProductionVO().playerId);
        }

        [Bindable(event="propertyChange")]
        public function get mProductionProgress():Number
        {
            return (this._1098885459mProductionProgress);
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function GetType():String
        {
            return (this.mProductionOrder.GetProductionVO().type_string);
        }

        public function IncCollectedTime(_arg_1:Number, _arg_2:Boolean):Boolean
        {
            this.mHasStarted = true;
            if (this.mProductionOrder.GetProductionVO().producedItems >= this.mProductionOrder.GetProductionVO().amount)
            {
                this.mProductionOrder.GetProductionVO().collectedTime = this.GetProductionTime();
                this.mProductionProgress = 1;
                this.readyForDeliver = true;
                return (false);
            };
            if (((_arg_1 > 0) && (!(_arg_2))))
            {
                this.mProductionOrder.GetProductionVO().collectedTime = (this.mProductionOrder.GetProductionVO().collectedTime + (_arg_1 * this.mProductionOrder.GetTimeBonus()));
            }
            else
            {
                this.mProductionOrder.GetProductionVO().collectedTime = (this.mProductionOrder.GetProductionVO().collectedTime + _arg_1);
            };
            this.mProductionProgress = Math.min((this.mProductionOrder.GetProductionVO().collectedTime / this.GetProductionTime()), 1);
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.WEAK_MODIFICATION_BIT);
            if (this.mProductionOrder.GetProductionVO().collectedTime >= this.GetProductionTime())
            {
                this.SetProducedItems((this.mProductionOrder.GetProductionVO().producedItems + 1));
                if (this.mProductionOrder.GetProductionVO().producedItems >= this.mProductionOrder.GetProductionVO().amount)
                {
                    this.readyForDeliver = true;
                }
                else
                {
                    this.mProductionOrder.GetProductionVO().collectedTime = (this.mProductionOrder.GetProductionVO().collectedTime - this.GetProductionTime());
                };
            };
            return (true);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function SetPlayerID(_arg_1:int):void
        {
            this.mProductionOrder.GetProductionVO().playerId = _arg_1;
        }

        public function GetCollectedTime():Number
        {
            return (this.mProductionOrder.GetProductionVO().collectedTime);
        }

        public function GetInstantBuildCosts():int
        {
            return ((this.mProductionOrder.GetProductionVO().amount - this.mProductionOrder.GetProductionVO().producedItems) * this.mProductionOrder.GetInstantBuildCosts());
        }

        public function GetInstantBuildCostsUnmodified():int
        {
            return ((this.mProductionOrder.GetProductionVO().amount - this.mProductionOrder.GetProductionVO().producedItems) * this.mProductionOrder.GetInstantBuildCostsUnmodified());
        }

        public function HasStarted():Boolean
        {
            if (((!(this.mHasStarted)) && ((this.mProductionOrder.GetProductionVO().producedItems > 0) || (this.mProductionOrder.GetProductionVO().collectedTime > 0))))
            {
                this.mHasStarted = true;
            };
            return (this.mHasStarted);
        }

        public function GetProductionType():int
        {
            return (this.mProductionOrder.GetProductionVO().productionType);
        }

        public function set mProductionProgress(_arg_1:Number):void
        {
            var _local_2:Object = this._1098885459mProductionProgress;
            if (_local_2 !== _arg_1)
            {
                this._1098885459mProductionProgress = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mProductionProgress", _local_2, _arg_1));
            };
        }

        public function GetAmount():int
        {
            return (this.mProductionOrder.GetProductionVO().amount);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function GetWaitingForServer():Boolean
        {
            return (this.mWaitingForServer);
        }

        public function SetProducedItems(_arg_1:int):void
        {
            this.mProductionOrder.GetProductionVO().producedItems = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function toString():String
        {
            return (((((((((("<TimedProduction " + this.GetProducedItems()) + "/") + this.GetAmount()) + " '") + this.GetType()) + "', collectedTime=") + this.GetCollectedTime()) + "/") + this.GetCollectedTime()) + " >");
        }

        public function GetProductionTime():int
        {
            return (this.mProductionOrder.GetProductionTime());
        }

        public function GetProductionOrder():iProductionOrder
        {
            return (this.mProductionOrder);
        }


    }
}
