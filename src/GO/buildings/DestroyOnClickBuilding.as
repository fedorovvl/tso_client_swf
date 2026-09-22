package GO.buildings
{
    import GO.cBuilding;
    import Interface.cGeneralInterface;
    import GOSets.cGOSetList;

    public class DestroyOnClickBuilding extends cBuilding 
    {

        public function DestroyOnClickBuilding(_arg_1:cGeneralInterface, _arg_2:int)
        {
            super(_arg_1, _arg_2);
        }

        override public function shouldPlayDestroyEffect():Boolean
        {
            return (false);
        }

        override public function shouldDestroyBuildingFromUnexploredSector():Boolean
        {
            return (false);
        }

        override public function getBuildingIsAttackable():Boolean
        {
            return (false);
        }

        override public function Refund():void
        {
        }

        override protected function RenderUpgradeLevelAndPlayerColor():void
        {
        }

        override protected function renderBuildingModeDestruction(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
            var _local_6:cGOSetList = getDestructionAnimEffectSet();
            if (_local_6 != null)
            {
                _local_6.SetValue(_arg_1);
                _local_6.Animate(mGeneralInterface.mCalculateTicks.mDeltaTicksOne);
                _local_6.Render(GetXInt(), GetYInt());
            };
        }

        override public function SetCollectibleMode():void
        {
            SetBuildingMode(cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES);
        }

        override public function handleSelectBuilding():Boolean
        {
            var _local_1:int;
            var _local_2:cGOSetList;
            if (((getPlayerID() == mGeneralInterface.mCurrentPlayer.GetPlayerId()) || (mGeneralInterface.mCurrentPlayer.mIsAdventureZone)))
            {
                if (!IsDestructionInitiated())
                {
                    _local_1 = this.GetGrid();
                    if (!mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.IsAnimationAtGridPos(_local_1))
                    {
                        _local_2 = this.getDestructionAnimEffectSet();
                        mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.AddAnimation(_local_1, _local_2.mName_string, 0, global.streetGridYHalf, null);
                    };
                    mGeneralInterface.mCurrentPlayerZone.SendDestructBuildingCommand(this, "cCollectibleBuilding");
                };
            };
            return (true);
        }


    }
}
