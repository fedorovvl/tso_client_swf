package TimedProduction
{
    import __AS3__.vec.Vector;
    import Communication.VO.EffectVO;
    import Communication.VO.dTimedProductionVO;
    import Interface.cGeneralInterface;
    import BuffSystem.cBuffDefinition;
    import Enums.BUFF_TYPE;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Effects.Effect;
    import Effects.Effects.Reward;
    import GO.cBuilding;
    import Interface.cGameInterface;
    import Effects.EffectFactory;
    import ServerState.cPlayerData;
    import __AS3__.vec.*;

    public class EffectTimedProductionOrder extends cAbstractTimedProductionOrder 
    {

        private var wasTransferedToWarehouse:Boolean = false;
        protected var effectVOs_vector:Vector.<EffectVO> = new Vector.<EffectVO>();
        private var applyResourceBuffsInstant:Boolean = false;

        public function EffectTimedProductionOrder(_arg_1:dTimedProductionVO, _arg_2:cGeneralInterface, _arg_3:Boolean)
        {
            var _local_4:iTimedProductionDefinition;
            var _local_5:EffectTimedProductionDefinition;
            var _local_6:EffectVO;
            super(_arg_1, _arg_2);
            this.applyResourceBuffsInstant = _arg_3;
            for each (_local_4 in global.timedProductions_vector[_arg_1.productionType])
            {
                if (_local_4.GetType() == _arg_1.type_string)
                {
                    _local_5 = (_local_4 as EffectTimedProductionDefinition);
                    definition = _local_5;
                    this.effectVOs_vector = new Vector.<EffectVO>();
                    for each (_local_6 in _local_5.effects_vector)
                    {
                        this.effectVOs_vector.push(_local_6.clone());
                    };
                };
            };
            ORDER_TYPE = "EffectTimedProduction";
            _arg_2.mCurrentPlayer.notifyPropertyObserver(PRODUCTION_START, this);
        }

        override public function GetOnFinishedAvatarMessageType():String
        {
            var _local_1:EffectTimedProductionDefinition = (definition as EffectTimedProductionDefinition);
            if (_local_1.preventDefaultAvatarMessage)
            {
                return (null);
            };
            var _local_2:cBuffDefinition = ((_local_1.effects_vector.length > 0) ? cBuffDefinition.GetByName(_local_1.effects_vector[0].name_string) : null);
            var _local_3:Boolean = ((_local_2 != null) ? (_local_2.GetBuffType() == BUFF_TYPE.ZONE_TIMED) : false);
            if (_local_3)
            {
                return (null);
            };
            return ((this.wasTransferedToWarehouse) ? null : AVATAR_MESSAGE_TYPE.PRODUCTION_FINISHED);
        }

        override public function CreateItem(_arg_1:cPlayerData, _arg_2:cGeneralInterface, _arg_3:int):void
        {
            var _local_8:EffectVO;
            var _local_9:Boolean;
            var _local_10:Effect;
            var _local_11:cBuffDefinition;
            var _local_12:String;
            var _local_13:Reward;
            var _local_4:cBuilding = _arg_2.mCurrentPlayerZone.GetBuildingFromGridPosition(GetProductionVO().buildingGrid);
            var _local_5:cTimedProductionQueue = _arg_2.mCurrentPlayerZone.GetProductionQueue(timedProductionVO.productionType);
            if (((_local_4 == null) && (!(_local_5 == null))))
            {
                _local_4 = _local_5.productionBuilding;
            };
            var _local_6:EffectFactory = (_arg_2 as cGameInterface).effectFactory;
            var _local_7:int;
            while (_local_7 < this.effectVOs_vector.length)
            {
                _local_8 = this.effectVOs_vector[_local_7].clone();
                _local_9 = ((_local_8.effect_string.indexOf(Reward.XML_string) >= 0) || (_local_8.action_string.indexOf(Reward.XML_string) >= 0));
                if (_local_7 == 0)
                {
                    _local_8.uniqueID = GetProductionVO().uniqueId;
                };
                _local_8.amount = (_local_8.amount * GetProductionVO().amount);
                _local_8.isFromTimedProductionQueue = true;
                if (_local_4 != null)
                {
                    _local_8.targetGridPos = _local_4.GetGrid();
                };
                this.wasTransferedToWarehouse = false;
                _local_10 = _local_6.createEffect(_local_8);
                if ((((_local_9) && (this.applyResourceBuffsInstant)) && (GetProductionVO().type_string.indexOf("AddResource_") > -1)))
                {
                    _local_11 = cBuffDefinition.GetByName(GetProductionVO().type_string);
                    if (((!(_local_11 == null)) && (_local_11.isAllowInstantApplyOnProduce())))
                    {
                        this.wasTransferedToWarehouse = (_local_10 as Reward).tryIntantApply(_arg_1, _arg_3);
                    };
                };
                if (!this.wasTransferedToWarehouse)
                {
                    _local_10.apply();
                };
                if (_local_9)
                {
                    _local_12 = _local_8.type_string.toLowerCase();
                    _local_13 = (_local_10 as Reward);
                    if (_local_12 == "buff")
                    {
                    };
                };
                _local_7++;
            };
        }


    }
}
