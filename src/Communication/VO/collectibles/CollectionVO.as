package Communication.VO.collectibles
{
    import TimedProduction.iTimedProductionDefinition;
    import Modifier.Modifieable;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import Utils.StringUtils;
    import Modifier.Modifiers.Productions.CollectionBuyFinishCost;
    import Modifier.ModifierVO;
    import Interface.cGameInterface;
    import ServerState.cResources;
    import Modifier.Modifier;
    import __AS3__.vec.*;

    public class CollectionVO implements iTimedProductionDefinition, Modifieable 
    {

        public static const UPDATING_HARD_CURRENCY_PRICE:String = "UPDATING_HARD_CURRENCY_PRICE";

        private var requiredPlayerLevel:int;
        private var name:String;
        private var blueprint:String;
        private var hardCurrency:int;
        private var playerHardCurrency:int;
        private var hardCurrencyUnmodified:int;
        private var outputBuffName:String;
        private var outputBuffResourceAmount:int;
        private var productionTime:int;
        private var collectionResources:Vector.<CollectionResourceVO>;
        private var instantBuildCostAdder:int;
        private var actualPlayerLevel:int;
        private var instantBuildCosts:int;
        private var requirestEvent:String;
        private var showResourceIcon:Boolean;
        private var modified:Boolean;
        private var outputBuffResourceName:String;
        private var instantBuildCostMultiplier:Number;

        public function CollectionVO(_arg_1:String, _arg_2:int, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:int, _arg_7:int, _arg_8:int, _arg_9:Boolean, _arg_10:String)
        {
            super();
            this.name = _arg_1;
            this.requiredPlayerLevel = _arg_2;
            this.blueprint = _arg_3;
            this.outputBuffName = _arg_4;
            this.productionTime = _arg_7;
            this.outputBuffResourceName = _arg_5;
            this.outputBuffResourceAmount = _arg_6;
            this.instantBuildCosts = _arg_8;
            this.showResourceIcon = _arg_9;
            this.requirestEvent = _arg_10;
            if (this.requirestEvent.length == 0)
            {
                this.requirestEvent = null;
            };
            this.instantBuildCostMultiplier = 1;
            this.instantBuildCostAdder = 0;
        }

        public static function retrieveInstantCollectionCosts(_arg_1:CollectionVO):Vector.<dResource>
        {
            var _local_3:dResource;
            var _local_2:Vector.<dResource> = new Vector.<dResource>();
            _local_3 = new dResource();
            _local_3.Init(defines.HARD_CURRENCY_RESOURCE_NAME_string, _arg_1.getHardCurrency());
            _local_2.push(_local_3);
            return (_local_2);
        }


        public function getName():String
        {
            return (this.name);
        }

        public function getIsAvailable():Boolean
        {
            if (!this.getHasNeededResources())
            {
                return (false);
            };
            if (!this.getHasNeededPlayerLevel())
            {
                return (false);
            };
            return (true);
        }

        public function getOutputBuffResourceAmount():int
        {
            return (this.outputBuffResourceAmount);
        }

        public function getHardCurrencyUnmodified():int
        {
            return (this.hardCurrencyUnmodified);
        }

        public function getOutputBuffName():String
        {
            return (this.outputBuffName);
        }

        public function GetType():String
        {
            return (this.name);
        }

        public function getHardCurrency():int
        {
            return (this.hardCurrency);
        }

        public function getHasHardCurrency():Boolean
        {
            return (this.playerHardCurrency >= this.hardCurrency);
        }

        public function getPlayerHardCurrency():int
        {
            return (this.playerHardCurrency);
        }

        public function getProductionTime():int
        {
            return (this.productionTime);
        }

        public function getCollectionResourcesAsArray():Array
        {
            var _local_2:CollectionResourceVO;
            var _local_1:Array = new Array();
            for each (_local_2 in this.collectionResources)
            {
                _local_1.push(_local_2);
            };
            return (_local_1);
        }

        public function getHasNeededPlayerLevel():Boolean
        {
            return (this.actualPlayerLevel >= this.requiredPlayerLevel);
        }

        public function isModified():Boolean
        {
            return (this.modified);
        }

        public function setPlayerHardCurrency(_arg_1:int):void
        {
            this.playerHardCurrency = _arg_1;
        }

        public function GetCosts_vector():Vector.<dResource>
        {
            var _local_2:CollectionResourceVO;
            var _local_3:dResource;
            var _local_1:Vector.<dResource> = new Vector.<dResource>();
            for each (_local_2 in this.getCollectionResources())
            {
                _local_3 = new dResource();
                _local_3.Init(_local_2.getName(), _local_2.getAmount());
                _local_1.push(_local_3);
            };
            return (_local_1);
        }

        public function GetProductionName_string():String
        {
            return (this.outputBuffName);
        }

        public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            return (StringUtils.equalsIgnoreCase(_arg_1.modifier_string, CollectionBuyFinishCost.xml_string));
        }

        public function getShowResourceIcon():Boolean
        {
            return (this.showResourceIcon);
        }

        public function getOutputBuffResourceName():String
        {
            return (this.outputBuffResourceName);
        }

        public function getIsActive(_arg_1:cGameInterface):Boolean
        {
            if (this.requirestEvent != null)
            {
                return (_arg_1.mEventManager.isEventStarted(this.requirestEvent));
            };
            return (true);
        }

        public function GetProductionAmount():int
        {
            return (1);
        }

        public function updateHardCurrencyPrice(_arg_1:cResources, _arg_2:cGameInterface):void
        {
            var _local_3:CollectionResourceVO;
            var _local_6:int;
            var _local_4:Object = global.resourceHardcurrencyValues;
            var _local_5:Number = 0;
            this.hardCurrency = 0;
            for each (_local_3 in this.getCollectionResources())
            {
                _local_6 = (_local_3.getAmount() - _arg_1.GetPlayerResource(_local_3.getName()).amount);
                if (_local_6 > 0)
                {
                    _local_5 = (_local_5 + (_local_4[_local_3.getName()] * _local_6));
                };
            };
            this.setInstantBuildCostModifiers(0, 0);
            _arg_2.mCurrentPlayer.notifyPropertyObserver(UPDATING_HARD_CURRENCY_PRICE, this);
            this.hardCurrencyUnmodified = (Math.floor((_local_5 + this.instantBuildCosts)) as int);
            _local_5 = (_local_5 + ((this.instantBuildCosts * this.instantBuildCostMultiplier) + this.instantBuildCostAdder));
            this.hardCurrency = (Math.floor(_local_5) as int);
        }

        public function GetInstantBuildCosts():int
        {
            return (this.instantBuildCosts);
        }

        public function GetRequieredEvent():String
        {
            return ("");
        }

        public function addCollectionResource(_arg_1:CollectionResourceVO):void
        {
            if (this.collectionResources == null)
            {
                this.collectionResources = new Vector.<CollectionResourceVO>();
            };
            this.collectionResources.push(_arg_1);
        }

        public function getRequiredPlayerLevel():int
        {
            return (this.requiredPlayerLevel);
        }

        public function setModified(_arg_1:Modifier):void
        {
            this.modified = true;
        }

        public function getBlueprint():String
        {
            return (this.blueprint);
        }

        public function setInstantBuildCostModifiers(_arg_1:Number, _arg_2:int):void
        {
            this.instantBuildCostMultiplier = _arg_1;
            if (this.instantBuildCostMultiplier == 0)
            {
                this.instantBuildCostMultiplier = 1;
            };
            this.instantBuildCostAdder = _arg_2;
        }

        public function IsProducible():Boolean
        {
            return (false);
        }

        public function GetProductionSourceName_string():String
        {
            return (this.GetProductionName_string());
        }

        public function clone():CollectionVO
        {
            var _local_2:CollectionResourceVO;
            var _local_1:CollectionVO = new CollectionVO(this.name, this.requiredPlayerLevel, this.blueprint, this.outputBuffName, this.outputBuffResourceName, this.outputBuffResourceAmount, this.productionTime, this.instantBuildCosts, this.showResourceIcon, this.requirestEvent);
            _local_1.actualPlayerLevel = this.actualPlayerLevel;
            for each (_local_2 in this.collectionResources)
            {
                _local_1.addCollectionResource(_local_2.clone());
            };
            if (this.isModified())
            {
                _local_1.setInstantBuildCostModifiers(this.instantBuildCostMultiplier, this.instantBuildCostAdder);
                _local_1.setModified(null);
            };
            return (_local_1);
        }

        public function getRequiresEvent():String
        {
            return (this.requirestEvent);
        }

        public function setCollectionResources(_arg_1:Vector.<CollectionResourceVO>):void
        {
            this.collectionResources = _arg_1;
        }

        public function getCollectionResources():Vector.<CollectionResourceVO>
        {
            return (this.collectionResources);
        }

        public function setActualPlayerLevel(_arg_1:int):void
        {
            this.actualPlayerLevel = _arg_1;
        }

        public function getHasNeededResources():Boolean
        {
            var _local_1:CollectionResourceVO;
            for each (_local_1 in this.collectionResources)
            {
                if (_local_1.getHasNeededResources() == false)
                {
                    return (false);
                };
            };
            return (true);
        }

        public function GetProductionTime():int
        {
            return (this.productionTime);
        }

        public function getActualPlayerLevel():int
        {
            return (this.actualPlayerLevel);
        }


    }
}
