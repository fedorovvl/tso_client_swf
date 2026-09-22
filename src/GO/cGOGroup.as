package GO
{
    import flash.events.IEventDispatcher;
    import __AS3__.vec.Vector;
    import nLib.cXML;
    import flash.utils.Dictionary;
    import flash.events.EventDispatcher;
    import nLib.cSpriteLib;
    import nLib.cSpriteLibContainer;
    import nLib.cLog;
    import nLib.gMisc;
    import flash.events.Event;
    import ServerState.dResource;
    import mx.events.PropertyChangeEvent;
    import Enums.FILTER;
    import __AS3__.vec.*;

    public class cGOGroup implements IEventDispatcher 
    {

        public static const STREAM_IDLE_DELAY:int = 5;

        private const FLAG_EFFECT_SET_NAME:String = "gosetFlagName";
        private const SHADOW_FILENAME_ATTRIBUTE_string:String = "shadowfilename";
        private const WORKANIM_FILENAME_ATTRIBUTE_string:String = "workanimfilename";
        private const SMOKE_EFFECT_SET_NAME:String = "gosetSmokeEffectSetName";
        private const FILENAME_ATTRIBUTE_string:String = "filename";
        private const SHOW_SMOKE_EVEN_IF_NOT_WORKING:String = "showSmokeEvenIfNotWorking";
        private const CONSTRUCTION_FILENAME_ATTRIBUTE_string:String = "constructionfilename";
        private const DESTRUCTION_FILENAME_ATTRIBUTE_string:String = "destructionfilename";

        public var mCurrentStreams:int = 0;
        public var mDestructionDuration_vector:Vector.<Number> = null;
        private var _887895727mGOList_vector:Vector.<cGOSpriteLibContainer> = null;
        public var mConstructionDuration_vector:Vector.<Number> = null;
        public var mGOWorkAnimList_vector:Vector.<cGOSpriteLibContainer> = null;
        public var mConstructionFileName_vector:Vector.<String> = null;
        public var mGameSettingsObjectDefinitions:cXML = null;
        public var mGOWorkAnimListDictionary:Dictionary = null;
        public var mDestructionFileName_vector:Vector.<String> = null;
        public var defaultZoom:int = 1000;
        public var mStreamedDelay:int = 5;
        private var _bindingEventDispatcher:EventDispatcher;
        public var mLastCurrentStreams:int = -1;
        public var mGOListDictionary:Dictionary = null;
        public var mStreamIsIdle:Boolean = false;
        public var mGfxListName_string:String = null;

        public function cGOGroup()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function GetNameFromNr_string(_arg_1:Vector.<cGOSpriteLibContainer>, _arg_2:int):String
        {
            var _local_3:cGOSpriteLibContainer = _arg_1[_arg_2];
            return (_local_3.mGfxResourceListName_string);
        }

        public function SetGameSettingDefinitions(_arg_1:cXML):void
        {
            this.mGameSettingsObjectDefinitions = _arg_1;
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function IsBuffable(_arg_1:String):Boolean
        {
            var _local_2:int = this.GetNrFromName(_arg_1);
            var _local_3:cGOSpriteLibContainer = this.mGOList_vector[_local_2];
            return (_local_3.mBuffable);
        }

        public function SetRescaleDirtyFlag():void
        {
            var _local_1:cGOSpriteLibContainer;
            for each (_local_1 in this.mGOList_vector)
            {
                if (_local_1 != null)
                {
                    _local_1.SetDirty();
                };
            };
            for each (_local_1 in this.mGOWorkAnimList_vector)
            {
                if (_local_1 != null)
                {
                    _local_1.SetDirty();
                };
            };
        }

        public function GetSpriteLibFromAnimList(_arg_1:String):cSpriteLib
        {
            var _local_2:cGOSpriteLibContainer = this.mGOWorkAnimListDictionary[_arg_1];
            if (_local_2 == null)
            {
                return (null);
            };
            return (_local_2.CreateObject());
        }

        public function GetSpriteLibFromNr(_arg_1:Vector.<cGOSpriteLibContainer>, _arg_2:int):cSpriteLib
        {
            if (_arg_1 == null)
            {
                return (null);
            };
            if (_arg_1.length == 0)
            {
                return (null);
            };
            var _local_3:cSpriteLibContainer = _arg_1[_arg_2];
            if (_local_3 != null)
            {
                return (_local_3.CreateObject());
            };
            return (null);
        }

        public function GetWatchAreaId(_arg_1:String):int
        {
            var _local_2:int = this.GetNrFromName(_arg_1);
            var _local_3:cGOSpriteLibContainer = this.mGOList_vector[_local_2];
            return (_local_3.mWatchAreaId);
        }

        public function GetGoSpriteLibContainerFromNr(_arg_1:int):cGOSpriteLibContainer
        {
            return (this.mGOList_vector[_arg_1] as cGOSpriteLibContainer);
        }

        [Bindable(event="propertyChange")]
        public function get mGOList_vector():*
        {
            return (this._887895727mGOList_vector);
        }

        public function IsWarehouse(_arg_1:String):Boolean
        {
            var _local_2:int = this.GetNrFromName(_arg_1);
            var _local_3:cGOSpriteLibContainer = this.mGOList_vector[_local_2];
            return (_local_3.mIsWarehouse);
        }

        public function IsSpriteInGroup(_arg_1:String):Boolean
        {
            return (!(this.mGOListDictionary[_arg_1] == null));
        }

        private function IsSpriteListLoadedLocal(_arg_1:Vector.<cGOSpriteLibContainer>):Boolean
        {
            var _local_2:cSpriteLibContainer;
            if (_arg_1 == null)
            {
                return (true);
            };
            for each (_local_2 in _arg_1)
            {
                if (_local_2 != null)
                {
                    if (!_local_2.mLoadingFinished)
                    {
                        return (false);
                    };
                };
            };
            return (true);
        }

        public function GetNrFromName(_arg_1:String):int
        {
            var _local_2:cGOSpriteLibContainer = this.mGOListDictionary[_arg_1];
            if (_local_2 != null)
            {
                return (_local_2.mGfxResourceListNr);
            };
            _local_2 = this.mGOListDictionary["NotFound"];
            if (_local_2 != null)
            {
                return (_local_2.mGfxResourceListNr);
            };
            if (_arg_1 == null)
            {
                cLog.warning("GetNrFromName: unknown element!");
            };
            gMisc.Assert(false, ("Not a SpriteLibElement: " + _arg_1));
            return (-1);
        }

        public function GetHitPoints(_arg_1:String):int
        {
            var _local_2:int = this.GetNrFromName(_arg_1);
            var _local_3:cGOSpriteLibContainer = this.mGOList_vector[_local_2];
            return (_local_3.mHitPoints);
        }

        public function GetMaxUnits(_arg_1:String):int
        {
            var _local_2:int = this.GetNrFromName(_arg_1);
            var _local_3:cGOSpriteLibContainer = this.mGOList_vector[_local_2];
            return (_local_3.mMaxUnits);
        }

        public function IsMovable(_arg_1:String):Boolean
        {
            var _local_2:int = this.GetNrFromName(_arg_1);
            var _local_3:cGOSpriteLibContainer = this.mGOList_vector[_local_2];
            return (_local_3.mMovable);
        }

        public function CreateContainer(_arg_1:String, _arg_2:Function, _arg_3:Boolean, _arg_4:Boolean):void
        {
            var _local_7:cXML;
            var _local_8:cGOSpriteLibContainer;
            var _local_9:int;
            var _local_10:int;
            var _local_11:String;
            var _local_12:String;
            var _local_13:Vector.<cXML>;
            var _local_14:Dictionary;
            var _local_15:cXML;
            var _local_16:String;
            var _local_17:cGOSpriteLibContainer;
            var _local_18:cXML;
            var _local_19:String;
            var _local_20:Vector.<cXML>;
            var _local_21:cXML;
            var _local_22:String;
            var _local_23:String;
            var _local_24:String;
            var _local_5:Boolean = ((this.mGfxListName_string == "Buildings") ? true : false);
            this.mGOList_vector = new Vector.<cGOSpriteLibContainer>();
            this.mGOListDictionary = new Dictionary();
            this.mGOWorkAnimList_vector = new Vector.<cGOSpriteLibContainer>();
            this.mGOWorkAnimListDictionary = new Dictionary();
            this.mConstructionFileName_vector = new Vector.<String>();
            this.mDestructionFileName_vector = new Vector.<String>();
            this.mConstructionDuration_vector = new Vector.<Number>();
            this.mDestructionDuration_vector = new Vector.<Number>();
            var _local_6:Vector.<cXML> = global.gfxSettingsGameObjectsXML.MoveToSubNode(this.mGfxListName_string).CreateChildrenArray();
            for each (_local_7 in _local_6)
            {
                _local_9 = -1;
                if (true == _local_5)
                {
                    _local_9 = _local_7.GetAttributeInt("id");
                    globalFlash.gui.RegisterBuildingType(_local_7.GetAttributeString_string("name"), _local_7.GetAttributeString_string("ui"), _local_7.GetAttributeString_string("uicontent"));
                };
                _local_10 = _local_7.GetAttributeInt("nofUpgrades");
                _local_11 = _local_7.GetAttributeString_string(this.CONSTRUCTION_FILENAME_ATTRIBUTE_string);
                if (_local_11.length > 0)
                {
                    this.mConstructionFileName_vector.push(_local_11);
                }
                else
                {
                    this.mConstructionFileName_vector.push(null);
                };
                _local_12 = _local_7.GetAttributeString_string(this.DESTRUCTION_FILENAME_ATTRIBUTE_string);
                if (_local_12.length > 0)
                {
                    this.mDestructionFileName_vector.push(_local_12);
                }
                else
                {
                    this.mDestructionFileName_vector.push(null);
                };
                this.AutoAddSpriteLibContainerToList(this.mGOList_vector, this.mGOListDictionary, this.FILENAME_ATTRIBUTE_string, _arg_1, _local_7, _arg_2, _arg_3, _arg_4, _local_10, _local_9);
                this.AutoAddSpriteLibContainerToList(this.mGOWorkAnimList_vector, this.mGOWorkAnimListDictionary, this.WORKANIM_FILENAME_ATTRIBUTE_string, _arg_1, _local_7, _arg_2, _arg_3, _arg_4, 0, _local_9);
            };
            for each (_local_8 in this.mGOList_vector)
            {
                if (_local_8 != null)
                {
                    _local_8.ActivateDispatcherEvent();
                };
            };
            for each (_local_8 in this.mGOWorkAnimList_vector)
            {
                if (_local_8 != null)
                {
                    _local_8.ActivateDispatcherEvent();
                };
            };
            if (this.mGameSettingsObjectDefinitions != null)
            {
                _local_13 = this.mGameSettingsObjectDefinitions.CreateChildrenArray();
                _local_14 = new Dictionary();
                for each (_local_15 in _local_13)
                {
                    _local_16 = _local_15.GetAttributeString_string("name");
                    _local_17 = this.mGOListDictionary[_local_16];
                    if (_local_16 == "")
                    {
                        cLog.showErrorMessage(((("Error in " + global.gameSettingsFilename) + "! Attribute 'name' could no be parsed!.") + _local_15.toString()));
                    }
                    else
                    {
                        if (_local_17 == null)
                        {
                            cLog.showErrorMessage(((((("Error in " + global.gameSettingsFilename) + "! The Object '") + _local_16) + "' is not in gfx_settings.xml!\nXML: ") + _local_15.toString()));
                        }
                        else
                        {
                            if (_local_15.GetName_string() == "Building")
                            {
                                if ((_local_16 in _local_14)) continue;
                                _local_14[_local_16] = 1;
                            };
                            _local_17.parseXML(_local_15);
                        };
                    };
                };
                this.mGameSettingsObjectDefinitions = null;
            };
            if (_local_5)
            {
                _local_18 = global.gfxSettingsGameObjectsXML.MoveToSubNode("AnimationsOnMap");
                _local_19 = _local_18.GetAttributeString_string("defaultBattleAnimName");
                _local_20 = _local_18.CreateChildrenArray();
                for each (_local_8 in this.mGOList_vector)
                {
                    if (_local_8 != null)
                    {
                        if (_local_19.length > 0)
                        {
                            _local_8.mBattleAnimation_string = _local_19;
                        };
                    };
                };
                for each (_local_21 in _local_20)
                {
                    _local_22 = _local_21.GetAttributeString_string("battleAnimName");
                    _local_23 = _local_21.GetAttributeString_string("depositAnimName");
                    _local_24 = _local_21.GetAttributeString_string("usedBy");
                    for each (_local_8 in this.mGOList_vector)
                    {
                        if (_local_8 != null)
                        {
                            if (_local_24 == _local_8.mGfxResourceListName_string)
                            {
                                if (_local_22.length > 0)
                                {
                                    _local_8.mBattleAnimation_string = _local_22;
                                };
                                if (_local_23.length > 0)
                                {
                                    _local_8.mDepositAnimName_string = _local_23;
                                };
                                break;
                            };
                        };
                    };
                };
            };
        }

        public function GetSpriteLibContainer(_arg_1:String):cGOSpriteLibContainer
        {
            var _local_2:int = this.GetNrFromName(_arg_1);
            return (this.mGOList_vector[_local_2]);
        }

        public function SetGfxXML(_arg_1:String):void
        {
            this.mGfxListName_string = _arg_1;
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function GetBlockingListFromName(_arg_1:String):Vector.<cBlockingData>
        {
            var _local_2:int = this.GetNrFromName(_arg_1);
            var _local_3:cGOSpriteLibContainer = this.mGOList_vector[_local_2];
            return (_local_3.mBlocking_vector);
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function IsSpriteListLoaded():Boolean
        {
            return ((this.IsSpriteListLoadedLocal(this.mGOList_vector)) && (this.IsSpriteListLoadedLocal(this.mGOWorkAnimList_vector)));
        }

        public function GetCostListFromName_vector(_arg_1:String):Vector.<dResource>
        {
            var _local_2:int = this.GetNrFromName(_arg_1);
            var _local_3:cGOSpriteLibContainer = this.mGOList_vector[_local_2];
            return (_local_3.mCostList_vector);
        }

        public function GetSpriteLibFromNameGOList(_arg_1:String):cSpriteLib
        {
            var _local_2:cGOSpriteLibContainer = this.mGOListDictionary[_arg_1];
            if (_local_2 == null)
            {
                gMisc.Assert(false, (("" + _arg_1) + " is no SpriteLibElement"));
            };
            return (_local_2.CreateObject());
        }

        public function IsNrInGOList(_arg_1:int):Boolean
        {
            if (this.mGOList_vector == null)
            {
                return (false);
            };
            if (((_arg_1 < 0) || (_arg_1 >= this.mGOList_vector.length)))
            {
                return (false);
            };
            return (true);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function set mGOList_vector(_arg_1:*):void
        {
            var _local_2:Object = this._887895727mGOList_vector;
            if (_local_2 !== _arg_1)
            {
                this._887895727mGOList_vector = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mGOList_vector", _local_2, _arg_1));
            };
        }

        public function GetSpriteLibFromName(_arg_1:String):cSpriteLib
        {
            var _local_2:cGOSpriteLibContainer = this.mGOListDictionary[_arg_1];
            if (_local_2 != null)
            {
                return (_local_2.CreateObject());
            };
            _local_2 = this.mGOListDictionary["NotFound"];
            if (_local_2 != null)
            {
                return (_local_2.CreateObject());
            };
            return (null);
        }

        public function GetNameFromNrGOList_string(_arg_1:int):String
        {
            var _local_2:cGOSpriteLibContainer = (this.mGOList_vector[_arg_1] as cGOSpriteLibContainer);
            return (_local_2.mGfxResourceListName_string);
        }

        public function IsReplaceable(_arg_1:String):Boolean
        {
            var _local_2:int = this.GetNrFromName(_arg_1);
            var _local_3:cGOSpriteLibContainer = this.mGOList_vector[_local_2];
            return (_local_3.mReplaceable);
        }

        public function ignoreOnSectorClaim(_arg_1:String):Boolean
        {
            var _local_2:int = this.GetNrFromName(_arg_1);
            var _local_3:cGOSpriteLibContainer = this.mGOList_vector[_local_2];
            return (_local_3.mIgnoreOnSectorClaim);
        }

        private function CalculateFilterMask(_arg_1:String):int
        {
            var _local_3:String;
            if (_arg_1 == "")
            {
                return (0);
            };
            if (_arg_1.toLowerCase() == "all")
            {
                return (gMisc.GetMaxIntValue());
            };
            _arg_1 = _arg_1.toLowerCase();
            _arg_1 = _arg_1.replace(/ /g, "");
            var _local_2:int;
            for each (_local_3 in _arg_1.split(","))
            {
                if (FILTER.toInt(_local_3) > -1)
                {
                    _local_2 = (_local_2 + (1 << FILTER.toInt(_local_3)));
                };
            };
            return (_local_2);
        }

        public function IsSpriteInList(_arg_1:String):Boolean
        {
            var _local_3:cGOSpriteLibContainer;
            if (this.mGOList_vector == null)
            {
                return (false);
            };
            var _local_2:int;
            while (_local_2 < this.mGOList_vector.length)
            {
                _local_3 = this.mGOList_vector[_local_2];
                if (_arg_1 == _local_3.mGfxResourceListName_string)
                {
                    return (true);
                };
                _local_2++;
            };
            return (false);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        private function AutoAddSpriteLibContainerToList(_arg_1:Vector.<cGOSpriteLibContainer>, _arg_2:Dictionary, _arg_3:String, _arg_4:String, _arg_5:cXML, _arg_6:Function, _arg_7:Boolean, _arg_8:Boolean, _arg_9:int, _arg_10:int):void
        {
            var _local_13:Boolean;
            var _local_14:String;
            var _local_15:String;
            var _local_16:String;
            if (_arg_5 == null)
            {
                return;
            };
            var _local_11:String = _arg_5.GetAttributeString_string(_arg_3);
            var _local_12:cGOSpriteLibContainer;
            if (((!(_local_11 == null)) && (!(_local_11 == ""))))
            {
                _local_13 = _arg_8;
                _local_14 = _arg_5.GetAttributeString_string("stream");
                if (_local_14 == "onLoading")
                {
                    _local_13 = false;
                };
                _local_12 = new cGOSpriteLibContainer(this, (_arg_4 + _local_11), _arg_6, int(this.defaultZoom), _arg_7, _local_13, _arg_9);
                _local_12.mId = _arg_10;
                if (global.gameState == "Editor")
                {
                    _local_12.mExternalData = _arg_5;
                };
                _local_12.mGfxResourceListName_string = _arg_5.GetAttributeString_string("name");
                _local_12.mGfxResourceSettlerName_string = _arg_5.GetAttributeString_string("resourceSettlerName");
                _local_12.mGfxResourceListNr = _arg_1.length;
                _local_12.mSmokeEffectSetName_string = _arg_5.GetAttributeString_string(this.SMOKE_EFFECT_SET_NAME);
                _local_12.mShowSmokeEvenIfNotWorking = _arg_5.GetAttributeBool(this.SHOW_SMOKE_EVEN_IF_NOT_WORKING);
                _local_12.mFlagEffectSetName_string = _arg_5.GetAttributeString_string(this.FLAG_EFFECT_SET_NAME);
                _local_12.mEffectDefaultAnimSpeed = _arg_5.GetAttributeFloatingPoint("effectdefaultanimspeed");
                _local_12.mAnimationSpeed = _arg_5.GetAttributeFloatingPoint("workanimspeed");
                _local_12.mConstructionAnimSpeed = _arg_5.GetAttributeFloatingPoint("constructionanimspeed");
                _local_12.mShowMissingResources = (!(global.buildingDefaultParameterDoNotShowMissingResourceIcon_dictionary.Contains(_local_12.mGfxResourceListName_string)));
                _local_12.ui = _arg_5.GetAttributeString_string("ui");
                _local_12.uiContent = _arg_5.GetAttributeInt("uicontent");
                _local_12.productionType = _arg_5.GetAttributeInt("productionType", -1);
                _local_12.waitForPickup = _arg_5.GetAttributeBool("waitForPickup", false);
                _local_12.showWaitForPickupIcon = _arg_5.GetAttributeBool("showWaitForPickupIcon", false);
                _local_12.waitForPickupSpriteIndex = _arg_5.GetAttributeInt("waitForPickupSpriteIndex", -1);
                _local_12.productionReadyAvatarType = _arg_5.GetAttributeString_string("productionReadyAvatarType", "");
                _local_12.requiresEvent = _arg_5.GetAttributeString_string("requiresEvent");
                _local_12.requiresBuff = _arg_5.GetAttributeString_string("requiresBuff");
                _local_12.depletedMineExtension = _arg_5.GetAttributeString_string("depletedMineExtension");
                _local_12.preventDeletion = _arg_5.GetAttributeBool("preventDeletion");
                _local_12.mIgnoreFilterMask = this.CalculateFilterMask(_arg_5.GetAttributeString_string("ignoreFilter"));
                _local_12.useDefaultHighlight = _arg_5.GetAttributeBool("useDefaultHighlight");
                if (_local_14 == "onGameStart")
                {
                    _local_12.setSpriteAsUsed();
                };
                _local_15 = _arg_5.GetAttributeString_string("streamMode");
                _local_12.mRefreshAfterStream = (_local_15 == "refreshAfterStream");
                if (_arg_5.HasSubNode("renderLayers"))
                {
                    global.buildingLayerManager.registerDefinition(_local_12.mGfxResourceListName_string, _arg_5.MoveToSubNode("renderLayers"));
                };
            };
            if (((!(_local_12 == null)) && (!(_local_12.mId == -1))))
            {
                if (_local_12.mId >= _arg_1.length)
                {
                    while (_arg_1.length < _local_12.mId)
                    {
                        _arg_1.push(null);
                    };
                }
                else
                {
                    _local_16 = ((((("gfx_settings.xml -> Error in XML: Section <Building> ID Mismatch at Object: " + _local_12.mFileName_string) + " ID is ") + _local_12.mId) + " but should be bigger than ") + _arg_1.length);
                    cLog.showErrorMessage(_local_16);
                };
            };
            _arg_1.push(_local_12);
            if (_local_12 != null)
            {
                _arg_2[_local_12.mGfxResourceListName_string] = _local_12;
            };
        }


    }
}
