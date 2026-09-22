package ServerState
{
    import __AS3__.vec.Vector;
    import Utils.HashMapWrapper;
    import nLib.cXML;
    import EpicWorkyard.EpicWorkyardsManager;
    import nLib.gMisc;
    import Enums.RESOURCE_TYPE;
    import nLib.cLog;
    import __AS3__.vec.*;

    public class gEconomics 
    {

        public static const mResourceDefaultDefinition_vector:Vector.<dResourceDefaultDefinition> = new Vector.<dResourceDefaultDefinition>();
        public static const mResourceCreationDefinition_vector:Vector.<dResourceCreationDefinition> = new Vector.<dResourceCreationDefinition>();
        public static const mAllResourceCreationDefinition_vector:Vector.<dResourceCreationDefinition> = new Vector.<dResourceCreationDefinition>();
        public static var mMap_EventResourceDefaultDefinition:Object = new Object();
        public static const mResourceCreationDefinition_map:HashMapWrapper = new HashMapWrapper();
        public static const resourceDefaultCreationIcon:HashMapWrapper = new HashMapWrapper();
        private static var mGameSettingDefinitions:cXML = null;


        public static function IsEconomicsInitialized():Boolean
        {
            return (mResourceCreationDefinition_vector.length > 0);
        }

        private static function isBuildingAllowedInUIVector(_arg_1:String):Boolean
        {
            if (EpicWorkyardsManager.getInstance().getIsEpicSubBuilding(_arg_1))
            {
                return (false);
            };
            return (true);
        }

        public static function setGameSettingsDefinitions(_arg_1:cXML):void
        {
            mGameSettingDefinitions = _arg_1;
        }

        public static function GetResourcesFromString(_arg_1:String):Vector.<dResource>
        {
            var _local_3:Array;
            var _local_4:String;
            var _local_5:dResource;
            var _local_6:Array;
            var _local_2:Vector.<dResource> = new Vector.<dResource>();
            if (_arg_1 != "")
            {
                _local_3 = _arg_1.split(",");
                for each (_local_4 in _local_3)
                {
                    _local_4 = gMisc.Trim_string(_local_4);
                    _local_5 = new dResource();
                    _local_6 = _local_4.split(" ");
                    _local_5.name_string = (_local_6[0] as String);
                    _local_5.amount = gMisc.ParseInt((_local_6[1] as String));
                    _local_2.push(_local_5);
                };
            };
            return (_local_2);
        }

        public static function HasResourceTwoInputs(_arg_1:String):Boolean
        {
            var _local_2:dResourceCreationDefinition;
            for each (_local_2 in mAllResourceCreationDefinition_vector)
            {
                if (_local_2.defaultSetting.resourceName_string == _arg_1)
                {
                    if (_local_2.amountRemoved >= 0)
                    {
                        if (_local_2.externalResource_string == "")
                        {
                            if (_local_2.necessaryResources_vector.length > 1)
                            {
                                return (true);
                            };
                        };
                    };
                };
            };
            return (false);
        }

        public static function init():void
        {
            var _local_3:cXML;
            var _local_4:dResourceDefaultDefinition;
            var _local_5:String;
            var _local_6:int;
            var _local_7:Vector.<cXML>;
            var _local_8:cXML;
            var _local_9:Boolean;
            var _local_10:dResourceDefaultDefinition;
            var _local_11:String;
            var _local_12:String;
            var _local_13:dExpandMaxLimit;
            var _local_14:int;
            var _local_15:dResourceCreationDefinition;
            var _local_16:String;
            if (mGameSettingDefinitions == null)
            {
                return;
            };
            var _local_1:cXML = mGameSettingDefinitions;
            mGameSettingDefinitions = null;
            global.returnRate = int((_local_1.GetAttributeFloatingPoint("returnRate") * 100));
            var _local_2:Vector.<cXML> = _local_1.CreateChildrenArray();
            for each (_local_3 in _local_2)
            {
                _local_4 = new dResourceDefaultDefinition();
                _local_5 = _local_3.GetAttributeString_string("name");
                _local_6 = _local_3.GetAttributeInt("id");
                gMisc.Assert((global.resourceDefinitions_vector.length == _local_6), (((("Resource definition '" + _local_5) + "' has wrong id! It should be ") + global.resourceDefinitions_vector.length) + "!"));
                global.resourceDefinitions_vector.push(_local_5);
                _local_4.resourceName_string = _local_5;
                _local_4.visibleInEconomy = _local_3.GetAttributeBool("visibleInEconomy", true);
                if (!global.gfxSettingsGameObjectsXML.isEmpty())
                {
                    _local_11 = (resourceDefaultCreationIcon.getItem(_local_5) as String);
                    if (_local_11 != null)
                    {
                        _local_4.group_string = _local_11.split("|")[0];
                        _local_4.category_string = _local_11.split("|")[1];
                    };
                };
                _local_4.maxLimit = _local_3.GetAttributeInt("MaxLimit", gMisc.GetMaxIntValue());
                _local_4.requiredEventName_string = _local_3.GetAttributeString_string("requiresEvent");
                if (!gParse.parseIsAvailableForLocation(_local_3, global.realmLanguage))
                {
                    _local_4.requiredEventName_string = "unavailable";
                };
                _local_4.expandMaxLimitList_vector = new Vector.<dExpandMaxLimit>();
                _local_4.tradable = _local_3.GetAttributeBool("tradable", true);
                _local_4.tradable = ((_local_4.tradable) && (gParse.parseIsAvailableForLocation(_local_3, global.realmLanguage)));
                _local_7 = _local_3.CreateChildrenArray();
                for each (_local_8 in _local_7)
                {
                    _local_12 = _local_8.GetName_string();
                    if (_local_12 == "ExpandMaxLimit")
                    {
                        _local_13 = new dExpandMaxLimit();
                        _local_13.name_string = _local_8.GetAttributeString_string("ByBuilding");
                        _local_13.amount = _local_8.GetAttributeFloatingPoint("Amount");
                        _local_4.expandMaxLimitList_vector.push(_local_13);
                    }
                    else
                    {
                        if (_local_12 == "Creation")
                        {
                            _local_14 = _local_8.GetAttributeInt("CreationId", -1);
                            _local_15 = new dResourceCreationDefinition();
                            _local_15.id = _local_14;
                            _local_15.defaultSetting = _local_4;
                            _local_16 = _local_8.GetAttributeString_string("type");
                            if (_local_16 == "CreatedAlways")
                            {
                                _local_15.typeEnumResourceType = RESOURCE_TYPE.CREATED_ALWAYS;
                                _local_15.buildingName_string = null;
                                _local_15.amountRemoved = _local_8.GetAttributeInt("CreationTime");
                                if (_local_15.amountRemoved == 0)
                                {
                                    _local_15.amountRemoved = 1;
                                };
                                mResourceCreationDefinition_vector.push(_local_15);
                            }
                            else
                            {
                                if (_local_16 == "CreatedByBuilding")
                                {
                                    _local_15.typeEnumResourceType = RESOURCE_TYPE.CREATED_BY_BUILDING;
                                    _local_15.buildingName_string = _local_8.GetAttributeString_string("Building");
                                    _local_15.externalResource_string = _local_8.GetAttributeString_string("ExternalResource");
                                    _local_15.externalResourceDeposit_string = ("Deposit" + _local_15.externalResource_string);
                                    _local_15.amountRemoved = _local_8.GetAttributeInt("AmountRemoved", 1);
                                    _local_15.workTime = _local_8.GetAttributeInt("WorkTime");
                                    _local_15.necessaryResources_vector = GetResourcesFromString(_local_8.GetAttributeString_string("Resource"));
                                    if (isBuildingAllowedInUIVector(_local_15.buildingName_string))
                                    {
                                        _local_15.necessaryResourcesUI_vector = _local_15.necessaryResources_vector;
                                    };
                                    mResourceCreationDefinition_map.putItem(_local_15.buildingName_string, _local_15);
                                };
                            };
                            mAllResourceCreationDefinition_vector.push(_local_15);
                            _local_15.ignoreMaxWarehouseLimit = _local_8.GetAttributeBool("ignoreMaxWarehouseLimit");
                        };
                    };
                };
                _local_9 = false;
                for each (_local_10 in mResourceDefaultDefinition_vector)
                {
                    if (_local_10.resourceName_string == _local_4.resourceName_string)
                    {
                        _local_9 = true;
                        break;
                    };
                };
                if (_local_9)
                {
                    cLog.showErrorMessage(("Error: Double entry in XML ResourceDefinition -> Resourcename " + _local_4.resourceName_string));
                }
                else
                {
                    if (_local_4.requiredEventName_string != "")
                    {
                        mMap_EventResourceDefaultDefinition[_local_4.resourceName_string] = _local_4;
                    };
                    mResourceDefaultDefinition_vector.push(_local_4);
                };
            };
            mResourceCreationDefinition_vector.sort(compareResourceCreationDefinitions);
            if (mResourceCreationDefinition_vector.length > 1)
            {
                gMisc.Assert(((mResourceCreationDefinition_vector.length - 1) == mResourceCreationDefinition_vector[(mResourceCreationDefinition_vector.length - 1)].id), "Error: ResourceCreationDefinitions don't have incrementing IDs!");
            };
            mGameSettingDefinitions = null;
            resourceDefaultCreationIcon.clear();
        }

        private static function compareResourceCreationDefinitions(_arg_1:dResourceCreationDefinition, _arg_2:dResourceCreationDefinition):Number
        {
            return (_arg_1.id - _arg_2.id);
        }

        public static function GetResourcesDefaultDefinition_vector(_arg_1:String, _arg_2:Boolean=false):Array
        {
            var _local_4:dResourceDefaultDefinition;
            var _local_3:Array = [];
            for each (_local_4 in mResourceDefaultDefinition_vector)
            {
                if (((!(_arg_2)) || (_local_4.visibleInEconomy)))
                {
                    if (_local_4.category_string == _arg_1)
                    {
                        _local_3.push(_local_4);
                    }
                    else
                    {
                        if (_arg_1 == "ALL")
                        {
                            _local_3.push(_local_4);
                        };
                    };
                };
            };
            return (_local_3);
        }

        public static function GetResourcesCreationDefinitionForBuilding(_arg_1:String):dResourceCreationDefinition
        {
            if (mResourceCreationDefinition_map.hasKey(_arg_1))
            {
                return (mResourceCreationDefinition_map.getItem(_arg_1) as dResourceCreationDefinition);
            };
            return (null);
        }

        public static function GetResourcesDefaultDefinition(_arg_1:String):dResourceDefaultDefinition
        {
            var _local_2:dResourceDefaultDefinition;
            for each (_local_2 in mResourceDefaultDefinition_vector)
            {
                if (_local_2.resourceName_string == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public static function GetResourcesCreationDefinitionForResource(_arg_1:String):dResourceCreationDefinition
        {
            var _local_2:dResourceCreationDefinition;
            for each (_local_2 in mAllResourceCreationDefinition_vector)
            {
                if (_local_2.defaultSetting.resourceName_string == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public static function GetResourcesCreationDefinitionsForResource_vector(_arg_1:String):Vector.<dResourceCreationDefinition>
        {
            var _local_3:dResourceCreationDefinition;
            var _local_2:Vector.<dResourceCreationDefinition> = new Vector.<dResourceCreationDefinition>();
            for each (_local_3 in mAllResourceCreationDefinition_vector)
            {
                if (_local_3.defaultSetting.resourceName_string == _arg_1)
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }


    }
}
