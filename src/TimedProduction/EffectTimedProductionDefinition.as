package TimedProduction
{
    import __AS3__.vec.Vector;
    import Communication.VO.EffectVO;
    import ServerState.dResource;
    import __AS3__.vec.*;

    public final class EffectTimedProductionDefinition implements iTimedProductionDefinition 
    {

        public var instantFinishCost:int;
        public var name_string:String;
        public var group:int;
        public var requiresEvent:String;
        public var duration:int;
        public var requiresQuest:String;
        public var requiresUpgradeLevelMin:int;
        public var effects_vector:Vector.<EffectVO> = new Vector.<EffectVO>();
        public var preventDefaultAvatarMessage:Boolean;
        public var costs_vector:Vector.<dResource> = new Vector.<dResource>();
        public var requiresUpgradeLevelMax:int;


        public function GetProductionAmount():int
        {
            return (this.effects_vector[0].amount);
        }

        public function GetGroup():int
        {
            return (this.group);
        }

        public function GetRequieredEvent():String
        {
            return (this.requiresEvent);
        }

        public function GetType():String
        {
            if (((!(this.name_string == null)) && (this.name_string.length > 0)))
            {
                return (this.name_string);
            };
            var _local_1:EffectVO = this.effects_vector[0];
            if (((!(_local_1.name_string == null)) && (_local_1.name_string.length > 0)))
            {
                return (_local_1.name_string);
            };
            if (((!(_local_1.item_string == null)) && (_local_1.item_string.length > 0)))
            {
                return (_local_1.item_string);
            };
            if (((!(this.name_string == null)) && (this.name_string.length > 0)))
            {
                return (this.name_string);
            };
            return (null);
        }

        public function GetRequieredQuest():String
        {
            return (this.requiresQuest);
        }

        public function IsProducible():Boolean
        {
            return (true);
        }

        public function GetProductionSourceName_string():String
        {
            return (this.GetProductionName_string());
        }

        public function GetCosts_vector():Vector.<dResource>
        {
            return (this.costs_vector);
        }

        public function GetProductionName_string():String
        {
            return (this.GetType());
        }

        public function GetInstantBuildCosts():int
        {
            return (this.instantFinishCost);
        }

        public function GetProductionTime():int
        {
            return (this.duration);
        }


    }
}
