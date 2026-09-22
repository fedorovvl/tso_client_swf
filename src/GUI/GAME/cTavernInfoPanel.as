package GUI.GAME
{
    import GO.cBuilding;
    import Interface.cGameInterface;
    import GUI.Components.TavernInfoPanel;
    import Specialists.cSpecialist;
    import mx.events.ListEvent;
    import BuffSystem.BuffAppliance;
    import GUI.Components.ItemRenderer.BuySpecialistItemRenderer;
    import Specialists.cSpecialistDescription;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Enums.SPECIALIST_TYPE;
    import GUI.Effects.gHintManager;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;

    public class cTavernInfoPanel extends cBasicInfoPanel 
    {

        protected var mBuilding:cBuilding;
        private var mGI:cGameInterface;
        protected var mPanel:TavernInfoPanel;


        override public function Show():void
        {
            super.Show();
        }

        private function BuySpecialist(_arg_1:ListEvent):void
        {
            cSpecialist.BuySpecialist(_arg_1.rowIndex, this.mGI);
            this.Hide();
        }

        override public function Hide():void
        {
            super.Hide();
        }

        override public function SetData(_arg_1:cBuilding):void
        {
            var _local_3:BuffAppliance;
            var _local_4:String;
            var _local_5:BuySpecialistItemRenderer;
            var _local_6:cSpecialistDescription;
            var _local_2:String = _arg_1.GetBuildingName_string();
            this.mBuilding = _arg_1;
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_2);
            this.mPanel.upgradeColumn.SetData(_arg_1, this, this.mPanel);
            this.mPanel.buildingHeader.data = this.mBuilding;
            if (this.mPanel.list.getChildren().length == cSpecialist.GetAllSpecialistDescriptions().length)
            {
                for each (_local_5 in this.mPanel.list.getChildren())
                {
                    _local_5.refresh();
                };
            }
            else
            {
                this.mPanel.list.removeAllChildren();
                for each (_local_6 in cSpecialist.GetAllSpecialistDescriptions())
                {
                    _local_5 = new BuySpecialistItemRenderer();
                    _local_5.id = ("Specialist" + SPECIALIST_TYPE.toString(_local_6.GetType()));
                    _local_5.data = _local_6;
                    this.mPanel.list.addChild(_local_5);
                };
                gHintManager.TryRemainingHints();
            };
        }

        public function Init(_arg_1:TavernInfoPanel):void
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
            this.mPanel.list.addEventListener("BuySpecialist", this.BuySpecialist);
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
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
