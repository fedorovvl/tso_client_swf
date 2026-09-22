package GUI.GAME
{
    import Interface.cGameInterface;
    import Communication.VO.dQuestElementVO;
    import GUI.Components.DailyLoginPanel;
    import Sound.cSoundManager;
    import flash.events.MouseEvent;
    import GUI.Components.Frame;
    import GUI.Components.CustomLabel;
    import Communication.VO.dQuestDefinitionVO;
    import mx.collections.ArrayCollection;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Assets.gAssetManager;
    import Communication.VO.dQuestDefinitionRewardVO;
    import mx.events.FlexEvent;
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;
    import Communication.VO.dQuestDefinitionPostrequisitsVO;
    import nLib.gMisc;
    import Communication.VO.dBuffVO;
    import Communication.VO.dSpecialistVO;
    import Communication.VO.dResourceVO;
    import Enums.SPECIALIST_TYPE;
    import Communication.VO.UpdateVO.dLootItemsVO;
    import flash.events.Event;

    public class cDailyLoginPanel extends cBasicPanel 
    {

        private var mGI:cGameInterface;
        private var mCurrentQuest:dQuestElementVO;
        protected var mPanel:DailyLoginPanel;


        override public function Hide():void
        {
            this.mGI.mQuestClientCallbacks.RewardOkButtonPressedFromGui(this.mCurrentQuest);
            super.Hide();
        }

        override public function Show():void
        {
            super.Show();
        }

        private function Accept(_arg_1:MouseEvent):void
        {
            cSoundManager.getInstance().playEffect("MenuClose");
            this.Hide();
        }

        override protected function HideWithoutQueue():void
        {
            this.mGI.mQuestClientCallbacks.RewardOkButtonPressedFromGui(this.mCurrentQuest);
            super.HideWithoutQueue();
        }

        public function SetData(_arg_1:dQuestElementVO, _arg_2:int):void
        {
            var _local_3:Frame;
            var _local_4:CustomLabel;
            var _local_5:dQuestDefinitionVO;
            var _local_6:dQuestDefinitionVO;
            var _local_7:ArrayCollection;
            var _local_8:int;
            var _local_9:int;
            this.mCurrentQuest = _arg_1;
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "DailyLoginReward");
            this.mPanel.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "DailyLoginReward");
            for each (_local_3 in this.mPanel.rewardsList.getChildren())
            {
                _local_3.Clear();
            };
            for each (_local_4 in this.mPanel.daysLabels.getChildren())
            {
                _local_4.setStyle("fontWeight", "normal");
            };
            _local_5 = _arg_1.mQuestDefinition;
            _local_6 = null;
            _local_7 = _arg_1.mOtherQuestDefinition_vector;
            _local_7 = this.SortQuestChain(_local_7, _local_5);
            _local_8 = 1;
            while (_local_8 <= _local_7.length)
            {
                if (_local_7.getItemAt((_local_8 - 1)) == _local_5) break;
                _local_8++;
            };
            _local_6 = (_local_7.getItemAt((_local_7.length - 1)) as dQuestDefinitionVO);
            if (_arg_2 > 0)
            {
                if ((_local_8 + _arg_2))
                {
                    _local_9 = 1;
                    while (_local_9 <= _local_7.length)
                    {
                        if (_local_9 < _local_8)
                        {
                            this.mPanel[(("day" + _local_9) + "result")].visible = true;
                            this.mPanel[(("day" + _local_9) + "result")].source = gAssetManager.GetBitmap("DailyLoginPassed");
                            this.mPanel[("day" + _local_9)].type = Frame.DAILY_LOGIN;
                        }
                        else
                        {
                            if (_local_9 < ((_local_8 + _arg_2) - 1))
                            {
                                this.mPanel[("day" + _local_9)].type = Frame.DAILY_LOGIN;
                            };
                            this.mPanel[(("day" + _local_9) + "result")].visible = true;
                            this.mPanel[(("day" + _local_9) + "result")].source = gAssetManager.GetBitmap("DailyLoginFailed");
                        };
                        _local_9++;
                    };
                };
                if (((_local_8 + _arg_2) - 1) <= _local_7.length)
                {
                    this.mPanel[(("day" + ((_local_8 + _arg_2) - 1)) + "label")].setStyle("fontWeight", "bold");
                    this.mPanel[("day" + ((_local_8 + _arg_2) - 1))].type = Frame.BUFF_TIMED;
                };
                this.mPanel.daysRemaining.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "DailyLoginFailed");
            }
            else
            {
                _local_9 = 1;
                while (_local_9 <= _local_7.length)
                {
                    if (_local_9 < _local_8)
                    {
                        this.mPanel[(("day" + _local_9) + "result")].visible = true;
                        this.mPanel[(("day" + _local_9) + "result")].source = gAssetManager.GetBitmap("DailyLoginPassed");
                        this.mPanel[("day" + _local_9)].type = Frame.DAILY_LOGIN;
                    }
                    else
                    {
                        if (((_local_9 > _local_8) && (!(_local_9 == _local_7.length))))
                        {
                            this.mPanel[(("day" + _local_9) + "result")].visible = true;
                            this.mPanel[(("day" + _local_9) + "result")].source = gAssetManager.GetBitmap("DailyLoginQuestionMark");
                        }
                        else
                        {
                            this.mPanel[(("day" + _local_9) + "result")].visible = false;
                        };
                    };
                    _local_9++;
                };
                this.mPanel[(("day" + _local_8) + "label")].setStyle("fontWeight", "bold");
                if (_arg_1.mLootItemsVO_vector.length > 0)
                {
                    this.DisplayLootReward(("day" + _local_8), _arg_1.mLootItemsVO_vector[0], Frame.BUFF_TIMED);
                }
                else
                {
                    this.DisplayReward(("day" + _local_8), (_local_5.questReward.getItemAt(0) as dQuestDefinitionRewardVO), Frame.BUFF_TIMED);
                };
                this.DisplayReward(("day" + _local_7.length), (_local_6.questReward.getItemAt(0) as dQuestDefinitionRewardVO), Frame.DAILY_LOGIN_LAST);
                this.mPanel.daysRemaining.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "DailyLoginRemainingDays", [_local_8.toString(), this.mPanel[("day" + _local_8)].amount.toString(), this.mPanel[("day" + _local_8)].content]);
            };
        }

        public function Init(_arg_1:DailyLoginPanel):void
        {
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.mGI = (global.ui as cGameInterface);
            openSound = "";
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.Accept);
        }

        private function SortQuestChain(_arg_1:ArrayCollection, _arg_2:dQuestDefinitionVO):ArrayCollection
        {
            var _local_5:dQuestDefinitionVO;
            var _local_7:int;
            var _local_3:ArrayCollection = new ArrayCollection();
            var _local_4:String;
            var _local_6:ArrayCollection = new ArrayCollection();
            _local_6.addItem(_arg_2);
            for each (_local_5 in _arg_1)
            {
                _local_6.addItem(_local_5);
            };
            _local_7 = _local_6.length;
            for each (_local_5 in _local_6)
            {
                if (_local_5.specialType_string == QuestManagerStatic.SPECIAL_TYPE_FIRST_DAILY_QUEST)
                {
                    _local_6.removeItemAt(_local_6.getItemIndex(_local_5));
                    _local_3.addItem(_local_5);
                    _local_4 = (_local_5.questPostrequisits.getItemAt(0) as dQuestDefinitionPostrequisitsVO).name_string;
                    break;
                };
            };
            gMisc.Assert((!(_local_4 == null)), "First Daily Quest not found specialType='firstDailyQuest' is missing");
            while (_local_3.length < _local_7)
            {
                for each (_local_5 in _local_6)
                {
                    if (_local_5.questName_string == _local_4)
                    {
                        _local_6.removeItemAt(_local_6.getItemIndex(_local_5));
                        _local_3.addItem(_local_5);
                        _local_4 = (_local_5.questPostrequisits.getItemAt(0) as dQuestDefinitionPostrequisitsVO).name_string;
                        break;
                    };
                };
            };
            return (_local_3);
        }

        private function DisplayReward(_arg_1:String, _arg_2:dQuestDefinitionRewardVO, _arg_3:String="empty"):void
        {
            var _local_4:Frame = (this.mPanel[_arg_1] as Frame);
            _local_4.type = _arg_3;
            var _local_5:int;
            switch (_arg_2.type)
            {
                case QuestManagerStatic.TYPE_RESOURCE:
                    _local_4.contentType = Frame.CONTENT_TYPE_RESOURCE;
                    _local_4.amount = _arg_2.amount;
                    _local_4.content = _arg_2.name_string;
                    _local_4.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _arg_2.name_string);
                    return;
                case QuestManagerStatic.TYPE_ADVENTURE:
                    _local_4.contentType = Frame.CONTENT_TYPE_ADVENTURE;
                    _local_4.content = _arg_2.name_string;
                    _local_4.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.ADVENTURE_NAME, _arg_2.name_string);
                    return;
            };
        }

        private function DisplayLootReward(_arg_1:String, _arg_2:dLootItemsVO, _arg_3:String="empty"):void
        {
            var _local_6:dBuffVO;
            var _local_7:String;
            var _local_8:dSpecialistVO;
            var _local_9:dResourceVO;
            var _local_4:Frame = (this.mPanel[_arg_1] as Frame);
            _local_4.type = _arg_3;
            var _local_5:Object = _arg_2.items[0];
            if ((_local_5 is dBuffVO))
            {
                _local_6 = (_local_5 as dBuffVO);
                _local_7 = ((_local_6.resourceName_string == "") ? _local_6.buffName_string : _local_6.resourceName_string);
                _local_4.contentType = Frame.CONTENT_TYPE_RESOURCE;
                _local_4.content = _local_7;
                _local_4.amount = _local_6.amount;
                _local_4.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_7);
            }
            else
            {
                if ((_local_5 is dSpecialistVO))
                {
                    _local_8 = (_local_5 as dSpecialistVO);
                    _local_4.contentType = Frame.CONTENT_TYPE_NORMAL;
                    _local_4.content = SPECIALIST_TYPE.toString(_local_8.specialistType);
                    _local_4.amount = 1;
                    _local_4.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.SPECIALISTS, SPECIALIST_TYPE.toString(_local_8.specialistType));
                }
                else
                {
                    if ((_local_5 is dResourceVO))
                    {
                        _local_9 = (_local_5 as dResourceVO);
                        _local_4.contentType = Frame.CONTENT_TYPE_RESOURCE;
                        _local_4.content = _local_9.name_string;
                        _local_4.amount = _local_9.amount;
                        _local_4.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_9.name_string);
                    }
                    else
                    {
                        gMisc.Assert(false, (("Could not interpret item " + _local_5) + " for a loot item!"));
                    };
                };
            };
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
        }


    }
}
