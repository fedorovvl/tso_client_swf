package GUI.GAME
{
    import Interface.cGameInterface;
    import GUI.Components.PvPReportWindow;
    import GUI.Components.data.dCombatUnitData;
    import GUI.Assets.gAssetManager;
    import GUI.Components.ItemRenderer.PvPReportCampItemRenderer;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;

    public class cPvPReportWindow extends cBasicPanel 
    {

        private static const IS_ATTACKER:int = 1;
        private static const IS_DEFENDER:int = 2;

        private const DEFENDER:int = 1;
        private const ATTACKER:int = 0;

        private var mReport:XML;
        private var mGI:cGameInterface;
        protected var mPanel:PvPReportWindow;
        private var isAttacker:Boolean = false;


        public function SetData(_arg_1:String):void
        {
            var _local_8:XML;
            var _local_9:XML;
            var _local_10:int;
            var _local_11:XML;
            var _local_12:Object;
            var _local_13:int;
            var _local_14:int;
            var _local_16:dCombatUnitData;
            var _local_17:Object;
            var _local_18:Array;
            var _local_19:XML;
            var _local_20:dCombatUnitData;
            var _local_21:Object;
            var _local_22:int;
            var _local_23:Object;
            var _local_24:Object;
            this.mReport = new XML(_arg_1);
            if (this.mGI.mCurrentPlayer.GetPlayerName_string() == String(this.mReport.Zone.@AttackerName))
            {
                this.isAttacker = true;
            }
            else
            {
                this.isAttacker = false;
            };
            var _local_2:Array = new Array();
            var _local_3:Array = new Array();
            var _local_4:Array = new Array();
            var _local_5:int = Number(this.mReport.Zone.@AttackCountLost);
            var _local_6:int = (_local_5 + Number(this.mReport.Zone.@AttackCountSuccess));
            var _local_7:int;
            this.mPanel.lostAttacksAmount.text = _local_5.toString();
            this.mPanel.numAttacksAmount.text = _local_6.toString();
            for each (_local_8 in this.mReport.Units.Unit)
            {
                _local_16 = new dCombatUnitData();
                _local_16.current = Number(_local_8.@Lost);
                _local_7 = (_local_7 + _local_16.current);
                _local_16.name_string = String(_local_8.@UnitType);
                if (_local_16.current > 0)
                {
                    _local_3.push(_local_16);
                };
            };
            this.mPanel.totalUnitLossesAmount.text = _local_7.toString();
            for each (_local_9 in this.mReport.InitialCamps.Camp)
            {
                _local_17 = new Object();
                _local_17.gridid = Number(_local_9.@GridPos);
                _local_17.name = String(_local_9.@Type);
                _local_17.index = 0;
                _local_17.timestamp = 0;
                _local_18 = new Array();
                for each (_local_19 in _local_9.Units.Unit)
                {
                    _local_20 = new dCombatUnitData();
                    _local_20.current = Number(_local_19.@Amount);
                    _local_20.name_string = String(_local_19.@Type);
                    _local_18.push(_local_20);
                };
                _local_17.units = _local_18;
                if (_local_17.units.length > 0)
                {
                    _local_4.push(_local_17);
                };
            };
            _local_10 = 1;
            for each (_local_11 in this.mReport.Attacks.Attack)
            {
                _local_21 = new Object();
                _local_21.index = _local_10;
                _local_21.gridid = Number(_local_11.@GridCoord);
                _local_21.timestamp = Number(_local_11.@TimeStamp);
                _local_2.push(_local_21);
                _local_10++;
            };
            for each (_local_12 in _local_4)
            {
                _local_22 = 0;
                _local_23 = null;
                for each (_local_24 in _local_2)
                {
                    if (((_local_12.gridid == Number(_local_24.gridid)) && (Number(_local_24.timestamp) > _local_22)))
                    {
                        _local_22 = Number(_local_24.timestamp);
                        _local_23 = _local_24;
                    };
                };
                if (_local_23 != null)
                {
                    _local_12.index = _local_23.index;
                    _local_12.timestamp = _local_23.timestamp;
                };
            };
            _local_4.sortOn("timestamp", Array.NUMERIC);
            _local_13 = 1;
            _local_14 = 0;
            while (_local_14 < _local_4.length)
            {
                if (_local_4[_local_14].timestamp > 0)
                {
                    _local_4[_local_14].index = _local_13;
                    _local_13++;
                };
                _local_14++;
            };
            var _local_15:String = String(this.mReport.Zone.@MapFileName);
            _local_15 = _local_15.substr(18, 27);
            this.mPanel.unitsLostList.dataProvider = _local_3;
            this.mPanel.mapBackGround.source = gAssetManager.GetClass("PvPReportMapBackground");
            this.mPanel.miniMapImage.source = gAssetManager.GetPvPMinimapUrl(_local_15);
            this.mPanel.mapOverLayImage.source = gAssetManager.GetClass("PvPReportMapOverlay");
            this.mPanel.pvpHeader.source = gAssetManager.GetClass("PvPReportHeader");
            this.mPanel.attackPlotter.setData(_local_4, PvPReportCampItemRenderer);
        }

        public function Init(_arg_1:PvPReportWindow):void
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
            this.mPanel.addEventListener(PvPReportCampItemRenderer.CAMP_CLICK, this.campClickHandler);
        }

        protected function campClickHandler(_arg_1:Event):void
        {
            this.mPanel.campUnitList.dataProvider = _arg_1.target.data.units;
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        override public function Show():void
        {
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, true);
        }


    }
}
