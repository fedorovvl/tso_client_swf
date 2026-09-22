package TimedProduction
{
    import Modifier.Modifieable;
    import Communication.VO.dTimedProductionVO;
    import Interface.cGeneralInterface;
    import GO.cBuilding;
    import Interface.cGameInterface;
    import Enums.ModifyReason;
    import ServerState.cResources;
    import Enums.TIMED_PRODUCTION_TYPE;
    import Modifier.ModifierVO;
    import BuffSystem.BuffAppliance;
    import Communication.VO.dPersistedBuffApplianceVO;
    import BuffSystem.cBuffDefinition;
    import nLib.gMisc;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import ServerState.cPlayerData;
    import Modifier.Modifier;

    public class cAbstractTimedProductionOrder implements iProductionOrder, Modifieable 
    {

        public static const PRODUCTION_START:String = "PRODUCTION_START";

        protected var timedProductionVO:dTimedProductionVO;
        private var mGI:cGeneralInterface;
        public var ORDER_TYPE:String = "";
        protected var building:cBuilding;
        private var modified:Boolean;
        protected var definition:iTimedProductionDefinition;

        public function cAbstractTimedProductionOrder(_arg_1:dTimedProductionVO, _arg_2:cGeneralInterface)
        {
            super();
            this.timedProductionVO = _arg_1;
            this.mGI = _arg_2;
            var _local_3:cTimedProductionQueue = _arg_2.mCurrentPlayerZone.GetProductionQueue(_arg_1.productionType);
            if (_local_3 != null)
            {
                this.building = _local_3.productionBuilding;
            };
        }

        public function GetBuilding():cBuilding
        {
            return (this.building);
        }

        public function IsProduceable(_arg_1:cGameInterface):Boolean
        {
            return ((!(this.definition == null)) && (this.definition.IsProducible()));
        }

        public function isModified():Boolean
        {
            return (this.modified);
        }

        public function GetProductionVO():dTimedProductionVO
        {
            return (this.timedProductionVO);
        }

        public function SetInstantFinishCostModifiers(_arg_1:Number, _arg_2:int):void
        {
            this.timedProductionVO.modifiedInstantFinishCostMultiplier = (this.timedProductionVO.modifiedInstantFinishCostMultiplier * _arg_1);
            this.timedProductionVO.modifiedInstantFinishCostAdder = (this.timedProductionVO.modifiedInstantFinishCostAdder + _arg_2);
        }

        public function GetResourceName():String
        {
            return (this.definition.GetProductionName_string());
        }

        public function Pay(_arg_1:cResources):void
        {
            _arg_1.RemovePlayerResourcesFromResourcesInList(this.GetCostsToBuy_vector(), this.timedProductionVO.amount, ModifyReason.TIMED_PRODUCTION_ORDER);
        }

        public function GetDefinition():iTimedProductionDefinition
        {
            return (this.definition);
        }

        public function GetInstantBuildCosts():int
        {
            return (int(((this.definition.GetInstantBuildCosts() * this.timedProductionVO.modifiedInstantFinishCostMultiplier) + this.timedProductionVO.modifiedInstantFinishCostAdder)));
        }

        public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            return ((TIMED_PRODUCTION_TYPE.toString(this.timedProductionVO.productionType).indexOf(_arg_1.type_string) > -1) && ((_arg_1.item_string.length == 0) || (this.timedProductionVO.type_string.indexOf(_arg_1.item_string) > -1)));
        }

        public function CanAfford(_arg_1:cResources):Boolean
        {
            if (!_arg_1.HasPlayerResourcesInList(this.GetCostsToBuy_vector(), this.timedProductionVO.amount))
            {
                return (false);
            };
            return (true);
        }

        public function GetTimeBonus():Number
        {
            var _local_3:BuffAppliance;
            var _local_4:dPersistedBuffApplianceVO;
            var _local_5:cBuffDefinition;
            var _local_1:Number = 1;
            var _local_2:Number = 1;
            if (this.building != null)
            {
                if (this.building.GetUpgradeLevelBonuses() != null)
                {
                    _local_1 = (_local_1 * (this.building.GetUpgradeLevelBonuses().getRecruitingTime() / 100));
                };
                for each (_local_3 in this.building.mBuffs_vector)
                {
                    _local_2 = (_local_2 * (_local_3.GetBuffDefinition().getRecruitingTime() / 100));
                };
                for each (_local_4 in this.mGI.mZoneBuffManager.getBuffAppliancesForBuilding(this.building.GetBuildingName_string()))
                {
                    _local_5 = cBuffDefinition.GetById(_local_4.buffID);
                    if (_local_5 != null)
                    {
                        _local_2 = (_local_2 + ((_local_5.getRecruitingTime() - 100) / 100));
                    };
                };
            };
            return (_local_1 * _local_2);
        }

        public function GetOnFinishedAvatarMessageType():String
        {
            gMisc.Assert(false, "This method must not be called!");
            return ("");
        }

        public function GetCostsToBuy_vector():Vector.<dResource>
        {
            return (this.definition.GetCosts_vector());
        }

        public function CreateItem(_arg_1:cPlayerData, _arg_2:cGeneralInterface, _arg_3:int):void
        {
            gMisc.Assert(false, "This method must not be called!");
        }

        public function setModified(_arg_1:Modifier):void
        {
            this.modified = true;
        }

        public function SetProductionTimeModifiers(_arg_1:Number, _arg_2:int):void
        {
            this.timedProductionVO.modifiedProductionMultiplier = (this.timedProductionVO.modifiedProductionMultiplier * _arg_1);
            this.timedProductionVO.modifiedProductionAdder = (this.timedProductionVO.modifiedProductionAdder + _arg_2);
        }

        public function GetResourceAmount():int
        {
            var _local_1:int = this.timedProductionVO.amount;
            if (this.definition != null)
            {
                _local_1 = (_local_1 * this.definition.GetProductionAmount());
            };
            return (_local_1);
        }

        public function GetInstantBuildCostsUnmodified():int
        {
            return (this.definition.GetInstantBuildCosts());
        }

        public function GetProductionMultiplierInPercentage():int
        {
            return (int((100 - (100 * this.timedProductionVO.modifiedProductionMultiplier))));
        }

        public function GetProductionTime():int
        {
            return (int(((this.definition.GetProductionTime() * this.timedProductionVO.modifiedProductionMultiplier) + this.timedProductionVO.modifiedProductionAdder)));
        }


    }
}
