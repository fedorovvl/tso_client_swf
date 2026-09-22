package GUI.GAME
{
    import BuffSystem.cBuff;
    import GUI.Loca.cLocaManager;
    import Interface.cGameInterface;
    import GUI.Components.MysteryBoxPanel;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import flash.display.DisplayObject;
    import GUI.Components.Frame;
    import GUI.FloatingItemsManager;
    import flash.events.Event;
    import Enums.COMMAND;
    import mx.events.CloseEvent;
    import GUI.Components.ItemRenderer.StarMenuItemRenderer;
    import Communication.VO.dUniqueID;
    import Enums.LOCA_GROUP;
    import Communication.VO.dResourcesVO;
    import mx.events.ToolTipEvent;
    import GUI.Components.ToolTips.cToolTipUtil;
    import Communication.VO.dBuffVO;
    import Communication.VO.dSpecialistVO;
    import Specialists.cSpecialist;
    import Communication.VO.UpdateVO.dLootItemsVO;

    public class cMysteryBoxPanel extends cBasicPanel 
    {

        private var mBuff:cBuff;
        private var mLM:cLocaManager = cLocaManager.GetInstance();
        private var mGI:cGameInterface;
        protected var mPanel:MysteryBoxPanel;


        public function SetData(_arg_1:cBuff):void
        {
            this.mBuff = _arg_1;
            this.mPanel.busyAnim.visible = true;
            this.mPanel.rewardText.text = "";
            this.mPanel.itemsList.removeAllChildren();
        }

        public function Init(_arg_1:MysteryBoxPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.ClosePanel);
        }

        public function ShowConfirmation():void
        {
            CustomAlert.show("ConfirmOpenMysteryBox", "ConfirmOpenMysteryBox", (Alert.CANCEL | Alert.OK), null, this.OpenMysteryBox);
        }

        private function ClosePanel(_arg_1:Event):void
        {
            var _local_2:DisplayObject;
            for each (_local_2 in this.mPanel.itemsList.getChildren())
            {
                if (((_local_2 is Frame) && ((_local_2 as Frame).content == defines.HARD_CURRENCY_RESOURCE_NAME_string)))
                {
                    FloatingItemsManager.createJumpFlyDestroy(_local_2, "GAMESTATE_ID_INFO_BAR.infoBarRight");
                }
                else
                {
                    FloatingItemsManager.createJumpFlyDestroy(_local_2, "GAMESTATE_ID_ACTIONBAR.actionBarCenter.btnActionBar04");
                };
            };
            this.Hide();
        }

        private function OpenMysteryBox(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            var _local_2:cBuff = this.mGI.mCurrentCursor.mCurrentBuff;
            this.mGI.SendServerAction(COMMAND.APPLY_BUFF, 0, this.mGI.mCurrentPlayerZone.mStreetDataMap.GetMayorHouse().GetGrid(), 0, _local_2.GetUniqueId());
            _local_2.IncWaitingForServerCount(this.mGI);
            this.mGI.mCurrentCursor.mCurrentBuff = null;
            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
            Show();
        }

        public function SetResult(_items:dLootItemsVO):void
        {
            var vo:* = undefined;
            var item:* = undefined;
            var frame:Frame;
            var renderer:StarMenuItemRenderer;
            var gemFrame:Frame;
            if (((!(_items.uniqueID.eq(dUniqueID.Create(-1, -1)))) && (!(this.mBuff.GetUniqueId().eq(_items.uniqueID)))))
            {
                return;
            };
            this.mPanel.rewardText.text = this.mLM.GetText(LOCA_GROUP.DESCRIPTIONS, "ContentMysteryBox");
            this.mPanel.busyAnim.visible = false;
            for each (vo in _items.items)
            {
                if (((vo is dResourcesVO) && (vo.name_string == "XP")))
                {
                    item = vo;
                    frame = new Frame();
                    frame.contentType = Frame.CONTENT_TYPE_RESOURCE;
                    frame.amount = vo.amount;
                    frame.content = vo.name_string;
                    frame.toolTip = this.mLM.GetText(LOCA_GROUP.RESOURCES, vo.name_string);
                    frame.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, function (_arg_1:ToolTipEvent):void
                    {
                        cToolTipUtil.createToolTip(cToolTipUtil.SIMPLE_string, _arg_1);
                    });
                    this.mPanel.itemsList.addChild(frame);
                }
                else
                {
                    if ((vo is dBuffVO))
                    {
                        if ((vo as dBuffVO).GetResourceName_string() == defines.HARD_CURRENCY_RESOURCE_NAME_string)
                        {
                            item = cBuff.CreateBuffFromVO(vo);
                            gemFrame = new Frame();
                            gemFrame.contentType = Frame.CONTENT_TYPE_RESOURCE;
                            gemFrame.type = Frame.BUFF_INSTANT;
                            gemFrame.amount = vo.amount;
                            gemFrame.content = defines.HARD_CURRENCY_RESOURCE_NAME_string;
                            gemFrame.toolTip = this.mLM.GetText(LOCA_GROUP.RESOURCES, defines.HARD_CURRENCY_RESOURCE_NAME_string);
                            this.mPanel.itemsList.addChild(gemFrame);
                            break;
                        };
                        item = cBuff.CreateBuffFromVO(vo);
                    }
                    else
                    {
                        if ((vo is dSpecialistVO))
                        {
                            item = cSpecialist.CreateSpecialistFromVO(this.mGI, vo, false);
                        };
                    };
                    renderer = new StarMenuItemRenderer();
                    renderer.data = item;
                    this.mPanel.itemsList.addChild(renderer);
                };
            };
        }


    }
}
