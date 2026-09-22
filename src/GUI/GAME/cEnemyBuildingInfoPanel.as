package GUI.GAME
{
    import GO.cBuilding;
    import Interface.cGameInterface;
    import GUI.Components.EnemyBuildingInfoPanel;
    import GUI.Components.ToolTips.cToolTipUtil;
    import mx.events.ToolTipEvent;
    import flash.events.Event;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import MilitarySystem.cSquad;
    import ServerState.dResource;
    import GUI.Assets.gAssetManager;
    import mx.collections.ArrayCollection;
    import __AS3__.vec.Vector;

    public class cEnemyBuildingInfoPanel extends cBasicInfoPanel 
    {

        private const FRIEND_GARRISON:String = "FriendGarrison";

        protected var mBuilding:cBuilding;
        private var mGI:cGameInterface;
        protected var mPanel:EnemyBuildingInfoPanel;


        private function CreateUpgradeToolTip(_arg_1:ToolTipEvent):void
        {
            cToolTipUtil.createToolTip(cToolTipUtil.UPGRADE_BUILDING_string, _arg_1, this.mBuilding);
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
        }

        override public function Hide():void
        {
            super.Hide();
        }

        override public function Show():void
        {
            super.Show();
        }

        private function retrieveDescriptionText(_arg_1:String):String
        {
            switch (_arg_1)
            {
                case defines.GARRISON_NAME_string:
                    return (cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, this.FRIEND_GARRISON));
                default:
                    return (cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _arg_1));
            };
        }

        public function Init(_arg_1:EnemyBuildingInfoPanel):void
        {
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
        }

        override public function SetData(_arg_1:cBuilding):void
        {
            var _local_5:cSquad;
            var _local_6:dResource;
            var _local_2:String = _arg_1.GetBuildingName_string();
            this.mBuilding = _arg_1;
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_2);
            this.mPanel.description.text = this.retrieveDescriptionText(_local_2);
            this.mPanel.image.source = gAssetManager.GetBuildingIcon(_arg_1.GetContainerName_string());
            var _local_3:ArrayCollection = new ArrayCollection();
            var _local_4:Vector.<cSquad> = this.mBuilding.GetArmy().GetSquads_vector();
            _local_4.sort(cSquad.SortByCombatPriority);
            for each (_local_5 in _local_4)
            {
                _local_6 = new dResource();
                _local_6.name_string = _local_5.GetType();
                _local_6.amount = _local_5.GetAmount();
                _local_3.addItem(_local_6);
            };
            this.mPanel.unitsList.dataProvider = _local_3;
        }

        private function RemoveBuilding(_arg_1:Event):void
        {
            this.mGI.mCurrentPlayerZone.SendDestructBuildingCommand(this.mBuilding, "cEnemyBuildingInfoPanel");
            this.Hide();
        }

        private function RepairBuilding(_arg_1:Event):void
        {
            this.mBuilding.SetRecoveringHitPoints(global.repairRate);
            this.Hide();
        }

        public function Refresh():void
        {
            if (this.mBuilding)
            {
                this.SetData(this.mBuilding);
            };
        }

        private function UpgradeBuilding(_arg_1:Event):void
        {
            this.mGI.mCurrentPlayerZone.UpgradeBuildingOnGridPosition(this.mBuilding.GetGrid());
            this.Hide();
        }


    }
}
