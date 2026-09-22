package GUI.GAME
{
    import mx.collections.ArrayCollection;
    import Interface.cGameInterface;
    import GUI.Components.ZoneBuffPanel;
    import flash.events.MouseEvent;
    import GUI.Components.ZoneBuffListItemRenderer;
    import Communication.VO.dPersistedBuffApplianceVO;
    import Communication.VO.dBuffApplianceVO;
    import Enums.COMMAND;
    import flash.events.Event;
    import ZoneBuff.ZoneBuffManager;

    public class cZoneBuffPanel extends cBasicPanel 
    {

        private var buffListData:ArrayCollection;
        private var mGI:cGameInterface;
        private var mPanel:ZoneBuffPanel;


        public function Init(_arg_1:ZoneBuffPanel):void
        {
            this.mPanel = _arg_1;
            AddBaseElement(_arg_1);
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.mGI = (global.ui as cGameInterface);
            this.buffListData = new ArrayCollection();
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.btnCloseClickHandler);
            this.mPanel.buffList.addEventListener(ZoneBuffListItemRenderer.REMOVE_BUFF_CLICK_string, this.removeBuffClickHandler);
            this.Refresh();
        }

        private function removeBuffClickHandler(_arg_1:Event):void
        {
            _arg_1.stopPropagation();
            var _local_2:dPersistedBuffApplianceVO = (_arg_1.target.data as dPersistedBuffApplianceVO);
            var _local_3:dBuffApplianceVO = new dBuffApplianceVO();
            _local_3.buffID = _local_2.buffID;
            _local_3.sourceZoneId = _local_2.sourceZoneId;
            if (_local_2 != null)
            {
                global.ui.SendServerActionSimple(COMMAND.ZONE_BUFF_REMOVE, _local_3);
            };
            this.setBusyState(true);
        }

        public function Refresh():void
        {
            var _local_3:dPersistedBuffApplianceVO;
            var _local_4:dPersistedBuffApplianceVO;
            var _local_1:ZoneBuffManager = global.ui.mZoneBuffManager;
            var _local_2:ArrayCollection = new ArrayCollection();
            for each (_local_3 in _local_1.getZoneBuffsForPersistence())
            {
                _local_2.addItem(_local_3);
            };
            if ((((global.ui.mCurrentViewedZoneID == global.ui.mCurrentPlayer.getPlayerID()) || (global.ui.mCurrentViewedZoneID < 0)) && (global.ui.mCurrentPlayer.GetPremiumDuration() > 0)))
            {
                _local_4 = new dPersistedBuffApplianceVO();
                _local_4.buffID = defines.PREMIUM_DUMMY_ZONE_BUFF_ID;
                _local_2.addItemAt(_local_4, 0);
            };
            this.mPanel.buffList.dataProvider = _local_2;
            this.mPanel.noBuffsText.visible = (_local_2.length < 1);
        }

        public function setBusyState(_arg_1:Boolean):void
        {
            this.mPanel.busy.visible = _arg_1;
            this.mPanel.busyAnim.visible = _arg_1;
        }

        private function btnCloseClickHandler(_arg_1:MouseEvent):void
        {
            Hide();
        }


    }
}
