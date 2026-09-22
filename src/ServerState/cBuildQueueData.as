package ServerState
{
    import Model.Notifier;
    import Interface.cGeneralInterface;
    import __AS3__.vec.Vector;
    import GO.cBuilding;
    import GO.cBuildSlot;
    import Enums.DIRTY_INDICATOR;
    import Enums.COMMAND;
    import Communication.VO.dTempBuildSlotVO;
    import Communication.VO.dGameTickCommandVO;
    import Communication.VO.dBuildingVO;
    import Communication.VO.dBuildQueueVO;
    import __AS3__.vec.*;
    import nLib.*;
    import Enums.*;

    public class cBuildQueueData extends Notifier 
    {

        private var mUserNotified:Boolean = false;
        private var mMaxCount:int = 3;
        public var mDirtyIndicator:int;
        private var mGeneralInterface:cGeneralInterface;
        private var mBlocked:Boolean;
        private var mNoBuildMaterial:Boolean;
        private var mWaitForBuildqueueMovedCommand:Boolean = false;
        private var mShowNoBuildMaterialMessageCntr:Number;
        private var mPlayerData:cPlayerData;

        private var mQueue_vector:Vector.<cBuilding> = new Vector.<cBuilding>();
        private var mTempBuildSlots_vector:Vector.<cBuildSlot> = new Vector.<cBuildSlot>();

        public function cBuildQueueData(_arg_1:cGeneralInterface, _arg_2:cPlayerData)
        {
            super();
            this.mGeneralInterface = _arg_1;
            this.mPlayerData = _arg_2;
        }

        public function Add(_arg_1:cBuilding):Boolean
        {
            if (this.mQueue_vector.length < this.GetTotalAvailableSlots())
            {
                this.mQueue_vector.push(_arg_1);
                notifyPropertyObserver("mQueue_vector", this.mQueue_vector);
                this.ReadjustGridPositionsOfTempSlotsFrom(((this.mQueue_vector.length - 1) - (this.GetMaxCount() + this.mPlayerData.GetPermanentBuildQueueSlotsCount())));
                this.UpdateGUI();
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
                return (true);
            };
            return (false);
        }

        public function IsBuildingInBuildQueue(_arg_1:int):Boolean
        {
            var _local_2:int = this.GetBuildingWithIndex(_arg_1);
            if (_local_2 < 0)
            {
                return (false);
            };
            return (true);
        }

        public function GetQueue_vector():Vector.<cBuilding>
        {
            return (this.mQueue_vector);
        }

        public function MoveDownGui(_arg_1:int):void
        {
            var _local_2:int = this.GetBuildingWithIndex(_arg_1);
            if (_local_2 < 0)
            {
                return;
            };
            if (_local_2 >= (this.mQueue_vector.length - 1))
            {
                return;
            };
            if (!this.mWaitForBuildqueueMovedCommand)
            {
                this.SetBuildqueueBusy(true);
                this.mGeneralInterface.SendServerAction(COMMAND.BUILDQUEUE_MOVE_DOWN, 0, _arg_1, 0, null);
                this.UpdateGUI();
            };
        }

        public function UpdateGUI():void
        {
            globalFlash.gui.mBuildQueue.SetData(this.mQueue_vector);
        }

        private function removeTempSlot(_arg_1:dTempBuildSlotVO):void
        {
            global.ui.mClientMessages.SendMessagetoServer(COMMAND.REMOVE_TEMP_BUILD_SLOT, this.mGeneralInterface.mHomePlayer.GetHomeZoneId(), _arg_1);
            var _local_2:int;
            while (_local_2 < this.mTempBuildSlots_vector.length)
            {
                if (this.mTempBuildSlots_vector[_local_2].GetTimeOfPurchase() == _arg_1.timeOfPurchase)
                {
                    this.mTempBuildSlots_vector.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function SetBlockedUntilBuildQueueIsProceedAndRemoveBuildqueueCommands():void
        {
            var _local_2:dGameTickCommandVO;
            var _local_1:int;
            while (_local_1 < this.mGeneralInterface.mGameTickCommand_vector.length)
            {
                _local_2 = this.mGeneralInterface.mGameTickCommand_vector[_local_1];
                switch (_local_2.mode)
                {
                    case COMMAND.BUILDQUEUE_MOVE_UP:
                    case COMMAND.BUILDQUEUE_MOVE_DOWN:
                    case COMMAND.BUILDQUEUE_REMOVE:
                        this.mGeneralInterface.mGameTickCommand_vector.splice(_local_1, 1);
                        _local_1--;
                        break;
                };
                _local_1++;
            };
            this.SetBuildqueueBusy(false);
            this.mBlocked = true;
        }

        public function Remove(_arg_1:int):void
        {
            var _local_2:int = this.GetBuildingWithIndex(_arg_1);
            if (_local_2 < 0)
            {
                return;
            };
            this.SetBuildqueueBusy(false);
            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.DeconstructBuildingGridPos(_arg_1);
            this.mGeneralInterface.UnselectBuilding();
            this.RemoveBuildingFromQueue(_arg_1);
        }

        public function IsBuildingAtGridPositionInQueue(_arg_1:int):Boolean
        {
            var _local_2:cBuilding;
            for each (_local_2 in this.mQueue_vector)
            {
                if (_local_2.GetGrid() == _arg_1)
                {
                    return (true);
                };
            };
            return (false);
        }

        private function updateTempSlotsTimer():void
        {
            var _local_1:int = (this.GetMaxCount() + this.mPlayerData.GetPermanentBuildQueueSlotsCount());
            var _local_2:int;
            while (_local_2 < this.mTempBuildSlots_vector.length)
            {
                if (!this.mTempBuildSlots_vector[_local_2].updateTimeLeft(this.mGeneralInterface.GetClientTime()))
                {
                    if (this.mTempBuildSlots_vector[_local_2].GetGridPosition() <= 0)
                    {
                        this.updateTempSlots();
                    };
                };
                _local_2++;
            };
        }

        public function MoveUpGui(_arg_1:int):void
        {
            var _local_2:int = this.GetBuildingWithIndex(_arg_1);
            if (_local_2 < 1)
            {
                return;
            };
            if (!this.mWaitForBuildqueueMovedCommand)
            {
                this.SetBuildqueueBusy(true);
                this.mGeneralInterface.SendServerAction(COMMAND.BUILDQUEUE_MOVE_UP, 0, _arg_1, 0, null);
                this.UpdateGUI();
            };
        }

        public function Init(_arg_1:dBuildQueueVO):void
        {
            var _local_2:dBuildingVO;
            var _local_3:cBuilding;
            if (_arg_1 == null)
            {
                this.mQueue_vector = new Vector.<cBuilding>();
            }
            else
            {
                this.mMaxCount = _arg_1.maxCount;
                for each (_local_2 in _arg_1.buildings)
                {
                    for each (_local_3 in this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector())
                    {
                        if (null != _local_3)
                        {
                            if (_local_3.GetGrid() == _local_2.buildingGrid)
                            {
                                this.mQueue_vector.push(_local_3);
                                break;
                            };
                        };
                    };
                };
                this.updateTempSlots();
            };
            this.mWaitForBuildqueueMovedCommand = false;
            this.mBlocked = false;
            if (globalFlash.gui.mBuildQueue != null)
            {
                this.UpdateGUI();
            };
        }

        public function MoveDown(_arg_1:int):void
        {
            var _local_2:int = this.GetBuildingWithIndex(_arg_1);
            if (_local_2 < 0)
            {
                return;
            };
            if (_local_2 == 0)
            {
                if (this.GetCurrentBuildingProcess().GetBuildingMode() >= cBuilding.BUILDING_MODE_SET_BUILDING_GROUND_PLACE)
                {
                    return;
                };
            };
            if (_local_2 >= (this.mQueue_vector.length - 1))
            {
                return;
            };
            var _local_3:int = (this.GetMaxCount() + this.mPlayerData.GetPermanentBuildQueueSlotsCount());
            if (((_local_2 >= (_local_3 - 1)) && (this.mTempBuildSlots_vector.length <= ((_local_2 - _local_3) + 1))))
            {
                return;
            };
            this.SetBuildqueueBusy(false);
            var _local_4:cBuilding = this.mQueue_vector[_local_2];
            this.mQueue_vector[_local_2] = this.mQueue_vector[(_local_2 + 1)];
            this.mQueue_vector[(_local_2 + 1)] = _local_4;
            if (_local_2 >= _local_3)
            {
                this.mTempBuildSlots_vector[(_local_2 - _local_3)].SetBuildingGridPosition(this.mQueue_vector[_local_2].GetGrid());
                this.mTempBuildSlots_vector[((_local_2 + 1) - _local_3)].SetBuildingGridPosition(this.mQueue_vector[(_local_2 + 1)].GetGrid());
                this.mPlayerData.UpdateGridPositionForAvailableTempSlotsWith(this.mTempBuildSlots_vector[(_local_2 - _local_3)].GetTimeOfPurchase(), this.mTempBuildSlots_vector[(_local_2 - _local_3)].GetGridPosition());
                this.mPlayerData.UpdateGridPositionForAvailableTempSlotsWith(this.mTempBuildSlots_vector[((_local_2 + 1) - _local_3)].GetTimeOfPurchase(), this.mTempBuildSlots_vector[((_local_2 + 1) - _local_3)].GetGridPosition());
            }
            else
            {
                if (_local_2 == (_local_3 - 1))
                {
                    this.mTempBuildSlots_vector[((_local_2 + 1) - _local_3)].SetBuildingGridPosition(this.mQueue_vector[(_local_2 + 1)].GetGrid());
                    this.mPlayerData.UpdateGridPositionForAvailableTempSlotsWith(this.mTempBuildSlots_vector[((_local_2 + 1) - _local_3)].GetTimeOfPurchase(), this.mTempBuildSlots_vector[((_local_2 + 1) - _local_3)].GetGridPosition());
                };
            };
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            this.UpdateGUI();
        }

        public function AreMoveButtonsDisabled():Boolean
        {
            return ((this.mWaitForBuildqueueMovedCommand) || (this.mBlocked));
        }

        public function GetTotalAvailableSlots():int
        {
            return ((this.mMaxCount + this.mPlayerData.GetPermanentBuildQueueSlotsCount()) + this.mTempBuildSlots_vector.length);
        }

        public function ComputeBuildQueue():void
        {
            var _local_1:cBuilding;
            var _local_2:cResources;
            if (this.mBlocked)
            {
                this.mBlocked = false;
                globalFlash.gui.mToolboxPanel.Refresh();
            };
            this.mNoBuildMaterial = false;
            if (this.mQueue_vector.length > 0)
            {
                _local_1 = this.mQueue_vector[0];
                if (_local_1.GetBuildingMode() == cBuilding.BUILDING_MODE_QUEUED)
                {
                    _local_2 = this.mGeneralInterface.mCurrentPlayerZone.GetResourcesForPlayerID(_local_1.getPlayerID());
                    if (((!(_local_2 == null)) && (_local_2.CanPlayerAffordBuilding(_local_1.GetBuildingName_string()))))
                    {
                        this.mUserNotified = false;
                        _local_1.mBuildingCreationTime = this.mGeneralInterface.GetClientTime();
                        _local_1.mBuildingProgress = 0;
                        _local_1.Buy();
                        _local_1.SetBuildingMode(cBuilding.BUILDING_MODE_SET_BUILDING_GROUND_PLACE);
                        this.UpdateGUI();
                    }
                    else
                    {
                        if (!this.mUserNotified)
                        {
                            this.UpdateGUI();
                            this.mUserNotified = true;
                        };
                        if (_local_1.GetResourceCreation() != null)
                        {
                            _local_1.GetResourceCreation().SetProductionState(cResourceCreation.PRODUCTIONSTATE_ERROR_NECESSARY_RESOURCE_MISSING);
                        };
                        this.mNoBuildMaterial = true;
                    };
                }
                else
                {
                    if (!_local_1.IsInConstructionMode())
                    {
                        this.SetBlockedUntilBuildQueueIsProceedAndRemoveBuildqueueCommands();
                        this.mQueue_vector.shift();
                        this.ReadjustGridPositionsOfTempSlotsFrom(-1);
                        this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
                        this.UpdateGUI();
                    };
                };
                if (this.mTempBuildSlots_vector.length > 0)
                {
                    this.updateTempSlotsTimer();
                };
            };
        }

        public function IsBlockedUntilBuildQueueIsProceed():Boolean
        {
            return (this.mBlocked);
        }

        private function TempSlotPosInVector(_arg_1:cBuildSlot):int
        {
            if (_arg_1 == null)
            {
                return (-1);
            };
            var _local_2:int;
            while (_local_2 < this.mTempBuildSlots_vector.length)
            {
                if (_arg_1.GetTimeOfPurchase() == this.mTempBuildSlots_vector[_local_2].GetTimeOfPurchase())
                {
                    return (_local_2);
                };
                _local_2++;
            };
            return (-1);
        }

        private function GetTempSlotWithIndex(_arg_1:int):int
        {
            var _local_3:cBuildSlot;
            var _local_2:int = -1;
            for each (_local_3 in this.mTempBuildSlots_vector)
            {
                _local_2++;
                if (_local_3.GetGridPosition() == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (-1);
        }

        public function SetBlockedUntilBuildQueueIsProceed():void
        {
            this.mBlocked = true;
        }

        public function GetCurrentBuildingProcess():cBuilding
        {
            if (this.mQueue_vector.length > 0)
            {
                return (this.mQueue_vector[0]);
            };
            return (null);
        }

        private function GetBuildingWithIndex(_arg_1:int):int
        {
            var _local_3:cBuilding;
            var _local_2:int = -1;
            for each (_local_3 in this.mQueue_vector)
            {
                _local_2++;
                if (_local_3.GetGrid() == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (-1);
        }

        public function ReadjustGridPositionsOfTempSlotsFrom(_arg_1:int):void
        {
            var _local_5:Boolean;
            var _local_2:int = (this.GetMaxCount() + this.mPlayerData.GetPermanentBuildQueueSlotsCount());
            var _local_3:Boolean;
            if (_arg_1 < 0)
            {
                _arg_1 = 0;
            };
            var _local_4:int = _arg_1;
            while (_local_4 < this.mTempBuildSlots_vector.length)
            {
                if ((_local_2 + _local_4) < this.mQueue_vector.length)
                {
                    _local_5 = this.mTempBuildSlots_vector[_local_4].updateTimeLeft(this.mGeneralInterface.GetClientTime());
                    if (((_local_5) || ((!(_local_5)) && (_local_3))))
                    {
                        this.mTempBuildSlots_vector[_local_4].SetBuildingGridPosition(this.mQueue_vector[(_local_2 + _local_4)].GetGrid());
                    }
                    else
                    {
                        this.mTempBuildSlots_vector[_local_4].SetBuildingGridPosition(0);
                        _local_3 = true;
                    };
                }
                else
                {
                    if (((_local_3) && (((_local_2 + _local_4) - 1) < this.mQueue_vector.length)))
                    {
                        this.mTempBuildSlots_vector[_local_4].SetBuildingGridPosition(this.mQueue_vector[((_local_2 + _local_4) - 1)].GetGrid());
                    }
                    else
                    {
                        this.mTempBuildSlots_vector[_local_4].SetBuildingGridPosition(0);
                    };
                };
                this.mPlayerData.UpdateGridPositionForAvailableTempSlotsWith(this.mTempBuildSlots_vector[_local_4].GetTimeOfPurchase(), this.mTempBuildSlots_vector[_local_4].GetGridPosition());
                _local_4++;
            };
        }

        public function GetTempSlots_vector():Vector.<cBuildSlot>
        {
            return (this.mTempBuildSlots_vector);
        }

        private function SetBuildqueueBusy(_arg_1:Boolean):void
        {
            this.mWaitForBuildqueueMovedCommand = _arg_1;
        }

        public function GetMaxCount():int
        {
            return (this.mMaxCount);
        }

        public function MoveUp(_arg_1:int):void
        {
            var _local_2:int = this.GetBuildingWithIndex(_arg_1);
            if (_local_2 < 1)
            {
                return;
            };
            if (_local_2 == 1)
            {
                if (this.GetCurrentBuildingProcess().GetBuildingMode() >= cBuilding.BUILDING_MODE_SET_BUILDING_GROUND_PLACE)
                {
                    return;
                };
            };
            this.SetBuildqueueBusy(false);
            var _local_3:cBuilding = this.mQueue_vector[_local_2];
            this.mQueue_vector[_local_2] = this.mQueue_vector[(_local_2 - 1)];
            this.mQueue_vector[(_local_2 - 1)] = _local_3;
            var _local_4:int = (this.GetMaxCount() + this.mPlayerData.GetPermanentBuildQueueSlotsCount());
            if (_local_2 > _local_4)
            {
                this.mTempBuildSlots_vector[(_local_2 - _local_4)].SetBuildingGridPosition(this.mQueue_vector[_local_2].GetGrid());
                this.mTempBuildSlots_vector[((_local_2 - 1) - _local_4)].SetBuildingGridPosition(this.mQueue_vector[(_local_2 - 1)].GetGrid());
                this.mPlayerData.UpdateGridPositionForAvailableTempSlotsWith(this.mTempBuildSlots_vector[(_local_2 - _local_4)].GetTimeOfPurchase(), this.mTempBuildSlots_vector[(_local_2 - _local_4)].GetGridPosition());
                this.mPlayerData.UpdateGridPositionForAvailableTempSlotsWith(this.mTempBuildSlots_vector[((_local_2 - 1) - _local_4)].GetTimeOfPurchase(), this.mTempBuildSlots_vector[((_local_2 - 1) - _local_4)].GetGridPosition());
            }
            else
            {
                if (((_local_2 == _local_4) && (this.mTempBuildSlots_vector.length > 0)))
                {
                    this.mTempBuildSlots_vector[(_local_2 - _local_4)].SetBuildingGridPosition(this.mQueue_vector[_local_4].GetGrid());
                    this.mPlayerData.UpdateGridPositionForAvailableTempSlotsWith(this.mTempBuildSlots_vector[(_local_2 - _local_4)].GetTimeOfPurchase(), this.mTempBuildSlots_vector[(_local_2 - _local_4)].GetGridPosition());
                };
            };
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            this.UpdateGUI();
        }

        public function SetMaxCount(_arg_1:int):void
        {
            this.mMaxCount = _arg_1;
        }

        public function RemoveBuildingFromQueue(_arg_1:int):void
        {
            var _local_2:int = this.GetBuildingWithIndex(_arg_1);
            if (_local_2 < 0)
            {
                return;
            };
            this.mQueue_vector.splice(_local_2, 1);
            this.ReadjustGridPositionsOfTempSlotsFrom(this.GetTempSlotWithIndex(_arg_1));
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            this.UpdateGUI();
        }

        public function RemoveGui(_arg_1:int):void
        {
            var _local_2:int = this.GetBuildingWithIndex(_arg_1);
            if (_local_2 < 0)
            {
                return;
            };
            if (!this.mWaitForBuildqueueMovedCommand)
            {
                this.SetBuildqueueBusy(true);
                this.mGeneralInterface.SendServerAction(COMMAND.BUILDQUEUE_REMOVE, 0, _arg_1, 0, null);
                this.UpdateGUI();
            };
        }

        public function updateTempSlots():void
        {
            var _local_3:dTempBuildSlotVO;
            var _local_4:cBuildSlot;
            var _local_5:int;
            var _local_1:int = this.mTempBuildSlots_vector.length;
            var _local_2:int;
            for each (_local_3 in this.mPlayerData.mAvailableTempSlots_vector)
            {
                if (_local_3.isPremiumSlot())
                {
                    _local_2++;
                };
                _local_4 = new cBuildSlot(_local_3.timeOfPurchase, _local_3.buildingGridPos, _local_3.expireAt);
                _local_4.mType = cBuildSlot.TEMPORARY_BUILDSLOT;
                _local_5 = this.TempSlotPosInVector(_local_4);
                if (_local_4.updateTimeLeft(this.mGeneralInterface.GetClientTime()))
                {
                    if (_local_5 < 0)
                    {
                        this.mTempBuildSlots_vector.push(_local_4);
                    }
                    else
                    {
                        this.mTempBuildSlots_vector[_local_5].SetExpireAt(_local_4.GetExpireAt());
                    };
                }
                else
                {
                    if ((((_local_5 >= 0) && (this.mTempBuildSlots_vector[_local_5].GetGridPosition() > 0)) || ((_local_5 < 0) && (_local_4.GetGridPosition() > 0))))
                    {
                        if (((_local_5 < 0) && (this.IsBuildingAtGridPositionInQueue(_local_4.GetGridPosition()))))
                        {
                            this.mTempBuildSlots_vector.push(_local_4);
                        };
                    }
                    else
                    {
                        this.removeTempSlot(_local_3);
                    };
                };
            };
            if (((!(globalFlash.gui.mBuildQueue == null)) && (!(this.mTempBuildSlots_vector.length == _local_1))))
            {
                globalFlash.gui.mBuildQueue.SetEnableBuyTempBuildSlot(((this.mTempBuildSlots_vector.length - _local_2) < global.maxTempSlotsAvailablePerPlayer));
                this.UpdateGUI();
            };
        }

        public function IsFull():Boolean
        {
            return ((this.mQueue_vector.length + this.mPlayerData.GetPrePlacesBuildingCounter()) >= this.GetTotalAvailableSlots());
        }

        public function IsAnythingInBuildqueue():Boolean
        {
            return (this.mQueue_vector.length >= 2);
        }


    }
}
