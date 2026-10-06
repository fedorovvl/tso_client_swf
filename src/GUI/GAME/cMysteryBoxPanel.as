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
    import Communication.VO.dResourceVO;
    import mx.events.ToolTipEvent;
    import GUI.Components.ToolTips.cToolTipUtil;
    import Communication.VO.dBuffVO;
    import Communication.VO.dSpecialistVO;
    import Specialists.cSpecialist;
    import Communication.VO.UpdateVO.dLootItemsVO;
    import GUI.Components.CustomLabel;
    import GUI.Components.ExtendedHSlider;
    import GUI.Assets.gAssetManager;
    import mx.controls.Image;
    import mx.events.SliderEvent;

    public class cMysteryBoxPanel extends cBasicPanel 
    {

        private var mBuff:cBuff;
        private var mLM:cLocaManager = cLocaManager.GetInstance();
        private var mGI:cGameInterface;
        protected var mPanel:MysteryBoxPanel;
        private var mAmountSlider:ExtendedHSlider;
        private var mAmountLabel:CustomLabel;


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
            var _local_2:String = this.mLM.GetText(LOCA_GROUP.LABELS, "SelectMysteryBoxAmount");
            var _local_3:String = this.mLM.GetText(LOCA_GROUP.LABELS, "Select");
            var _local_1:CustomAlert = CustomAlert.show(_local_2, _local_3, (Alert.CANCEL | Alert.OK), null, this.OpenMysteryBox, null, Alert.OK, false);
            _local_1.addEventListener(FlexEvent.CREATION_COMPLETE, this.AddAmountSelector);
        }

        private function AddAmountSelector(_arg_1:FlexEvent):void
        {
            var _local_2:CustomAlert = (_arg_1.currentTarget as CustomAlert);
            _local_2.removeEventListener(FlexEvent.CREATION_COMPLETE, this.AddAmountSelector);
            _local_2.width = 435;
            _local_2.minHeight = 300;
            _local_2.message.width = 395;

            var _local_4:Image = new Image();
            _local_4.width = 54;
            _local_4.height = 54;
            _local_4.scaleContent = true;
            _local_4.source = gAssetManager.GetBuffIcon(this.mBuff.GetType());

            var _local_5:CustomLabel = new CustomLabel();
            _local_5.width = 395;
            _local_5.setStyle("textAlign", "center");
            _local_5.setStyle("color", 0xFFFFFF);
            _local_5.setStyle("fontWeight", "bold");
            _local_5.text = this.mLM.getLabel(this.mBuff.GetType(), [this.mBuff.GetAmount().toString(), this.mBuff.GetResourceName_string()]);

            this.mAmountLabel = new CustomLabel();
            this.mAmountLabel.width = 270;
            this.mAmountLabel.setStyle("textAlign", "center");
            this.mAmountLabel.setStyle("color", 0xFFFFFF);

            this.mAmountSlider = new ExtendedHSlider();
            this.mAmountSlider.width = 270;
            this.mAmountSlider.minimum = 1;
            this.mAmountSlider.maximum = Math.min(100, this.mBuff.GetAmount());
            this.mAmountSlider.value = 1;
            this.mAmountSlider.addEventListener(SliderEvent.CHANGE, this.UpdateAmountLabel);

            var _local_3:int = _local_2.content.getChildIndex(_local_2.buttonsList);
            _local_2.content.addChildAt(_local_4, _local_3);
            _local_2.content.addChildAt(_local_5, (_local_3 + 1));
            _local_2.content.addChildAt(this.mAmountLabel, (_local_3 + 2));
            _local_2.content.addChildAt(this.mAmountSlider, (_local_3 + 3));
            this.UpdateAmountLabel();
        }

        private function UpdateAmountLabel(_arg_1:SliderEvent=null):void
        {
            if (((this.mAmountLabel != null) && (this.mAmountSlider != null)))
            {
                this.mAmountLabel.text = ((int(this.mAmountSlider.value).toString() + " / ") + int(this.mAmountSlider.maximum).toString());
            };
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
            var _local_3:int = ((this.mAmountSlider != null) ? int(this.mAmountSlider.value) : 1);
            this.mGI.SendServerAction(COMMAND.APPLY_BUFF, 0, this.mGI.mCurrentPlayerZone.mStreetDataMap.GetMayorHouse().GetGrid(), _local_3, _local_2.GetUniqueId());
            _local_2.SetWaitingForServerCount((_local_2.GetWaitingForServerCount() + _local_3), this.mGI);
            this.mGI.mCurrentCursor.mCurrentBuff = null;
            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
            Show();
        }

        private function GetGroupedDisplayItems(_arg_1:Object):Array
        {
            var _local_2:Array = [];
            var _local_3:Object = {};
            var _local_4:Object;
            var _local_5:dBuffVO;
            var _local_6:dBuffVO;
            var _local_7:String;
            for each (_local_4 in _arg_1)
            {
                if ((_local_4 is dBuffVO))
                {
                    _local_5 = (_local_4 as dBuffVO);
                    _local_7 = (((_local_5.buffName_string.length + ":") + _local_5.buffName_string) + (("|" + _local_5.resourceName_string.length) + ":")) + _local_5.resourceName_string;
                    _local_6 = (_local_3[_local_7] as dBuffVO);
                    if (_local_6 != null)
                    {
                        _local_6.amount = (_local_6.amount + _local_5.amount);
                    }
                    else
                    {
                        _local_6 = dBuffVO.cloneDBuffVO(_local_5);
                        _local_3[_local_7] = _local_6;
                        _local_2.push(_local_6);
                    };
                }
                else
                {
                    _local_2.push(_local_4);
                };
            };
            return (_local_2);
        }

        private function FormatFrameAmount(_arg_1:FlexEvent):void
        {
            var _local_2:Frame = (_arg_1.currentTarget as Frame);
            if ((((_local_2 != null) && (_local_2.amountLabel != null)) && (_local_2.amountLabel.text != "")))
            {
                _local_2.amountLabel.text = this.mLM.FormatNumber(_local_2.amount);
            };
        }

        private function FormatRendererAmount(_arg_1:FlexEvent):void
        {
            var _local_2:StarMenuItemRenderer = (_arg_1.currentTarget as StarMenuItemRenderer);
            var _local_3:cBuff;
            if ((((_local_2 == null) || (_local_2.amountLabel == null)) || (_local_2.amountLabel.text == "")))
            {
                return;
            };
            _local_3 = (_local_2.data as cBuff);
            if (_local_3 != null)
            {
                _local_2.amountLabel.text = this.mLM.FormatNumber(_local_3.GetAmount());
            };
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
            for each (vo in this.GetGroupedDisplayItems(_items.items))
            {
                if (((vo is dResourceVO) && ((vo.name_string == "XP") || (vo.name_string == defines.PVP_XP_string))))
                {
                    item = vo;
                    frame = new Frame();
                    frame.addEventListener(FlexEvent.DATA_CHANGE, this.FormatFrameAmount, false, 0, true);
                    frame.contentType = Frame.CONTENT_TYPE_RESOURCE;
                    frame.type = Frame.BUFF_INSTANT;
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
                            gemFrame.addEventListener(FlexEvent.DATA_CHANGE, this.FormatFrameAmount, false, 0, true);
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
                    renderer.addEventListener(FlexEvent.DATA_CHANGE, this.FormatRendererAmount, false, 0, true);
                    renderer.data = item;
                    this.mPanel.itemsList.addChild(renderer);
                };
            };
        }


    }
}
