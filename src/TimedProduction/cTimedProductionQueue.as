package TimedProduction
{
    import Model.Notifier;
    import GO.cBuilding;
    import __AS3__.vec.Vector;
    import Interface.cGeneralInterface;
    import Enums.DIRTY_INDICATOR;
    import ServerState.cPlayerData;
    import ServerState.dResource;
    import ServerState.cResources;
    import nLib.cLog;
    import Enums.TIMED_PRODUCTION_TYPE;
    import Communication.VO.dUniqueID;
    import nLib.gMisc;
    import Enums.ModifyReason;
    import Utils.TriggerUtils;
    import __AS3__.vec.*;

    public class cTimedProductionQueue extends Notifier 
    {

        public static var PRODUCTION_START:String = "ProductionStart";
        public static var PRODUCTION_FINISH:String = "ProductionFinish";

        private const TIMEOUT:int = 30000;

        private var mLastServerCall:int = 0;
        public var productionBuilding:cBuilding;
        private var mWaitingForServerResponse:Boolean = false;
        public var mProductionType:int;
        public var hasStackingBonus:Boolean;
        public var waitForPickup:Boolean;
        public var mTimedProductions_vector:Vector.<cTimedProduction>;
        private var productionReadyAvatarType:String;
        private var mGeneralInterface:cGeneralInterface;

        public function cTimedProductionQueue(_arg_1:cGeneralInterface, _arg_2:int, _arg_3:cBuilding, _arg_4:Boolean, _arg_5:String, _arg_6:Boolean)
        {
            super();
            this.mGeneralInterface = _arg_1;
            this.mProductionType = _arg_2;
            this.productionBuilding = _arg_3;
            this.waitForPickup = _arg_4;
            this.productionReadyAvatarType = _arg_5;
            this.hasStackingBonus = _arg_6;
            _arg_1.mCurrentPlayerZone.setProductionQueue(this);
            this.mTimedProductions_vector = new Vector.<cTimedProduction>();
        }

        public function Perform(_arg_1:cPlayerData):void
        {
            var _local_3:Boolean;
            if (this.mTimedProductions_vector.length == 0)
            {
                return;
            };
            var _local_2:cTimedProduction = this.mTimedProductions_vector[0];
            if (!_local_2.readyForDeliver)
            {
                if (!this.productionBuilding.IsUpgradeInProgress())
                {
                    _local_3 = _local_2.IncCollectedTime(this.mGeneralInterface.mClientDeltaTime, false);
                    if (((((_local_3) && (_local_2.readyForDeliver)) && (this.productionReadyAvatarType)) && (this.productionReadyAvatarType.length > 0)))
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(this.productionReadyAvatarType);
                    };
                }
                else
                {
                    _local_2.IncCollectedTime(0, false);
                    this.mTimedProductions_vector[0].mDirtyIndicator = (this.mTimedProductions_vector[0].mDirtyIndicator | DIRTY_INDICATOR.WEAK_MODIFICATION_BIT);
                };
            };
            if (((!(this.waitForPickup)) && (_local_2.readyForDeliver)))
            {
                this.deliver(_arg_1, true);
            };
        }

        public function cancelAllWaiting(_arg_1:cPlayerData):void
        {
            var _local_2:int = (this.mTimedProductions_vector.length - 1);
            while (_local_2 > 0)
            {
                this.cancelProduction(this.mTimedProductions_vector[_local_2].GetUniqueID(), true, _arg_1);
                _local_2--;
            };
        }

        public function cancelAll(_arg_1:cPlayerData):void
        {
            var _local_2:int = (this.mTimedProductions_vector.length - 1);
            while (_local_2 >= 0)
            {
                this.cancelProduction(this.mTimedProductions_vector[_local_2].GetUniqueID(), true, _arg_1);
                _local_2--;
            };
        }

        public function SetProductionToRedyForPickUp(_arg_1:cPlayerData):void
        {
            if (this.mTimedProductions_vector.length == 0)
            {
                return;
            };
            var _local_2:cTimedProduction = this.mTimedProductions_vector[0];
            _local_2.IncCollectedTime(_local_2.GetProductionTime(), false);
        }

        public function cancelProduction(_arg_1:dUniqueID, _arg_2:Boolean, _arg_3:cPlayerData):void
        {
            var _local_6:cTimedProduction;
            var _local_9:dResource;
            var _local_10:cResources;
            var _local_4:cTimedProduction;
            var _local_5:int;
            for each (_local_6 in this.mTimedProductions_vector)
            {
                if (_local_6.GetUniqueID().eq(_arg_1))
                {
                    _local_4 = _local_6;
                    break;
                };
                _local_5++;
            };
            if (((_local_4 == null) || ((!(_arg_2)) && (_local_4.HasStarted()))))
            {
                if (_local_4 != null)
                {
                    _local_4.SetWaitingForServer(false);
                };
                cLog.warning("CancelProduction: Couldn't find production or production was already started!");
                return;
            };
            this.mTimedProductions_vector.splice(_local_5, 1);
            notifyPropertyObserver(cTimedProductionQueue.PRODUCTION_FINISH, _local_4);
            var _local_7:Vector.<dResource> = new Vector.<dResource>();
            var _local_8:dResource;
            for each (_local_9 in _local_4.GetProductionOrder().GetCostsToBuy_vector())
            {
                if (_local_9.name_string == defines.POPULATION_RESOURCE_NAME_string)
                {
                    if (TIMED_PRODUCTION_TYPE.isMilitaryProductionType(_local_4.GetProductionType()))
                    {
                        _local_8 = _local_9;
                    }
                    else
                    {
                        _local_7.push(_local_9);
                    };
                }
                else
                {
                    _local_7.push(_local_9);
                };
            };
            _local_10 = this.mGeneralInterface.mCurrentPlayerZone.GetResourcesForPlayerID(_local_4.GetPlayerID());
            _local_10.RefundPlayerResourcesFromResourcesInListInPercent(_local_7, (_local_4.GetAmount() * 100), _arg_3, true);
            if (_local_8 != null)
            {
                _local_10.FreeMilitary((_local_4.GetAmount() * _local_8.amount));
            };
        }

        public function SetAllProductionWaitingForServer(_arg_1:Boolean):void
        {
            var _local_2:cTimedProduction;
            for each (_local_2 in this.mTimedProductions_vector)
            {
                _local_2.SetWaitingForServer(_arg_1);
            };
        }

        public function SetWaitingForServer(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mLastServerCall = gMisc.GetTimeSinceStartup();
            }
            else
            {
                this.mLastServerCall = 0;
            };
            this.mWaitingForServerResponse = _arg_1;
        }

        public function deliver(_arg_1:cPlayerData, _arg_2:Boolean):void
        {
            if (this.mTimedProductions_vector.length == 0)
            {
                return;
            };
            var _local_3:cTimedProduction = this.mTimedProductions_vector[0];
            if (!_local_3.readyForDeliver)
            {
                return;
            };
            this.finishProduction(_arg_1, _arg_2);
        }

        public function finishProduction(_arg_1:cPlayerData, _arg_2:Boolean):void
        {
            if (this.mTimedProductions_vector.length == 0)
            {
                return;
            };
            var _local_3:cTimedProduction = this.mTimedProductions_vector[0];
            _local_3.GetProductionOrder().CreateItem(_arg_1, this.mGeneralInterface, ModifyReason.PRODUCTION);
            if (_local_3.GetProductionOrder().GetOnFinishedAvatarMessageType() != null)
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(_local_3.GetProductionOrder().GetOnFinishedAvatarMessageType(), _local_3);
            };
            this.mTimedProductions_vector.splice(0, 1);
            notifyPropertyObserver(cTimedProductionQueue.PRODUCTION_FINISH, _local_3);
            this.mGeneralInterface.channels.TIMED_PRODUCTION.send(TriggerUtils.TIMED_PRODUCED_ITEMS_PROPERTY_NAME, _local_3);
            if (this.mTimedProductions_vector.length > 0)
            {
                if (_arg_2)
                {
                    this.mTimedProductions_vector[0].IncCollectedTime((_local_3.GetCollectedTime() - _local_3.GetProductionTime()), true);
                };
                this.mTimedProductions_vector[0].mDirtyIndicator = (this.mTimedProductions_vector[0].mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
        }

        public function GetWaitingForServer():Boolean
        {
            if (((this.mLastServerCall > 0) && (this.mLastServerCall < (gMisc.GetTimeSinceStartup() - this.TIMEOUT))))
            {
                this.mWaitingForServerResponse = false;
                if (cLog.isInfoEnabled())
                {
                    cLog.info(("No server response for 30 seconds in: " + this));
                };
            };
            return (this.mWaitingForServerResponse);
        }

        public function addProduction(_arg_1:cTimedProduction):void
        {
            this.mTimedProductions_vector.push(_arg_1);
            notifyPropertyObserver(cTimedProductionQueue.PRODUCTION_START, _arg_1);
        }


    }
}
