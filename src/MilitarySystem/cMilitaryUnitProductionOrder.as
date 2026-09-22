package MilitarySystem
{
    import TimedProduction.cAbstractTimedProductionOrder;
    import Communication.VO.dTimedProductionVO;
    import Interface.cGeneralInterface;
    import ServerState.dResource;
    import ServerState.cResources;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Enums.TIMED_PRODUCTION_TYPE;
    import ServerState.cDataTracking;
    import Utils.TriggerUtils;
    import Tracks.TrackManager;
    import ServerState.cPlayerData;

    public class cMilitaryUnitProductionOrder extends cAbstractTimedProductionOrder 
    {

        public function cMilitaryUnitProductionOrder(_arg_1:dTimedProductionVO, _arg_2:cGeneralInterface)
        {
            super(_arg_1, _arg_2);
            definition = cMilitaryUnitBase.GetUnitBaseForType(GetProductionVO().type_string);
            ORDER_TYPE = "MilitaryProduction";
            _arg_2.mCurrentPlayer.notifyPropertyObserver(PRODUCTION_START, this);
        }

        override public function CanAfford(_arg_1:cResources):Boolean
        {
            var _local_2:dResource;
            for each (_local_2 in GetCostsToBuy_vector())
            {
                if (((_local_2.name_string == defines.POPULATION_RESOURCE_NAME_string) && (_arg_1.GetFree() < (_local_2.amount * GetProductionVO().amount))))
                {
                    return (false);
                };
            };
            return (super.CanAfford(_arg_1));
        }

        override public function GetOnFinishedAvatarMessageType():String
        {
            switch (timedProductionVO.productionType)
            {
                case TIMED_PRODUCTION_TYPE.MILITARY_UNIT:
                    return (AVATAR_MESSAGE_TYPE.RECRUITMENT_FINISHED);
                case TIMED_PRODUCTION_TYPE.COMBAT_THREE_UNITS:
                    return (AVATAR_MESSAGE_TYPE.RECRUITMENT_FINISHED_NEW_COMBAT);
                default:
                    return (AVATAR_MESSAGE_TYPE.RECRUITMENT_FINISHED);
            };
        }

        override public function CreateItem(_arg_1:cPlayerData, _arg_2:cGeneralInterface, _arg_3:int):void
        {
            _arg_2.mCurrentPlayerZone.GetArmy(_arg_1.GetPlayerId()).AddUnits(definition.GetType(), GetProductionVO().amount, 0, true);
            _arg_2.mDataTracking.IncTrackingDetail(cDataTracking.DATA_TRACKING_GENERAL_X_UNITS_OF_TYPE_X_TRAINED, definition.GetType(), GetProductionVO().amount);
            _arg_2.mCurrentPlayerZone.notifyPropertyObserver(TriggerUtils.UNITS_OWNED_NOTIFICATION_PROPERTY_NAME, definition.GetType());
            TrackManager.getInstance().trackUnitsHired(_arg_1, definition.GetType(), GetProductionVO().amount, TIMED_PRODUCTION_TYPE.toString(GetProductionVO().productionType));
        }

        override public function Pay(_arg_1:cResources):void
        {
            var _local_2:dResource;
            super.Pay(_arg_1);
            for each (_local_2 in GetCostsToBuy_vector())
            {
                if (_local_2.name_string == defines.POPULATION_RESOURCE_NAME_string)
                {
                    _arg_1.ModifyMilitaryPopulationResource((_local_2.amount * GetProductionVO().amount));
                    break;
                };
            };
        }


    }
}
