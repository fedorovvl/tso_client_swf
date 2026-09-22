package GUI.GAME
{
    import GO.cBuilding;
    import Interface.cGameInterface;
    import GUI.Components.WatchTowerInfoPanel;
    import MilitarySystem.cMilitaryUnitDescription;
    import MilitarySystem.cSquad;
    import flash.events.MouseEvent;
    import mx.events.FlexEvent;
    import __AS3__.vec.Vector;
    import flash.events.Event;
    import GUI.Components.ToolTips.cToolTipUtil;
    import mx.events.ToolTipEvent;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Assets.gAssetManager;
    import Communication.VO.dSquadVO;
    import MilitarySystem.cMilitaryUnitBase;
    import MilitarySystem.cMilitaryUtil;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import mx.events.CloseEvent;
    import mx.core.*;
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import mx.controls.*;
    import flash.text.*;
    import mx.collections.*;
    import GO.*;
    import __AS3__.vec.*;
    import nLib.*;
    import PathFinding.*;
    import flash.utils.*;
    import flash.net.*;
    import nLib.SpriteLibDataClass.*;
    import GUI.*;
    import flash.system.*;
    import flash.ui.*;
    import Enums.*;
    import SettlerKI.*;

    public class cWatchTowerInfoPanel extends cBasicInfoPanel 
    {

        protected var mBuilding:cBuilding;
        private var mGI:cGameInterface;
        protected var mPanel:WatchTowerInfoPanel;


        override public function Show():void
        {
            this.mPanel.currentState = "";
            super.Show();
        }

        private function EnterManageArmyState(_arg_1:FlexEvent):void
        {
            var _local_4:cMilitaryUnitDescription;
            var _local_5:Object;
            var _local_6:cSquad;
            this.mPanel.btnCommitArmyChanges.addEventListener(MouseEvent.CLICK, this.CommitArmyChanges);
            this.mPanel.manageArmyList.addEventListener(FlexEvent.DATA_CHANGE, this.UpdateUnitsAmounts);
            var _local_2:Vector.<cSquad> = this.mGI.mCurrentPlayerZone.GetArmy(this.mGI.mCurrentPlayer.GetPlayerId()).GetSquads_vector();
            var _local_3:Array = [];
            for each (_local_4 in cMilitaryUnitDescription.GetAllUnitDescriptions(true))
            {
                _local_5 = {};
                _local_5.name_string = _local_4.GetType();
                _local_5.current = 0;
                _local_5.available = 0;
                for each (_local_6 in _local_2)
                {
                    if (_local_6.GetType() == _local_5.name_string)
                    {
                        _local_5.available = (_local_5.available + _local_6.GetAmount());
                    };
                };
                for each (_local_6 in this.mBuilding.GetArmy().GetSquads_vector())
                {
                    if (_local_6.GetType() == _local_5.name_string)
                    {
                        _local_5.current = (_local_5.current + _local_6.GetAmount());
                    };
                };
                _local_5.available = (_local_5.available + _local_5.current);
                _local_3.push(_local_5);
            };
            this.mPanel.manageArmyList.dataProvider = _local_3;
        }

        private function RepairBuilding(_arg_1:Event):void
        {
            this.mBuilding.SetRecoveringHitPoints(global.repairRate);
            this.Hide();
        }

        override public function Hide():void
        {
            super.Hide();
        }

        private function CreateKnockDownToolTip(_arg_1:ToolTipEvent):void
        {
            if (this.mBuilding.IsRecurringBuilding())
            {
                cToolTipUtil.createToolTip(cToolTipUtil.SIMPLE_string, _arg_1);
            }
            else
            {
                cToolTipUtil.createToolTip(cToolTipUtil.DEMOLISH_BUILDING_string, _arg_1, this.mBuilding);
            };
        }

        override public function SetData(_arg_1:cBuilding):void
        {
            var _local_5:cSquad;
            var _local_2:String = _arg_1.GetBuildingName_string();
            this.mBuilding = _arg_1;
            this.mPanel.label = _local_2;
            this.mPanel.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _local_2);
            this.mPanel.image.source = gAssetManager.GetBuildingIcon(_local_2);
            if (_arg_1.GetUpgradeDuration() > 0)
            {
                this.mPanel.btnUpgrade.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "UpgradeWatchtower");
            }
            else
            {
                this.mPanel.btnUpgrade.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "NotPossible");
            };
            this.mPanel.btnUpgrade.enabled = _arg_1.IsUpgradeAllowed(true);
            this.mPanel.btnKnockDown.enabled = _arg_1.IsKnockdownAllowed();
            if (this.mBuilding.IsRecurringBuilding())
            {
                this.mPanel.btnKnockDown.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "KnockDownRecurring");
            }
            else
            {
                this.mPanel.btnKnockDown.toolTip = "KnockDown";
            };
            this.mPanel.levelLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Level", [_arg_1.GetUpgradeLevel().toString()]);
            this.mPanel.upgradeTime.text = cLocaManager.GetInstance().FormatDuration(_arg_1.GetUpgradeDuration());
            this.mPanel.upgradeTime.visible = (_arg_1.GetUpgradeDuration() > 0);
            this.mPanel.integrity.value = _arg_1.GetHealthBar();
            this.mPanel.btnRepair.enabled = (_arg_1.GetRepairCosts().length > 0);
            this.mPanel.costsList.dataProvider = _arg_1.GetUpgradeCosts_vector();
            var _local_3:Array = [];
            var _local_4:Vector.<cSquad> = this.mBuilding.GetArmy().GetSquads_vector();
            _local_4.sort(cSquad.SortByCombatPriority);
            for each (_local_5 in _local_4)
            {
                _local_3.push(_local_5);
            };
            this.mPanel.unitsList.dataProvider = _local_3;
        }

        public function Init(_arg_1:WatchTowerInfoPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnKnockDown.addEventListener(MouseEvent.CLICK, this.ConfirmRemoveBuilding);
            this.mPanel.btnUpgrade.addEventListener(MouseEvent.CLICK, this.UpgradeBuilding);
            this.mPanel.btnKnockDown.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.CreateKnockDownToolTip);
            this.mPanel.stateManageArmy.addEventListener(FlexEvent.ENTER_STATE, this.EnterManageArmyState);
            this.mPanel.btnRepair.addEventListener(MouseEvent.CLICK, this.RepairBuilding);
        }

        private function UpgradeBuilding(_arg_1:Event):void
        {
            this.mGI.mCurrentPlayerZone.UpgradeBuildingOnGridPosition(this.mBuilding.GetGrid());
            this.Hide();
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
        }

        private function UpdateUnitsAmounts(_arg_1:FlexEvent):void
        {
            var _local_3:Object;
            var _local_2:int;
            for each (_local_3 in this.mPanel.manageArmyList.dataProvider)
            {
                _local_2 = (_local_2 + _local_3.current);
            };
            this.mPanel.manageUnitsAmountLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "UnitsAttached", [_local_2.toString(), this.mBuilding.GetMaxMilitaryUnits().toString()]);
            this.mPanel.manageUnitsAmountLabel.setStyle("color", ((_local_2 > this.mBuilding.GetMaxMilitaryUnits()) ? 0xFF0000 : 0xFFFFFF));
            this.mPanel.btnCommitArmyChanges.enabled = (_local_2 <= this.mBuilding.GetMaxMilitaryUnits());
        }

        private function CommitArmyChanges(_arg_1:MouseEvent):void
        {
            var _local_3:Object;
            var _local_2:Vector.<dSquadVO> = new Vector.<dSquadVO>();
            for each (_local_3 in this.mPanel.manageArmyList.dataProvider)
            {
                if (_local_3.current > 0)
                {
                    _local_2.push(new dSquadVO().init(_local_3.name_string, _local_3.current, cMilitaryUnitBase.GetHitPointsForUnit(_local_3.name_string)));
                };
            };
            cMilitaryUtil.SendRaiseArmyToServer(this.mGI, this.mBuilding, _local_2);
            this.Refresh();
        }

        private function ConfirmRemoveBuilding(_arg_1:Event):void
        {
            var _local_2:CustomAlert = CustomAlert.show("ConfirmTeardown", "ConfirmTeardown", (Alert.CANCEL | Alert.OK), this.mPanel, this.RemoveBuilding);
            _local_2.addEventListener(CloseEvent.CLOSE, this.RemoveBuilding);
        }

        public function Refresh():void
        {
            if (this.mBuilding)
            {
                this.SetData(this.mBuilding);
            };
        }

        private function RemoveBuilding(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            this.mGI.mCurrentPlayerZone.SendDestructBuildingCommand(this.mBuilding, "cWatchTowerInfoPanel");
            this.Hide();
        }


    }
}
