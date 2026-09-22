package ZoneBuff
{
    import Model.Notifier;
    import mx.collections.ArrayCollection;
    import Interface.cGeneralInterface;
    import Utils.HashMapWrapper;
    import Communication.VO.dBuffApplianceVO;
    import BuffSystem.cBuffDefinition;
    import Enums.ZONE_BUFF_TYPE;
    import Effects.EffectList;
    import Communication.VO.dPersistedBuffApplianceVO;
    import EpicWorkyard.EpicWorkyardsManager;
    import __AS3__.vec.Vector;
    import Modifier.ModifierVO;
    import Modifier.Modifiers.Combat.CombatModifier;
    import MilitarySystem.cMilitaryUnitDescription;
    import Communication.VO.dUniqueID;
    import Enums.BUFF_APPLIANCE_MODE;
    import Enums.AVATAR_MESSAGE_TYPE;
    import BuffSystem.cBuff;
    import Utils.StringUtils;
    import Enums.FILTER;
    import __AS3__.vec.*;

    public class ZoneBuffManager extends Notifier 
    {

        public static const PROPERTY_ZONE_BUFF_ADDED:String = "ZoneBuffAdded";
        public static const PROPERTY_ZONE_BUFF_REMOVED:String = "ZoneBuffRemoved";

        private var activeBuffs:ArrayCollection;
        private var gi:cGeneralInterface;
        private var guiDirtyFlag:Boolean = true;
        private var extraBuildingBuffs:HashMapWrapper;

        public function ZoneBuffManager(_arg_1:cGeneralInterface)
        {
            super();
            this.gi = _arg_1;
            this.activeBuffs = new ArrayCollection();
            this.extraBuildingBuffs = new HashMapWrapper();
        }

        public function resetExtraBuildingBuff():void
        {
            this.extraBuildingBuffs.clear();
        }

        public function applyRepeatingEffect():void
        {
            var _local_1:dBuffApplianceVO;
            var _local_2:cBuffDefinition;
            for each (_local_1 in this.activeBuffs)
            {
                _local_2 = cBuffDefinition.GetById(_local_1.buffID);
                if (_local_2 != null)
                {
                    if (_local_2.GetName_string().indexOf(ZONE_BUFF_TYPE.ANIMAL_BUFF_string) >= 0)
                    {
                        global.ui.mCurrentPlayerZone.mSettlerKIManager.clearAnimals(true);
                    };
                    if (_local_2.GetName_string().indexOf(ZONE_BUFF_TYPE.CHANGE_COLOR_SCHEME_string) >= 0)
                    {
                        gGfxResource.applyFilter(_local_1.resourceName_string, this.gi);
                    };
                    EffectList.apply(_local_2.GetRepeatingEffects(), this.gi);
                };
            };
        }

        public function getBuffAppliancesForBuilding(_arg_1:String):ArrayCollection
        {
            var _local_3:dPersistedBuffApplianceVO;
            var _local_5:cBuffDefinition;
            var _local_6:String;
            var _local_7:dPersistedBuffApplianceVO;
            var _local_2:ArrayCollection = new ArrayCollection();
            for each (_local_3 in this.activeBuffs)
            {
                _local_5 = cBuffDefinition.GetById(_local_3.buffID);
                for each (_local_6 in _local_5.GetTargetDescription_string().split(","))
                {
                    if (((_local_6 == "Workyard") || (_local_6 == _arg_1)))
                    {
                        _local_2.addItem(_local_3);
                    };
                };
            };
            if (EpicWorkyardsManager.getInstance().getIsEpicSubBuilding(_arg_1))
            {
                _local_2.addAll(this.getBuffAppliancesForBuilding(EpicWorkyardsManager.getInstance().getMasterBuildingBySubBuilding_string(_arg_1)));
            };
            var _local_4:Vector.<dPersistedBuffApplianceVO> = this.getExtraBuildingBuffs_vector(_arg_1);
            if (_local_4 != null)
            {
                for each (_local_7 in _local_4)
                {
                    _local_2.addItem(_local_7);
                };
            };
            return (_local_2);
        }

        public function getBuffAppliancesForMilitaryUnit_vector(_arg_1:cMilitaryUnitDescription):Vector.<dPersistedBuffApplianceVO>
        {
            var _local_3:dPersistedBuffApplianceVO;
            var _local_4:cBuffDefinition;
            var _local_5:Boolean;
            var _local_6:String;
            var _local_7:ModifierVO;
            var _local_2:Vector.<dPersistedBuffApplianceVO> = new Vector.<dPersistedBuffApplianceVO>();
            for each (_local_3 in this.activeBuffs)
            {
                _local_4 = cBuffDefinition.GetById(_local_3.buffID);
                _local_5 = false;
                for each (_local_6 in _local_4.GetTargetDescription_string().split(","))
                {
                    if (_local_6 == _arg_1.GetType())
                    {
                        _local_2.push(_local_3);
                        _local_5 = true;
                        break;
                    };
                };
                if (((!(_local_5)) && (!(_local_4.GetCombatModifiers() == null))))
                {
                    for each (_local_7 in _local_4.GetCombatModifiers().list)
                    {
                        if (((CombatModifier.combatModifierAppliesToSide(_local_7, _arg_1)) && (CombatModifier.combatModifierTypeAppliesToUnit(_local_7, _arg_1))))
                        {
                            _local_2.push(_local_3);
                            break;
                        };
                    };
                };
            };
            return (_local_2);
        }

        private function updateBuffAppliance(_arg_1:int, _arg_2:int):void
        {
            var _local_3:dPersistedBuffApplianceVO;
            for each (_local_3 in this.activeBuffs)
            {
                if (_local_3.buffID == _arg_1)
                {
                    _local_3.applianceMode = _arg_2;
                    _local_3.startTime = this.gi.GetClientTime();
                };
            };
        }

        private function applyBuffEffect(_arg_1:dBuffApplianceVO):void
        {
            var _local_2:cBuffDefinition = cBuffDefinition.GetById(_arg_1.buffID);
            if (_local_2 != null)
            {
                if (_local_2.GetName_string().indexOf(ZONE_BUFF_TYPE.ANIMAL_BUFF_string) >= 0)
                {
                    global.ui.mCurrentPlayerZone.mSettlerKIManager.clearAnimals(true);
                };
                if (_local_2.GetName_string().indexOf(ZONE_BUFF_TYPE.CHANGE_COLOR_SCHEME_string) >= 0)
                {
                    gGfxResource.applyFilter(_arg_1.resourceName_string, this.gi);
                };
                EffectList.apply(_local_2.GetRepeatingEffects(), this.gi);
            };
        }

        public function addBuff(_arg_1:cBuff, _arg_2:int):void
        {
            var _local_3:dPersistedBuffApplianceVO;
            var _local_4:dPersistedBuffApplianceVO;
            if (!this.isBuffRunning((_arg_1.GetType() + ((_arg_1.GetResourceName_string().length > 0) ? ("_" + _arg_1.GetResourceName_string()) : ""))))
            {
                for each (_local_3 in this.getBuffInExclusivityGroup_vector(_arg_1.GetBuffDefinition().GetExclusivityGroup()))
                {
                    if (_local_3 != null)
                    {
                        this.removeBuff(_local_3.buffID, _local_3.sourceZoneId);
                    };
                };
                _local_4 = new dPersistedBuffApplianceVO();
                _local_4.uniqueId = new dUniqueID();
                _local_4.uniqueId.uniqueID1 = this.gi.mCurrentViewedZoneID;
                _local_4.buffID = _arg_1.GetId();
                _local_4.resourceName_string = _arg_1.GetResourceName_string();
                _local_4.applianceMode = _arg_2;
                _local_4.startTime = this.gi.GetClientTime();
                this.activeBuffs.addItem(_local_4);
                this.applyBuffEffect(_local_4);
                globalFlash.gui.mZoneBuffPanel.Refresh();
                notifyPropertyObserver(PROPERTY_ZONE_BUFF_ADDED, _arg_1.GetBuffDefinition().GetName_string());
            }
            else
            {
                this.updateBuffAppliance(_arg_1.GetId(), _arg_2);
            };
            if (_arg_2 == BUFF_APPLIANCE_MODE.CULTURE_BUILDING)
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.USED_ZONE_BUFF, _arg_1, _arg_1.GetBuffDefinition().isPreventDefaultAvatarMessage());
            };
            this.guiDirtyFlag = true;
        }

        public function getPersistedBuffApplianceVO(_arg_1:String):dPersistedBuffApplianceVO
        {
            var _local_2:dPersistedBuffApplianceVO;
            var _local_3:cBuffDefinition;
            for each (_local_2 in this.activeBuffs)
            {
                _local_3 = cBuffDefinition.GetById(_local_2.buffID);
                if (((_arg_1 == _local_3.GetName_string()) || (_arg_1 == ((_local_3.GetName_string() + "_") + _local_2.resourceName_string))))
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function Compute():void
        {
            var _local_2:dPersistedBuffApplianceVO;
            var _local_3:cBuffDefinition;
            var _local_4:Number;
            var _local_5:int;
            var _local_1:int;
            for each (_local_2 in this.activeBuffs)
            {
                _local_3 = cBuffDefinition.GetById(_local_2.buffID);
                if (_local_3 != null)
                {
                    _local_5 = _local_3.getDuration(_local_2.applianceMode);
                    if (_local_5 >= 0)
                    {
                        _local_4 = (_local_2.startTime + _local_5);
                        if (_local_4 < this.gi.GetClientTime())
                        {
                            this.activeBuffs.removeItemAt(_local_1);
                            this.removeBuffEffect(_local_2);
                            globalFlash.gui.mZoneBuffPanel.Refresh();
                        };
                    };
                };
                _local_1++;
            };
            globalFlash.gui.mInfoBar.SetZoneBuffs(this.activeBuffs.length);
            if (this.guiDirtyFlag)
            {
                globalFlash.gui.mZoneBuffPanel.Refresh();
                this.guiDirtyFlag = false;
            };
        }

        public function getNumberOfExtraBuildingBuffs(_arg_1:String):int
        {
            var _local_2:Vector.<dPersistedBuffApplianceVO> = (this.extraBuildingBuffs.getItem(_arg_1) as Vector.<dPersistedBuffApplianceVO>);
            if (((!(_local_2 == null)) && (_local_2.length > 1)))
            {
                return (_local_2.length);
            };
            return (0);
        }

        public function getBuffInExclusivityGroup_vector(_arg_1:String):Vector.<dPersistedBuffApplianceVO>
        {
            var _local_3:dPersistedBuffApplianceVO;
            var _local_4:cBuffDefinition;
            var _local_2:Vector.<dPersistedBuffApplianceVO> = new Vector.<dPersistedBuffApplianceVO>();
            if (!StringUtils.isEmpty(_arg_1))
            {
                for each (_local_3 in this.activeBuffs)
                {
                    _local_4 = cBuffDefinition.GetById(_local_3.buffID);
                    if (((!(_local_4.GetExclusivityGroup() == null)) && (_local_4.GetExclusivityGroup() == _arg_1)))
                    {
                        _local_2.push(_local_3);
                    };
                };
            };
            return (_local_2);
        }

        public function getActiveCombatModifiers_vector():Vector.<ModifierVO>
        {
            var _local_2:dPersistedBuffApplianceVO;
            var _local_3:cBuffDefinition;
            var _local_1:Vector.<ModifierVO> = new Vector.<ModifierVO>();
            for each (_local_2 in this.activeBuffs)
            {
                _local_3 = cBuffDefinition.GetById(_local_2.buffID);
                if (_local_3.GetCombatModifiers() != null)
                {
                    _local_1 = _local_1.concat(_local_3.GetCombatModifiers().asVector());
                };
            };
            return (_local_1);
        }

        private function removeBuffEffect(_arg_1:dBuffApplianceVO):void
        {
            var _local_2:cBuffDefinition = cBuffDefinition.GetById(_arg_1.buffID);
            if (_local_2 != null)
            {
                if (_local_2.GetName_string().indexOf(ZONE_BUFF_TYPE.ANIMAL_BUFF_string) >= 0)
                {
                    this.gi.mCurrentPlayerZone.mSettlerKIManager.clearAnimals(true);
                };
                if (_local_2.GetName_string().indexOf(ZONE_BUFF_TYPE.CHANGE_COLOR_SCHEME_string) >= 0)
                {
                    gGfxResource.applyFilter(FILTER.toString(FILTER.NONE), this.gi);
                };
                EffectList.apply(_local_2.GetPostEffects(), this.gi);
            };
            notifyPropertyObserver(PROPERTY_ZONE_BUFF_REMOVED, _local_2.GetName_string());
        }

        public function isBuffRunning(_arg_1:String):Boolean
        {
            var _local_3:dPersistedBuffApplianceVO;
            var _local_4:cBuffDefinition;
            var _local_2:Boolean;
            for each (_local_3 in this.activeBuffs)
            {
                _local_4 = cBuffDefinition.GetById(_local_3.buffID);
                if (((_arg_1 == _local_4.GetName_string()) || (_arg_1 == ((_local_4.GetName_string() + "_") + _local_3.resourceName_string))))
                {
                    _local_2 = true;
                };
            };
            return (_local_2);
        }

        public function loadZoneBuffs(_arg_1:ArrayCollection):void
        {
            var _local_3:cBuffDefinition;
            this.activeBuffs = new ArrayCollection();
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                if (_arg_1[_local_2] != null)
                {
                    (_arg_1[_local_2] as dPersistedBuffApplianceVO).dirtyIndicator.clean();
                    this.activeBuffs.addItem(_arg_1[_local_2]);
                    _local_3 = cBuffDefinition.GetById((_arg_1[_local_2] as dPersistedBuffApplianceVO).buffID);
                    notifyPropertyObserver(PROPERTY_ZONE_BUFF_ADDED, _local_3.GetName_string());
                };
                _local_2++;
            };
            this.guiDirtyFlag = true;
        }

        public function getExtraBuildingBuffs_vector(_arg_1:String):Vector.<dPersistedBuffApplianceVO>
        {
            var _local_2:Vector.<dPersistedBuffApplianceVO> = (this.extraBuildingBuffs.getItem(_arg_1) as Vector.<dPersistedBuffApplianceVO>);
            if (((!(_local_2 == null)) && (_local_2.length > 1)))
            {
                return (_local_2.slice(1));
            };
            return (new Vector.<dPersistedBuffApplianceVO>());
        }

        public function removeExtraBuildingBuff(_arg_1:cBuffDefinition):void
        {
            var _local_2:String;
            var _local_3:Vector.<dPersistedBuffApplianceVO>;
            var _local_4:int;
            for each (_local_2 in _arg_1.GetTargetDescription_string().split(","))
            {
                _local_3 = (this.extraBuildingBuffs.getItem(_local_2) as Vector.<dPersistedBuffApplianceVO>);
                _local_4 = 0;
                while (_local_4 < _local_3.length)
                {
                    if (_local_3[_local_4].buffID == _arg_1.GetId())
                    {
                        _local_3.splice(_local_4, 1);
                        return;
                    };
                    _local_4++;
                };
            };
        }

        public function addExtraBuildingBuff(_arg_1:cBuff):void
        {
            var _local_2:String;
            var _local_3:dPersistedBuffApplianceVO;
            for each (_local_2 in _arg_1.GetBuffDefinition().GetTargetDescription_string().split(","))
            {
                _local_3 = new dPersistedBuffApplianceVO();
                _local_3.buffID = _arg_1.GetId();
                _local_3.resourceName_string = _arg_1.GetResourceName_string();
                _local_3.startTime = this.gi.GetClientTime();
                _local_3.applianceMode = BUFF_APPLIANCE_MODE.EXTRA_BUILDING_BUFF;
                if (this.extraBuildingBuffs.getItem(_local_2) == null)
                {
                    this.extraBuildingBuffs.putItem(_local_2, new Vector.<dPersistedBuffApplianceVO>());
                };
                this.extraBuildingBuffs.getItem(_local_2).push(_local_3);
            };
        }

        public function getBuffNameStartsWith_vector(_arg_1:String):Vector.<dPersistedBuffApplianceVO>
        {
            var _local_3:dPersistedBuffApplianceVO;
            var _local_4:cBuffDefinition;
            var _local_2:Vector.<dPersistedBuffApplianceVO> = new Vector.<dPersistedBuffApplianceVO>();
            if (!StringUtils.isEmpty(_arg_1))
            {
                for each (_local_3 in this.activeBuffs)
                {
                    _local_4 = cBuffDefinition.GetById(_local_3.buffID);
                    if (StringUtils.startsWith(_local_4.GetName_string(), _arg_1))
                    {
                        _local_2.push(_local_3);
                    };
                };
            };
            return (_local_2);
        }

        public function isBuffRunningStartsWith(_arg_1:String):Boolean
        {
            var _local_3:dPersistedBuffApplianceVO;
            var _local_4:cBuffDefinition;
            var _local_2:Boolean;
            for each (_local_3 in this.activeBuffs)
            {
                _local_4 = cBuffDefinition.GetById(_local_3.buffID);
                if (((StringUtils.startsWith(_local_4.GetName_string(), _arg_1)) || (_arg_1 == ((_local_4.GetName_string() + "_") + _local_3.resourceName_string))))
                {
                    _local_2 = true;
                };
            };
            return (_local_2);
        }

        public function getZoneBuffsForPersistence():ArrayCollection
        {
            return (this.activeBuffs);
        }

        public function removeBuff(_arg_1:int, _arg_2:int):void
        {
            var _local_4:dPersistedBuffApplianceVO;
            var _local_5:dPersistedBuffApplianceVO;
            var _local_3:Vector.<dPersistedBuffApplianceVO> = new Vector.<dPersistedBuffApplianceVO>();
            for each (_local_4 in this.activeBuffs)
            {
                if (((_local_4.buffID == _arg_1) && (_local_4.sourceZoneId == _arg_2)))
                {
                    _local_3.push(_local_4);
                };
            };
            for each (_local_5 in _local_3)
            {
                this.activeBuffs.removeItemAt(this.activeBuffs.getItemIndex(_local_5));
                this.removeBuffEffect(_local_5);
            };
            globalFlash.gui.mZoneBuffPanel.Refresh();
            this.guiDirtyFlag = true;
        }


    }
}
