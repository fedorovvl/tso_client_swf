package BuffSystem
{
    import TimedProduction.cAbstractTimedProductionOrder;
    import Communication.VO.dTimedProductionVO;
    import Interface.cGeneralInterface;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import AdventureSystem.cAdventureDefinition;
    import Utils.StringUtils;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import Interface.cGameInterface;
    import Enums.AVATAR_MESSAGE_TYPE;
    import ServerState.dResource;
    import com.bluebyte.tso.util.TimeUtil;
    import Enums.ModifyReason;
    import Model.Notifiers.BuffAppliedNotification;
    import Tracks.TrackManager;
    import ServerState.cPlayerData;

    public class cBuffProductionOrder extends cAbstractTimedProductionOrder 
    {

        private var wasTransferedToWarehouse:Boolean = false;
        private var applyResourceBuffsInstant:Boolean = false;

        public function cBuffProductionOrder(_arg_1:dTimedProductionVO, _arg_2:cGeneralInterface, _arg_3:Boolean)
        {
            super(_arg_1, _arg_2);
            definition = cBuffDefinition.GetByName(_arg_1.type_string);
            this.wasTransferedToWarehouse = false;
            this.applyResourceBuffsInstant = _arg_3;
            ORDER_TYPE = "BuffProduction";
            _arg_2.mCurrentPlayer.notifyPropertyObserver(PRODUCTION_START, this);
        }

        override public function IsProduceable(_arg_1:cGameInterface):Boolean
        {
            var _local_2:cBuffDefinition;
            var _local_3:dAdventureClientInfoVO;
            var _local_4:cAdventureDefinition;
            if (((!(definition == null)) && (definition.IsProducible())))
            {
                return (true);
            };
            _local_2 = (definition as cBuffDefinition);
            if (!StringUtils.isEmpty(_local_2.GetGroup_string()))
            {
                for each (_local_3 in AdventureManager.getInstance().getAdventures())
                {
                    _local_4 = cAdventureDefinition.FindAdventureDefinition(_local_3.adventureName);
                    if ((((!(_local_4 == null)) && (_local_4.IsUsingAdventureSpecificBuffs())) && (_local_4.GetConnectedBuffGroup() == _local_2.GetGroup_string())))
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        override public function GetOnFinishedAvatarMessageType():String
        {
            return ((this.wasTransferedToWarehouse) ? null : AVATAR_MESSAGE_TYPE.PRODUCTION_FINISHED);
        }

        override public function CreateItem(_arg_1:cPlayerData, _arg_2:cGeneralInterface, _arg_3:int):void
        {
            var _local_10:dResource;
            var _local_11:int;
            var _local_4:cBuffDefinition = (definition as cBuffDefinition);
            var _local_5:cBuffDefinition;
            var _local_6:Boolean = ((_local_4.isAllowInstantApplyOnProduce()) && (GetProductionVO().type_string.indexOf("AddResource_") > -1));
            var _local_7:Boolean = ((_local_6) || (this.applyResourceBuffsInstant));
            if (_local_6)
            {
                _local_5 = cBuffDefinition.GetByName("AddResource");
            };
            var _local_8:cBuff = new cBuff(((_local_6) ? _local_5 : _local_4), GetProductionVO().uniqueId, 0);
            _local_8.SetAmount((Math.max(1, _local_4.GetAmount()) * Math.max(1, GetProductionVO().amount)));
            _local_8.SetInsertedAt(TimeUtil.getServerTime());
            if (_local_4.GetAmount() > 0)
            {
                if (_local_6)
                {
                    _local_8.SetResourceName(_local_4.GetResourceName_string());
                };
            };
            var _local_9:int = _local_8.GetAmount();
            if (_local_7)
            {
                _local_10 = _arg_2.mCurrentPlayerZone.GetResources(_arg_1).GetPlayerResource(_local_8.GetResourceName_string());
                _local_11 = Math.min((_local_10.maxLimit - _local_10.amount), _local_8.GetAmount());
                if (((_local_11 > 0) && (_arg_2.mCurrentPlayerZone.GetResources(_arg_1).AddResource(_local_8.GetResourceName_string(), _local_11, ModifyReason.CREATE_ITEM, null))))
                {
                    _local_8.SetAmount((_local_8.GetAmount() - _local_11));
                };
                _arg_2.channels.BUFF.send(cBuff.BUFF_APPLIED_string, new BuffAppliedNotification(_local_8, null, _local_11, _arg_1.GetPlayerId()));
            };
            this.wasTransferedToWarehouse = ((_local_7) && (_local_8.GetAmount() == 0));
            if (this.wasTransferedToWarehouse)
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.USED_RESOURCE_BUFF, [_local_8.GetResourceName_string(), _local_9]);
            };
            if (!this.wasTransferedToWarehouse)
            {
                _arg_1.addBuff(_local_8);
            };
            TrackManager.getInstance().trackBuffsProduction(_arg_1, definition.GetType(), GetProductionVO().amount);
        }


    }
}
