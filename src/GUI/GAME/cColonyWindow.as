package GUI.GAME
{
    import Interface.cGameInterface;
    import ServerState.dResourceDefaultDefinition;
    import GUI.Components.ColonyWindow;
    import GUI.Loca.cLocaManager;
    import flash.utils.Timer;
    import flash.events.MouseEvent;
    import mx.events.FlexEvent;
    import mx.controls.Alert;
    import Communication.VO.ColonyCommandVO;
    import Enums.COMMAND;
    import mx.events.CloseEvent;
    import Enums.KILL_SWITCH;
    import GUI.Components.CustomAlert;
    import Communication.VO.ColonyVO;
    import com.bluebyte.tso.util.TimeUtil;
    import flash.events.TimerEvent;
    import mx.events.ListEvent;
    import BuffSystem.cBuffDefinition;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import AdventureSystem.cAdventureDefinition;
    import ServerState.dResource;
    import Communication.VO.dRequirementsVO;
    import Communication.VO.dRequirementVO;
    import flash.utils.Dictionary;
    import Enums.LOCA_GROUP;
    import __AS3__.vec.Vector;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import Colony.cColony;
    import GUI.helpers.PVPClientUtil;
    import Utils.PVPUtil;
    import Enums.PICKUP_PROVIDER_TYPE;
    import flash.events.Event;
    import __AS3__.vec.*;

    public class cColonyWindow extends cBasicPanel 
    {

        private var mCurrentColonyID:int = 0;
        private var mGI:cGameInterface;
        private var mCurrentExpeditionZoneID:int = 0;
        private var mSelectedResource:dResourceDefaultDefinition;
        public var mPanel:ColonyWindow;
        private var playerCanOpen:Boolean = false;
        private var mCurrentExpeditionState:int = -1;
        private var mLM:cLocaManager = cLocaManager.GetInstance();
        private var yieldUpdateTimer:Timer = new Timer(1000, 0);


        private function ClosePanel(_arg_1:MouseEvent):void
        {
            this.Clear();
            this.Hide();
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnClaimColony.addEventListener(MouseEvent.CLICK, this.claimColony);
            this.mPanel.btnBuildDefenses.addEventListener(MouseEvent.CLICK, this.buildDefences);
            this.mPanel.currentColony.addEventListener(MouseEvent.CLICK, this.ItemClickedHandler2);
        }

        private function claimColonyHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            var _local_2:ColonyCommandVO;
            if (this.mCurrentExpeditionZoneID > 0)
            {
                _local_2 = ColonyCommandVO.Create(COMMAND.COLONY_ASSIGN, this.mCurrentExpeditionZoneID);
            }
            else
            {
                _local_2 = ColonyCommandVO.Create(COMMAND.COLONY_ASSIGN, this.mCurrentColonyID);
            };
            global.ui.SendServerActionSimple(COMMAND.COLONY_ASSIGN, _local_2);
            globalFlash.gui.mColonyWindow.mPanel.busyOverlay.visible = true;
        }

        override public function Show():void
        {
            if (this.mGI.killswitch.isAccessible(KILL_SWITCH.PVP_UI_COLONYWINDOW))
            {
                this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                super.Show();
                globalFlash.gui.windowController.setTop(this.mPanel, true);
                this.Refresh();
                if (global.ui.mCurrentPlayerZone.ColonyGetAll().length > 0)
                {
                    global.services.colony.requestYield();
                };
                this.yieldUpdateTimer.start();
                this.yieldUpdateTimerHandler(null);
                this.mPanel.busyOverlay.visible = false;
                this.mPanel.yieldPanel.Update();
            }
            else
            {
                CustomAlert.show("FeatureLockedOnServer", "FeatureLockedOnServer");
            };
        }

        private function yieldUpdateTimerHandler(_arg_1:TimerEvent):void
        {
            var _local_3:ColonyVO;
            var _local_2:Boolean;
            for each (_local_3 in global.ui.mCurrentPlayerZone.ColonyGetAll())
            {
                if (_local_3.colonyYieldStartTime > 0)
                {
                    _local_2 = true;
                    break;
                };
            };
            if (!_local_2)
            {
                return;
            };
            var _local_4:Number = this.mGI.lastColonyYieldCalculationTime;
            if (_local_4 == 0)
            {
                global.services.colony.requestYield();
                return;
            };
            var _local_5:Number = (global.colonyYieldTickTime * 1000);
            var _local_6:Number = TimeUtil.getServerTime();
            var _local_7:Number = (_local_4 + _local_5);
            var _local_8:Number = Math.min(1, Math.max(0, (1 - ((1 / _local_5) * (_local_7 - _local_6)))));
            if (_local_8 == 1)
            {
                this.mPanel.yieldPanel.yieldRemaining = 0;
            }
            else
            {
                this.mPanel.yieldPanel.yieldRemaining = (_local_7 - _local_6);
            };
            if ((((this.mPanel.yieldPanel.progress < 1) && (this.mPanel.yieldPanel.progress > 0.5)) && (_local_8 == 1)))
            {
                global.services.colony.requestYield();
            };
            this.mPanel.yieldPanel.progress = _local_8;
        }

        override protected function HideWithoutQueue():void
        {
            super.HideWithoutQueue();
            this.yieldUpdateTimer.stop();
            this.Clear();
        }

        public function Clear():void
        {
            this.mPanel.currentColony.dataProvider = [];
        }

        public function Init(_arg_1:ColonyWindow):void
        {
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.yieldUpdateTimer.addEventListener(TimerEvent.TIMER, this.yieldUpdateTimerHandler);
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.coloniesList.addEventListener(ListEvent.ITEM_CLICK, this.ItemClickedHandler);
        }

        private function buildDefences(_arg_1:MouseEvent):void
        {
            if (this.mCurrentExpeditionZoneID > defines.ADVENTUREZONEID)
            {
                return;
            };
            this.mGI.visitZone(this.mCurrentExpeditionZoneID);
        }

        private function ItemClickedHandler(_arg_1:ListEvent):void
        {
            globalFlash.gui.windowController.showModal();
        }

        public function isVisible():Boolean
        {
            return (this.mPanel.visible);
        }

        private function claimColony(_arg_1:MouseEvent):void
        {
            CustomAlert.show("ClaimColony", "ClaimColony", (Alert.OK | Alert.CANCEL), null, this.claimColonyHandler, null, Alert.OK, true, CustomAlert.STYLE_DEFAULT);
        }

        public function Refresh():void
        {
            var _local_2:cBuffDefinition;
            var _local_3:int;
            var _local_4:int;
            var _local_5:String;
            var _local_6:int;
            var _local_10:ColonyVO;
            var _local_11:dAdventureClientInfoVO;
            var _local_13:Object;
            var _local_20:String;
            var _local_21:int;
            var _local_22:int;
            var _local_23:cAdventureDefinition;
            var _local_24:int;
            var _local_25:dResource;
            var _local_26:dResource;
            var _local_27:String;
            var _local_28:dResource;
            var _local_29:dResource;
            var _local_30:dRequirementsVO;
            var _local_31:dRequirementVO;
            var _local_32:String;
            if (!this.mPanel.visible)
            {
                return;
            };
            var _local_1:Dictionary = new Dictionary();
            this.mPanel.headline.text = this.mLM.GetText(LOCA_GROUP.LABELS, "Colonies");
            this.mPanel.coloniesList.invalidateList();
            this.mPanel.coloniesList.invalidateDisplayList();
            var _local_7:Array = [];
            var _local_8:Vector.<ColonyVO> = global.ui.mCurrentPlayerZone.ColonyGetAll();
            var _local_9:Vector.<ColonyVO> = _local_8.concat();
            var _local_12:Vector.<dAdventureClientInfoVO> = new Vector.<dAdventureClientInfoVO>();
            for each (_local_11 in AdventureManager.getInstance().getAdventures())
            {
                if (!cColony.IsWaitForAssignmentState(_local_11.colonyStatus))
                {
                    _local_12.push(_local_11);
                };
            };
            this.mPanel.btnClaimColony.enabled = false;
            this.mPanel.btnBuildDefenses.enabled = false;
            _local_13 = {
                "centerMessage":this.mLM.GetText(LOCA_GROUP.DESCRIPTIONS, "ActivateArchipelago"),
                "noSlots":false
            };
            if (_local_12.length == 1)
            {
                _local_11 = _local_12[0];
                _local_23 = cAdventureDefinition.FindAdventureDefinition(_local_11.adventureName);
                this.mCurrentExpeditionZoneID = _local_11.zoneID;
                this.mCurrentExpeditionState = _local_11.status;
                _local_13.centerMessage = "";
                if (_local_23.IsColony())
                {
                    _local_13.state = "active";
                    _local_13.adventureVO = _local_11;
                    if (((_local_8.length > 0) && (_local_8[0].colonyId == _local_11.colonyID)))
                    {
                        _local_13.colonyVO = _local_8[0];
                    };
                    if (_local_8.length >= defines.MAX_NUM_COLONY_SLOTS)
                    {
                        _local_13.noSlots = true;
                    };
                    this.mPanel.btnBuildDefenses.enabled = ((this.mPanel.btnClaimColony.enabled) && (global.ui.killswitch.isAccessible(KILL_SWITCH.PVP_COLONY_DEFENSE)));
                };
            };
            if (_local_8.length > 0)
            {
                if (_local_8.length >= (defines.MAX_NUM_COLONY_SLOTS + 1))
                {
                    _local_13.noSlots = true;
                };
                for each (_local_10 in _local_8)
                {
                    if (cColony.IsAssignableState(_local_10.state))
                    {
                        if (_local_10.state == cColony.STATUS_READY_FOR_DEFENSE_MODE)
                        {
                            this.mCurrentExpeditionZoneID = _local_10.colonyId;
                        }
                        else
                        {
                            this.mCurrentExpeditionZoneID = AdventureManager.getInstance().getAdventureZoneIdForColony(_local_10.colonyId);
                            this.mCurrentColonyID = _local_10.colonyId;
                        };
                        this.mCurrentExpeditionState = _local_10.state;
                        _local_13.state = "active";
                        _local_13.zoneID = this.mCurrentExpeditionZoneID;
                        _local_13.colonyVO = _local_10;
                        _local_9.splice(_local_9.indexOf(_local_10), 1);
                        _local_13.centerMessage = "";
                        this.mPanel.btnClaimColony.enabled = ((this.mGI.mCurrentPlayer.GetColonySlotCount() - _local_8.length) >= 0);
                        this.mPanel.btnBuildDefenses.enabled = global.ui.killswitch.isAccessible(KILL_SWITCH.PVP_COLONY_DEFENSE);
                        break;
                    };
                };
            };
            this.mPanel.currentColony.dataProvider = [_local_13];
            var _local_14:int = (this.mGI.mCurrentPlayer.GetColonySlotCountPermanent() + this.mGI.mCurrentPlayer.GetColonySlotCountTemp());
            var _local_15:int = this.mGI.mCurrentPlayer.GetColonySlotCountTemp();
            var _local_16:int = (defines.MAX_NUM_COLONY_SLOTS - this.mGI.mCurrentPlayer.GetColonySlotCountTempMax());
            var _local_17:int = _local_9.length;
            var _local_18:int;
            while (_local_18 < defines.MAX_NUM_COLONY_SLOTS)
            {
                _local_13 = {};
                if (((_local_18 < _local_9.length) && (_local_18 < this.mGI.mCurrentPlayer.GetColonySlotCountMax())))
                {
                    _local_13.state = "active";
                    _local_13.colonyVO = _local_9[(_local_9.length - _local_17)];
                    _local_25 = PVPClientUtil.getNextColonyYield(this.mGI, _local_13.colonyVO, TimeUtil.getServerTime());
                    if (_local_25.amount > 0)
                    {
                        _local_26 = _local_1[_local_25.name_string];
                        if (!_local_26)
                        {
                            _local_26 = new dResource();
                            _local_26.name_string = _local_25.name_string;
                            _local_1[_local_26.name_string] = _local_26;
                        };
                        _local_26.amount = (_local_26.amount + _local_25.amount);
                        _local_26.producedAmount = (_local_26.producedAmount + _local_25.producedAmount);
                    };
                    _local_17--;
                }
                else
                {
                    _local_27 = "locked";
                    if (_local_18 >= _local_16)
                    {
                        _local_27 = "premium";
                        if (_local_14 > 0)
                        {
                            _local_14--;
                            _local_27 = "free";
                            if (_local_15 > 0)
                            {
                                _local_15--;
                                _local_27 = "freeTemp";
                            };
                            if (_local_17 > 0)
                            {
                                _local_13.state = "active";
                                _local_13.colonyVO = _local_9[(_local_9.length - _local_17)];
                                _local_28 = PVPClientUtil.getNextColonyYield(this.mGI, _local_13.colonyVO, TimeUtil.getServerTime());
                                if (_local_28.amount > 0)
                                {
                                    _local_29 = _local_1[_local_28.name_string];
                                    if (!_local_29)
                                    {
                                        _local_29 = new dResource();
                                        _local_29.name_string = _local_28.name_string;
                                        _local_1[_local_29.name_string] = _local_29;
                                    };
                                    _local_29.amount = (_local_29.amount + _local_28.amount);
                                    _local_29.producedAmount = (_local_29.producedAmount + _local_28.producedAmount);
                                };
                                _local_17--;
                            };
                        };
                    }
                    else
                    {
                        _local_30 = this.mGI.mRequirements.miscRequirements_vector["ColonySlots"];
                        for each (_local_31 in _local_30.requirements)
                        {
                            if (_local_31.amount == (_local_18 + 1))
                            {
                                if (_local_31.fulfilled)
                                {
                                    _local_27 = "free";
                                };
                                break;
                            };
                        };
                        _local_32 = "";
                        if (_local_27 == "locked")
                        {
                            _local_32 = (this.mLM.GetText(LOCA_GROUP.LABELS, "Requires") + ":");
                            _local_32 = (_local_32 + ("\n" + this.mLM.GetText(LOCA_GROUP.LABELS, "Level", [_local_31.value])));
                        };
                        _local_13.centerMessage = _local_32;
                    };
                    _local_13.adventureVO = null;
                    _local_13.state = _local_27;
                };
                if (_local_13.colonyVO != null)
                {
                    _local_24 = _local_13.colonyVO.colonyYieldStartTime;
                }
                else
                {
                    if (_local_13.state == "premium")
                    {
                        _local_24 = int.MAX_VALUE;
                    }
                    else
                    {
                        _local_24 = (int.MAX_VALUE - 20);
                    };
                };
                _local_13.sort = _local_24;
                _local_7.push(_local_13);
                _local_18++;
            };
            _local_7.sortOn("sort", Array.NUMERIC);
            this.mPanel.coloniesList.dataProvider = _local_7;
            var _local_19:Array = new Array();
            for (_local_20 in _local_1)
            {
                _local_19.push(_local_1[_local_20]);
            };
            this.mPanel.yieldPanel.yieldList = _local_19;
            _local_21 = PVPUtil.GetActiveColonyYieldBonusForPvPLevel(global.ui.mCurrentPlayer.GetClaimedPvPLevel());
            this.mPanel.yieldPanel.colonyYieldBuffIcon.visible = (_local_21 > 0);
            this.mPanel.yieldPanel.colonyYieldBuffIcon.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.TOOLTIP, "BonusOnColonyYield", [_local_21]);
            _local_22 = this.mGI.pickupManager.getExtraSpace(PICKUP_PROVIDER_TYPE.PVP_COLONY);
            this.mPanel.yieldPanel.colonyResourcePoolBuffIcon.visible = (_local_22 > 0);
            this.mPanel.yieldPanel.colonyResourcePoolBuffIcon.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.TOOLTIP, "BonusOnResourcePool", [_local_22]);
        }

        private function ItemClickedHandler2(_arg_1:Event):void
        {
            globalFlash.gui.windowController.showModal();
        }


    }
}
