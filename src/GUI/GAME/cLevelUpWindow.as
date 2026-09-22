package GUI.GAME
{
    import GUI.Components.LevelUpWindow;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import GUI.FloatingItemsManager;
    import Communication.VO.EffectVO;
    import BuffSystem.cBuffDefinition;
    import GUI.Assets.gAssetManager;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import mx.collections.ArrayCollection;
    import Interface.cGameInterface;
    import Effects.Effects.Reward;
    import Effects.Effects.FulfillCondition;
    import BuffSystem.cBuff;

    public class cLevelUpWindow extends cBasicPanel 
    {

        private var mPanel:LevelUpWindow;


        public function Init(_arg_1:LevelUpWindow):void
        {
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnCloseQuest.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            FloatingItemsManager.flyRewards(this.mPanel.rewards.getRewardFrames());
            Hide();
        }

        public function SetData(_arg_1:int):void
        {
            var _local_2:int;
            var _local_7:EffectVO;
            var _local_8:String;
            var _local_9:cBuffDefinition;
            _local_2 = int((_arg_1 / 10));
            var _local_3:int = (_arg_1 % 10);
            this.mPanel.digit2.source = gAssetManager.GetBitmap(("LevelUpDigit" + _local_3));
            if (_local_2 == 0)
            {
                this.mPanel.digit1.visible = false;
            }
            else
            {
                this.mPanel.digit1.source = gAssetManager.GetBitmap(("LevelUpDigit" + _local_2));
                this.mPanel.digit1.visible = true;
            };
            this.mPanel.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "LevelUp");
            var _local_4:ArrayCollection = new ArrayCollection();
            var _local_5:ArrayCollection = new ArrayCollection();
            var _local_6:cGameInterface = (global.ui as cGameInterface);
            for each (_local_7 in global.playerLevelEffects_vector[(_arg_1 - 1)])
            {
                _local_8 = _local_7.effect_string;
                if (_local_8 == Reward.XML_string)
                {
                    _local_5.addItem(_local_7);
                }
                else
                {
                    if (_local_8 == FulfillCondition.XML_string)
                    {
                        _local_9 = cBuff.getBuffDefinitionByName(_local_7.name_string);
                        if (((((_local_9 == null) || (!(_local_9.isEventProduceable()))) || (_local_6.mEventManager.isEventStarted(_local_9.RequiredEventName()))) && (!(_local_7.action_string.toLowerCase() == "hideinlevelupwindow"))))
                        {
                            _local_4.addItem(_local_7);
                        };
                    };
                };
            };
            this.mPanel.unlockings.dataProvider = _local_4;
            this.mPanel.rewards.dataProvider = _local_5;
        }

        override public function Show():void
        {
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel);
        }


    }
}
