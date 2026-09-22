package GO.buildings
{
    import Interface.cGeneralInterface;
    import Collections.CollectionsConsts;
    import GO.cBuilding;
    import Enums.COMMAND;
    import Communication.VO.dUniqueID;

    public class cCollectibleBuilding extends DestroyOnClickBuilding 
    {

        public var waitingForServerAction:Boolean = false;

        public function cCollectibleBuilding(_arg_1:cGeneralInterface, _arg_2:int)
        {
            super(_arg_1, _arg_2);
        }

        override public function RenderBuildingLabels():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            super.RenderBuildingLabels();
            if (((hasBuff(CollectionsConsts.REVEAL_FRIENDS_COLLECTIBLES_BUFF)) || (mGeneralInterface.mZoneBuffManager.isBuffRunningStartsWith(CollectionsConsts.REVEAL_COLLECTIBLES_BUFF))))
            {
                _local_1 = int(mXScaled);
                _local_2 = int(mYScaled);
                _local_3 = int((mXNotScaled + mOffsetX));
                _local_4 = (int(mYNotScaled) - cBuilding.COLLECTIBLE_BUILDING_WOBBLE_ICON_OFFSET);
                _local_5 = mGeneralInterface.mCurrentPlayerZone.GetPlayerColorIdx(mGeneralInterface.mCurrentPlayer.GetPlayerId());
                gGfxResource.mUpgradeLevelIcons.SetSubType(_local_5);
                gGfxResource.mUpgradeLevelIcons.RenderPos(_local_3, ((_local_4 - (global.streetGridY + global.streetGridYHalf)) - mGeneralInterface.mWobblingInt));
            };
        }

        override protected function canHandleCollectibleBuff():Boolean
        {
            return (true);
        }

        override public function handleSelectBuilding():Boolean
        {
            super.handleSelectBuilding();
            if (!((getPlayerID() == mGeneralInterface.mCurrentPlayer.GetPlayerId()) || (mGeneralInterface.mCurrentPlayer.mIsAdventureZone)))
            {
                if (((!(hasBuff(CollectionsConsts.REVEAL_FRIENDS_COLLECTIBLES_BUFF))) && (!(this.waitingForServerAction))))
                {
                    mGeneralInterface.SendServerAction(COMMAND.REVEAL_FRIEND_COLLECTIBLE_BUILDING_BUFF, 0, GetGrid(), 0, new dUniqueID());
                    this.waitingForServerAction = true;
                };
            };
            return (true);
        }

        override protected function handleCollectibleBuffAdded(_arg_1:String):void
        {
            this.waitingForServerAction = false;
        }

        override protected function hideBuffAnimation():Boolean
        {
            return (true);
        }


    }
}
