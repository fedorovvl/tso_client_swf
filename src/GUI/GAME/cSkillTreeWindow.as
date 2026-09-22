package GUI.GAME
{
    import Model.Observer;
    import Interface.cGeneralInterface;
    import Skill.cSkillTree;
    import GUI.Components.SkillTreeWindow;
    import flash.utils.Dictionary;
    import Skill.Skilled;
    import mx.controls.Alert;
    import Enums.COMMAND;
    import Communication.VO.dBuyOneClickShopItemVO;
    import mx.events.CloseEvent;
    import Specialists.cSpecialist;
    import flash.events.MouseEvent;
    import ServerState.cResources;
    import Skill.SkillDefinition;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import mx.events.FlexEvent;
    import Skill.cSkill;
    import flash.geom.Point;
    import GUI.Components.SkillTreeItemRenderer;
    import mx.containers.Canvas;
    import __AS3__.vec.Vector;
    import GUI.Assets.gAssetManager;
    import mx.events.ToolTipEvent;
    import Model.Notifier;
    import flash.events.Event;
    import Skill.cSkillList;
    import ServerState.dResource;
    import Communication.VO.EffectVO;
    import GUI.Components.ResourceAlert;
    import GUI.Components.CustomAlert;
    import GUI.Components.ToolTips.cToolTipUtil;
    import __AS3__.vec.*;

    public class cSkillTreeWindow extends cBasicPanel implements Observer 
    {

        private var _gi:cGeneralInterface;
        private var _skillTree:cSkillTree;
        private var mPanel:SkillTreeWindow;
        private var currentShopID:int;
        private var _avialablePoints:Dictionary;
        private var _owner:Skilled;


        private function buySkillpointHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                this._gi.mClientMessages.SendMessagetoServer(COMMAND.BUY_ONE_CLICK_SHOP_ITEM, this._gi.mCurrentViewedZoneID, new dBuyOneClickShopItemVO().Init(this.currentShopID));
            };
        }

        public function BackSkillTree(_arg_1:MouseEvent):void
        {
            Hide();
            globalFlash.gui.mSpecialistPanel.SetData((this._skillTree.GetOwner() as cSpecialist));
            globalFlash.gui.mSpecialistPanel.Show();
        }

        private function _updateState():void
        {
            var _local_1:cResources = this._gi.mCurrentPlayerZone.GetResources(this._gi.mCurrentPlayer);
            this._avialablePoints[SkillDefinition.BRONZE_RESOURCE] = _local_1.GetPlayerResource(SkillDefinition.BRONZE_RESOURCE).clone();
            this._avialablePoints[SkillDefinition.SILVER_RESOURCE] = _local_1.GetPlayerResource(SkillDefinition.SILVER_RESOURCE).clone();
            this._avialablePoints[SkillDefinition.GOLD_RESOURCE] = _local_1.GetPlayerResource(SkillDefinition.GOLD_RESOURCE).clone();
            this.mPanel.bronzeSkillpoints.data = this._avialablePoints[SkillDefinition.BRONZE_RESOURCE];
            this.mPanel.silverSkillpoints.data = this._avialablePoints[SkillDefinition.SILVER_RESOURCE];
            this.mPanel.goldSkillpoints.data = this._avialablePoints[SkillDefinition.GOLD_RESOURCE];
            if (this._gi.IsAdventureZone())
            {
                this.mPanel.bronzeSkillpoints.amountTextLabel.text = "-";
                this.mPanel.silverSkillpoints.amountTextLabel.text = "-";
                this.mPanel.goldSkillpoints.amountTextLabel.text = "-";
            };
            this.mPanel.btnRefundPremium.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Skilltree_RefundFull", [this._skillTree.getResetCosts()]);
            this._updateView();
        }

        public function ClosePanel(_arg_1:MouseEvent):void
        {
            Hide();
        }

        private function AddHardCurrencyHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                globalFlash.gui.mShopWindow.AddHardCurrency(null);
            };
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnApplySkillpoints.addEventListener(MouseEvent.CLICK, this.ApplySkillPoints);
            this.mPanel.btnCancelSkillpoints.addEventListener(MouseEvent.CLICK, this.CancelSkillPoints);
            this.mPanel.btnBack.addEventListener(MouseEvent.CLICK, this.BackSkillTree);
            this.mPanel.btnRefund.addEventListener(MouseEvent.CLICK, this.RefundSkillPoints);
            this.mPanel.btnRefundPremium.addEventListener(MouseEvent.CLICK, this.RefundAllSkillPoints);
        }

        public function SetData(_arg_1:cSkillTree):void
        {
            var _local_4:cSkill;
            var _local_5:Point;
            var _local_6:Point;
            var _local_7:Point;
            var _local_8:Point;
            var _local_9:Point;
            var _local_10:SkillTreeItemRenderer;
            var _local_11:Canvas;
            this._gi = global.ui;
            this._skillTree = _arg_1;
            this._skillTree.undo();
            this._owner = _arg_1.GetOwner();
            var _local_2:Vector.<cSkill> = _arg_1.getItems_vector();
            this.mPanel.iconPlaceholder.source = gAssetManager.GetBitmap(this._owner.getIconID());
            this.mPanel.headline.htmlText = (((this._owner.getName(false) + " <b> - ") + cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Skilltree")) + "</b>");
            this.mPanel.skillTree.clear();
            this.mPanel.iconPlaceholder.removeEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.CreateGeneralTooltip);
            this.mPanel.iconPlaceholder.toolTip = "";
            if (((this._owner is cSpecialist) && ((this._owner as cSpecialist).GetSpecialistDescription().isGeneral())))
            {
                this.mPanel.iconPlaceholder.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.CreateGeneralTooltip);
                this.mPanel.iconPlaceholder.toolTip = (this._owner as cSpecialist).getMilitaryUnitType();
            };
            var _local_3:Point = new Point();
            for each (_local_4 in _local_2)
            {
                _local_8 = _local_4.getDefinition().position;
                if (_local_8.x > _local_3.x)
                {
                    _local_3.x = _local_8.x;
                };
                if (_local_8.y > _local_3.y)
                {
                    _local_3.y = _local_8.y;
                };
            };
            this.mPanel.skillTree.numCols = ++_local_3.x;
            this.mPanel.skillTree.numRows = ++_local_3.y;
            this.mPanel.goldBG.y = 0;
            this.mPanel.goldBG.height = 0;
            this.mPanel.silverBG.y = 0;
            this.mPanel.silverBG.height = 0;
            this.mPanel.bronzeBG.y = 0;
            this.mPanel.bronzeBG.height = 0;
            _local_5 = new Point();
            _local_6 = new Point();
            _local_7 = new Point();
            for each (_local_4 in _local_2)
            {
                _local_9 = _local_4.getPosition();
                _local_10 = this._createRenderer(_local_4);
                this.mPanel.skillTree.addChildAtPosition(_local_10, _local_9.x, _local_9.y);
                _local_11 = (this.mPanel[(_local_4.getSkillPointType_string() + "BG")] as Canvas);
                if (((_local_11.y == 0) || (_local_11.y > (_local_10.y - 10))))
                {
                    _local_11.height = (_local_11.height + (_local_11.y - (_local_10.y - 10)));
                    _local_11.y = (_local_10.y - 10);
                };
                if ((_local_11.y + _local_11.height) < ((_local_10.y + _local_10.height) + 10))
                {
                    _local_11.height = (((_local_10.y + _local_10.height) + 10) - _local_11.y);
                };
            };
            this._updateState();
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this._updateState();
        }

        protected function CancelSkillPoints(_arg_1:MouseEvent):void
        {
            this._skillTree.undo();
            this._updateState();
        }

        public function refresh():void
        {
            var _local_1:cSkill;
            var _local_2:cSpecialist;
            var _local_3:cSkillTree;
            if (this._skillTree)
            {
                for each (_local_1 in this._skillTree.getItems_vector())
                {
                    _local_1.removeEventListener(Event.CHANGE, this._changedSkill);
                    _local_1.removeEventListener(Event.CANCEL, this._changedSkill);
                };
                this._skillTree.removePropertyObserver(cSkillList.SKILLLIST_CHANGED, this);
                _local_2 = this._gi.mCurrentPlayerZone.getSpecialist(this._skillTree.GetOwner().getPlayerID(), this._skillTree.GetOwner().getOwnerID());
                if (_local_2 != null)
                {
                    _local_3 = _local_2.getSkillTree();
                };
                if (_local_3 == null)
                {
                    _local_3 = this._skillTree;
                };
                for each (_local_1 in _local_3.getItems_vector())
                {
                    _local_1.addEventListener(Event.CHANGE, this._changedSkill);
                    _local_1.addEventListener(Event.CANCEL, this._changedSkill);
                };
                _local_3.addPropertyObserver(cSkillList.SKILLLIST_CHANGED, this);
                this.SetData(_local_3);
            };
        }

        protected function _changedSkill(_arg_1:Event):void
        {
            this._updateView();
        }

        override public function Show():void
        {
            var _local_1:cSkill;
            for each (_local_1 in this._skillTree.getItems_vector())
            {
                _local_1.addEventListener(Event.CHANGE, this._changedSkill);
                _local_1.addEventListener(Event.CANCEL, this._changedSkill);
            };
            this._skillTree.addPropertyObserver(cSkillList.SKILLLIST_CHANGED, this);
            this.mPanel.btnRefundPremium.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Skilltree_RefundFull", [this._skillTree.getResetCosts()]);
            super.Show();
        }

        private function ResetHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                this._skillTree.resetSkillpointsGUI(false);
            };
        }

        protected function RefundSkillPoints(_arg_1:MouseEvent):void
        {
            var _local_3:Vector.<dResource>;
            var _local_4:int;
            var _local_5:dResource;
            var _local_2:Vector.<EffectVO> = this._skillTree.getResetRewards(false);
            if (_local_2.length > 0)
            {
                _local_3 = new Vector.<dResource>();
                _local_4 = 0;
                while (_local_4 < _local_2.length)
                {
                    _local_5 = new dResource();
                    _local_5.name_string = _local_2[_local_4].name_string;
                    _local_5.amount = _local_2[_local_4].amount;
                    _local_3.push(_local_5);
                    _local_4++;
                };
                ResourceAlert.show("ConfirmResetHalfSkillpoints", null, "", null, _local_3, (Alert.CANCEL | Alert.OK), null, this.ResetHandler, null, true, ResourceAlert.STYLE_WHITE_RESOURCES);
            };
        }

        protected function ApplySkillPoints(_arg_1:MouseEvent):void
        {
            if (this._skillTree.isChanged())
            {
                this._skillTree.applyGUI();
            };
        }

        override protected function HideWithoutQueue():void
        {
            var _local_1:cSkill;
            super.HideWithoutQueue();
            this._skillTree.undo();
            for each (_local_1 in this._skillTree.getItems_vector())
            {
                _local_1.removeEventListener(Event.CHANGE, this._changedSkill);
                _local_1.removeEventListener(Event.CANCEL, this._changedSkill);
            };
            this._skillTree.removePropertyObserver(cSkillList.SKILLLIST_CHANGED, this);
        }

        private function _updateView():void
        {
            this.mPanel.pointsCount.text = ((this._skillTree.getSumPoints() + "/") + this._skillTree.getMaxPoints());
            if (((this._skillTree.getSumPoints() < this._skillTree.getMaxPoints()) && (!(this._gi.IsAdventureZone()))))
            {
                this.mPanel.skillpoints.alpha = 1;
                this.mPanel.pointsBG.setStyle("backgroundAlpha", 0);
                this.mPanel.pointsText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "OverallMaxPoints");
                this.mPanel.pointsText.setStyle("color", "#FFFFFF");
                this.mPanel.pointsCount.setStyle("color", "#FFFFFF");
            }
            else
            {
                this.mPanel.skillpoints.alpha = 0.5;
                this.mPanel.pointsBG.setStyle("backgroundAlpha", 1);
                this.mPanel.pointsText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "MaxSkillPoints");
                this.mPanel.pointsText.setStyle("color", "#000000");
                this.mPanel.pointsCount.setStyle("color", "#000000");
            };
            var _local_1:Boolean = this._skillTree.isChanged();
            if (((!(this._skillTree.waiting)) && (this._gi.isOnHomzone())))
            {
                this.mPanel.skillTree.mouseChildren = true;
                this.mPanel.skillTree.filters = [];
                this.mPanel.btnApplySkillpoints.enabled = _local_1;
                this.mPanel.btnCancelSkillpoints.enabled = _local_1;
                this.mPanel.btnBack.enabled = true;
                this.mPanel.btnRefund.enabled = ((!(_local_1)) && (this._skillTree.getResetRewards(false).length > 0));
                this.mPanel.btnRefundPremium.enabled = ((!(_local_1)) && (this._skillTree.getResetRewards(true).length > 1));
            }
            else
            {
                this.mPanel.skillTree.mouseChildren = true;
                this.mPanel.btnApplySkillpoints.enabled = false;
                this.mPanel.btnCancelSkillpoints.enabled = false;
                this.mPanel.btnBack.enabled = true;
                this.mPanel.btnRefund.enabled = false;
                this.mPanel.btnRefundPremium.enabled = false;
            };
            var _local_2:int = (this.mPanel.skillTree.numChildren - 1);
            while (_local_2 >= 0)
            {
                (this.mPanel.skillTree.getChildAt(_local_2) as SkillTreeItemRenderer).updateView();
                _local_2--;
            };
        }

        private function ResetPremiumHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                this._skillTree.resetSkillpointsGUI(true);
            };
        }

        public function Init(_arg_1:SkillTreeWindow):void
        {
            this._avialablePoints = new Dictionary();
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        protected function RefundAllSkillPoints(_arg_1:MouseEvent):void
        {
            var _local_3:Vector.<dResource>;
            var _local_4:dResource;
            var _local_2:cResources = this._gi.mCurrentPlayerZone.GetResources(this._gi.mCurrentPlayer);
            if (_local_2.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, this._skillTree.getResetCosts()))
            {
                _local_3 = new Vector.<dResource>();
                _local_4 = new dResource();
                _local_4.name_string = defines.HARD_CURRENCY_RESOURCE_NAME_string;
                _local_4.amount = this._skillTree.getResetCosts();
                _local_3.push(_local_4);
                ResourceAlert.show("ConfirmResetAllSkillpoints", [_local_4.amount], "", null, _local_3, (Alert.CANCEL | Alert.OK), null, this.ResetPremiumHandler);
            }
            else
            {
                CustomAlert.show("MissingHardCurrency", "", (Alert.OK | Alert.CANCEL), null, this.AddHardCurrencyHandler, null, Alert.OK, true, CustomAlert.STYLE_PAYMENT);
            };
        }

        private function CreateGeneralTooltip(_arg_1:ToolTipEvent):void
        {
            cToolTipUtil.createToolTip(cToolTipUtil.MILITARY_UNIT_GENERAL_string, _arg_1, this._owner);
        }

        private function _createRenderer(_arg_1:cSkill):SkillTreeItemRenderer
        {
            var _local_2:SkillTreeItemRenderer = new SkillTreeItemRenderer();
            _local_2.setSkill(_arg_1, this._avialablePoints);
            return (_local_2);
        }


    }
}
