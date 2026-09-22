package GUI.GAME
{
    import GO.cBuilding;
    import Interface.cGameInterface;
    import GUI.Components.MoveBuildingPanel;
    import flash.events.Event;
    import GUI.Components.ItemRenderer.ResourceItemRenderer;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import Enums.COMMAND;
    import GUI.Components.CustomAlert;

    public class cMoveBuildingPanel extends cBasicInfoPanel 
    {

        protected var mBuilding:cBuilding;
        private var mGI:cGameInterface;
        protected var mPanel:MoveBuildingPanel;


        override public function Show():void
        {
            super.Show();
            this.SetData(this.mBuilding);
        }

        private function MoveWithResource(_arg_1:Event):void
        {
            var _local_2:cBuilding = this.mGI.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(this.mBuilding.GetGrid());
            _local_2.mMoveMethod = cBuilding.BUILDING_MOVE_WITH_RESOURCE;
            this.MoveBuilding();
        }

        override public function Hide():void
        {
            super.Hide();
        }

        override public function SetData(_arg_1:cBuilding):void
        {
            var _local_2:Object;
            var _local_3:ResourceItemRenderer;
            this.mBuilding = _arg_1;
            if (IsVisible())
            {
                this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "MoveBuilding");
                this.mPanel.btnMove.enabled = this.mBuilding.IsResourceEnough(this.mBuilding.GetMovementCosts().cost);
                this.mPanel.btnGemMove.enabled = this.mBuilding.IsGemEnough(this.mBuilding.GetGemMovementCosts());
                this.mPanel.costsList.dataProvider = this.mBuilding.GetMovementCosts().cost;
                if (this.mBuilding.GetMovementCosts().isModified())
                {
                    this.mPanel.gemRenderer.color = 5042178;
                    for each (_local_3 in this.mPanel.costsList.getChildren())
                    {
                        _local_3.color = 5042178;
                    };
                };
                _local_2 = new Object();
                _local_2.name_string = defines.HARD_CURRENCY_RESOURCE_NAME_string;
                _local_2.amount = this.mBuilding.GetGemMovementCosts();
                this.mPanel.gemRenderer.data = _local_2;
            };
        }

        public function Init(_arg_1:MoveBuildingPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnMove.addEventListener(MouseEvent.CLICK, this.MoveWithResource);
            this.mPanel.btnGemMove.addEventListener(MouseEvent.CLICK, this.MoveWithGem);
            this.mPanel.btnCancel.addEventListener(MouseEvent.CLICK, this.ClosePanel);
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING_TO_MOVE);
        }

        private function MoveBuilding():void
        {
            this.Hide();
            this.mGI.mCurrentCursor.mCurrentBuilding = this.mBuilding;
            this.mGI.mCurrentCursor.SetCursorEditModeObjectName(COMMAND.MOVE_BUILDING, this.mBuilding.GetGOContainer().mGfxResourceListName_string);
            this.mGI.mCurrentCursor.SetCursor(this.mBuilding.GetLevelEnumObjectType(), this.mBuilding.GetGOContainer().mGfxResourceListName_string);
            this.mGI.mCurrentCursor.SetCursorGfxWithUpgradeLevel(this.mBuilding.GetLevelEnumObjectType(), this.mBuilding.getSkin(), this.mBuilding.GetUpgradeLevel());
        }

        private function MoveWithGem(_arg_1:Event):void
        {
            var _local_2:cBuilding;
            if (((!(this.mGI.mSpecificShopItems)) || (this.mBuilding.GetGemMovementCosts() == 0)))
            {
                _local_2 = this.mGI.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(this.mBuilding.GetGrid());
                _local_2.mMoveMethod = cBuilding.BUILDING_MOVE_WITH_GEM;
                this.MoveBuilding();
            }
            else
            {
                CustomAlert.show("ShopItemDeactivated", "ShopItemDeactivated");
            };
        }

        public function Refresh():void
        {
            if (this.mBuilding)
            {
                this.SetData(this.mBuilding);
            };
        }


    }
}
