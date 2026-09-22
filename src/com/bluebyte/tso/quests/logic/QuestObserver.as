package com.bluebyte.tso.quests.logic
{
    import Model.Observer;
    import Utils.Disposable;
    import Interface.cGameInterface;
    import Communication.VO.dQuestPoolVO;
    import Communication.VO.EffectVO;
    import Effects.Effects.Reward;
    import Enums.REQUIREMENT_TYPE;
    import Communication.VO.dQuestDefinitionVO;
    import Communication.VO.dQuestElementVO;
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;
    import Model.Notifier;

    public final class QuestObserver implements Observer, Disposable 
    {

        private var gi:cGameInterface;
        private var pool:dQuestPoolVO;

        public function QuestObserver(_arg_1:cGameInterface, _arg_2:dQuestPoolVO)
        {
            super();
            this.gi = _arg_1;
            this.pool = _arg_2;
            _arg_2.addPropertyObserver(dQuestPoolVO.POOL_NOTIFICATION_string, this);
        }

        public function startPostEffects(_arg_1:dQuestDefinitionVO):void
        {
            var _local_2:int;
            var _local_4:EffectVO;
            var _local_5:String;
            var _local_3:int = _arg_1.postEffects_vector.length;
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                _local_4 = (_arg_1.postEffects_vector[_local_2] as EffectVO).clone();
                _local_5 = _local_4.effect_string;
                if (_local_5 != Reward.XML_string)
                {
                    if (_local_5 == "condition")
                    {
                        _local_4.id = REQUIREMENT_TYPE.QUEST;
                        _local_4.item_string = _arg_1.questName_string;
                    };
                    this.gi.effectFactory.createEffect(_local_4).apply();
                };
                _local_2++;
            };
        }

        public function startPreEffects(_arg_1:dQuestDefinitionVO):void
        {
            var _local_2:EffectVO;
            var _local_3:int;
            var _local_4:int = _arg_1.preEffects_vector.length;
            _local_3 = 0;
            while (_local_3 < _local_4)
            {
                _local_2 = (_arg_1.preEffects_vector[_local_3] as EffectVO);
                if ((((!(_local_2.onQuestSight)) && (!(_local_2.effect_string == Reward.XML_string))) && (!(_local_2.effect_string.toLowerCase() == "spawnbuilding"))))
                {
                    this.gi.effectFactory.createEffect(_local_2).apply();
                };
                _local_3++;
            };
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:dQuestElementVO;
            var _local_5:int;
            var _local_6:dQuestPoolVO;
            if (this.gi == null)
            {
                _arg_1.removePropertyObserver(_arg_2, this);
                return;
            };
            if (_arg_2 == QuestManagerStatic.QUEST_MODE_string)
            {
                _local_4 = (_arg_1 as dQuestElementVO);
                _local_5 = _local_4.GetQuestMode();
                if (_local_5 != QuestManagerStatic.QUEST_MODE_LOOP_UNTIL_QUEST_REWARD_COULD_BE_ASSIGNED)
                {
                    if ((((!(_arg_3 == null)) || (!(this.gi.mRefreshZoneIsActive))) && ((_local_5 == QuestManagerStatic.QUEST_MODE_SHOW_WINDOW_DESCRIPTION) || (_local_5 == QuestManagerStatic.QUEST_MODE_START_WINDOW_DESCRIPTION_WAIT_FOR_BUTTON_PRESSED))))
                    {
                        this.startPreEffects(_local_4.GetQuestDefinition());
                    }
                    else
                    {
                        if (((_arg_3 == null) && (((_local_5 == QuestManagerStatic.QUEST_MODE_SHOW_WINDOW_DESCRIPTION) || (_local_5 == QuestManagerStatic.QUEST_MODE_START_WINDOW_DESCRIPTION_WAIT_FOR_BUTTON_PRESSED)) || (_local_5 == QuestManagerStatic.QUEST_MODE_RUNNING))))
                        {
                            this.reactivateEffects(_local_4.GetQuestDefinition());
                        };
                    };
                };
            }
            else
            {
                if (_arg_2 == dQuestPoolVO.POOL_NOTIFICATION_string)
                {
                    _local_6 = (_arg_1 as dQuestPoolVO);
                    _local_4 = (_arg_3 as dQuestElementVO);
                    if (_local_6.IsQuestDefinitionInPool(_local_4.mQuestDefinition))
                    {
                        _local_4.addPropertyObserver(QuestManagerStatic.QUEST_MODE_string, this);
                        this.update(_local_4, QuestManagerStatic.QUEST_MODE_string, null);
                    };
                };
            };
        }

        private function reactivateEffects(_arg_1:dQuestDefinitionVO):void
        {
            var _local_2:EffectVO;
            for each (_local_2 in _arg_1.preEffects_vector)
            {
                if (_local_2.reactivate)
                {
                    this.gi.effectFactory.createEffect(_local_2).apply();
                };
            };
        }

        public function dispose():void
        {
            this.pool.removePropertyObserver(dQuestPoolVO.POOL_NOTIFICATION_string, this);
            this.pool = null;
            this.gi = null;
        }


    }
}
