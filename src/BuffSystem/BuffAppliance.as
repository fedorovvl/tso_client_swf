package BuffSystem
{
    import Communication.VO.dUniqueID;
    import GO.cBuilding;
    import Communication.VO.dBuffApplianceVO;
    import Enums.BUFF_APPLIANCE_MODE;
    import Enums.FILTER;
    import Collections.CollectionsManager;
    import Collections.CollectionsConsts;
    import Effects.EffectList;
    import Interface.cGameInterface;
    import Interface.cGeneralInterface;
    import Enums.BUFF_TYPE;
    import Enums.DIRTY_INDICATOR;

    public class BuffAppliance 
    {

        private var buffDefinition:cBuffDefinition;
        private var uniqueId:dUniqueID;
        private var startTime:Number;
        private var resourceName_string:String;
        private var nextTickTime:Number;
        private var sourceZoneId:int;
        public var mDirtyIndicator:int = 0;
        private var applianceMode:int = 0;
        private var building:cBuilding;

        public function BuffAppliance(_arg_1:cBuilding, _arg_2:dUniqueID, _arg_3:cBuffDefinition, _arg_4:int, _arg_5:String, _arg_6:int, _arg_7:Number)
        {
            super();
            this.uniqueId = _arg_2;
            this.buffDefinition = _arg_3;
            this.applianceMode = _arg_4;
            this.resourceName_string = _arg_5;
            this.sourceZoneId = _arg_6;
            this.nextTickTime = _arg_7;
            this.building = _arg_1;
        }

        public static function CreateBuffApplianceFromVO(_arg_1:cBuilding, _arg_2:dBuffApplianceVO):BuffAppliance
        {
            var _local_3:BuffAppliance = new BuffAppliance(_arg_1, _arg_2.uniqueId, cBuffDefinition.GetById(_arg_2.buffID), _arg_2.applianceMode, _arg_2.resourceName_string, _arg_2.sourceZoneId, _arg_2.nextTickTime);
            _local_3.startTime = _arg_2.startTime;
            _local_3.applianceMode = _arg_2.applianceMode;
            return (_local_3);
        }


        public function GetResourceName_string():String
        {
            return (this.resourceName_string);
        }

        public function GetApplicanceMode():int
        {
            return (this.applianceMode);
        }

        public function GetBuffDefinition():cBuffDefinition
        {
            return (this.buffDefinition);
        }

        public function CreateBuffApplianceVO():dBuffApplianceVO
        {
            var _local_1:dBuffApplianceVO = new dBuffApplianceVO();
            _local_1.buffID = this.buffDefinition.GetId();
            _local_1.startTime = this.startTime;
            _local_1.applianceMode = this.applianceMode;
            _local_1.resourceName_string = this.resourceName_string;
            _local_1.sourceZoneId = this.GetSourceZoneId();
            _local_1.nextTickTime = this.GetNextTickTime();
            return (_local_1);
        }

        public function GetUniqueId():dUniqueID
        {
            return (this.uniqueId);
        }

        public function toString():String
        {
            return ((((((((((((((((((("<BuffAppliance " + "id='") + this.buffDefinition.GetId()) + "' ") + "buffname='") + this.buffDefinition.GetName_string()) + "' ") + "startTime='") + this.startTime) + "' ") + "applianceMode='") + BUFF_APPLIANCE_MODE.toString(this.applianceMode)) + "' ") + "sourceZoneId='") + this.GetSourceZoneId()) + "' ") + "nextTickTime='") + this.GetNextTickTime()) + "' ") + " />\n");
        }

        public function BuffRemoved(_arg_1:cGeneralInterface):void
        {
            if (this.buffDefinition.GetName_string().indexOf("ChangeColorScheme") > -1)
            {
                gGfxResource.applyFilter(FILTER.toString(FILTER.NONE), _arg_1);
            }
            else
            {
                if (CollectionsManager.getInstance().getBuffIsCollectibleLootBuff(this.buffDefinition.GetName_string()))
                {
                    _arg_1.removePickups(CollectionsConsts.COLLECTIBLE_BUILDING_EVENT);
                };
            };
            if (this.buffDefinition.GetPostEffects() != null)
            {
                EffectList.applyWithGrid(this.buffDefinition.GetPostEffects(), (_arg_1 as cGameInterface), this.building.GetGrid());
            };
            _arg_1.channels.BUFF.send(cBuff.BUFF_EXPIRED_string, this);
        }

        public function IsActive(_arg_1:Number):Boolean
        {
            if ((((_arg_1 - this.startTime) >= this.buffDefinition.getDuration(this.applianceMode)) && (!(this.buffDefinition.GetBuffType() == BUFF_TYPE.PERMANENT))))
            {
                return (false);
            };
            return (true);
        }

        public function GetSourceZoneId():int
        {
            return (this.sourceZoneId);
        }

        public function GetStartTime():Number
        {
            return (this.startTime);
        }

        public function GetNextTickTime():Number
        {
            return (this.nextTickTime);
        }

        public function SetStartTime(_arg_1:Number):void
        {
            this.startTime = _arg_1;
        }

        public function SetNextTickTime(_arg_1:Number):void
        {
            this.nextTickTime = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }


    }
}
