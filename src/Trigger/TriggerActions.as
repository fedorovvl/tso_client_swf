package Trigger
{
    import Interface.cGeneralInterface;
    import Communication.VO.dQuestDefinitionTriggerVO;
    import GOSets.cGOSetList;

    public final class TriggerActions 
    {

        private var mGeneralInterface:cGeneralInterface;

        public function TriggerActions(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
        }

        public function startOnCompleteEffects(_arg_1:dQuestDefinitionTriggerVO):void
        {
            if ((("" == _arg_1.onComplete_string) || (_arg_1.onComplete_string == null)))
            {
                return;
            };
            var _local_2:Array = _arg_1.onComplete_string.split(",");
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                var _local_4:* = this;
                (_local_4[_local_2[_local_3]](_arg_1));
                _local_3++;
            };
        }

        public function destroySelectedBuilding(_arg_1:dQuestDefinitionTriggerVO):void
        {
            var _local_3:cGOSetList;
            if (this.mGeneralInterface.mCurrentlySelectededBuilding == null)
            {
                return;
            };
            var _local_2:int = this.mGeneralInterface.mCurrentlySelectededBuilding.GetGrid();
            if (!this.mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.IsAnimationAtGridPos(_local_2))
            {
                _local_3 = this.mGeneralInterface.mCurrentlySelectededBuilding.getDestructionAnimEffectSet();
                this.mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.AddAnimation(_local_2, _local_3.mName_string, 0, global.streetGridYHalf, null);
                this.mGeneralInterface.mCurrentlySelectededBuilding.mIsSelectable = false;
            };
        }


    }
}
