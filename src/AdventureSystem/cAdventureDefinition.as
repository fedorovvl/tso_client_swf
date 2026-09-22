package AdventureSystem
{
    import Utils.HashMapWrapper;
    import __AS3__.vec.Vector;
    import mx.collections.ArrayCollection;
    import nLib.cXML;
    import Utils.StringUtils;
    import Enums.ADVENTURE_MODE;
    import Enums.ADVENTURE_TYPE;
    import Enums.ADVENTURE_THEME;
    import Enums.ADVENTURE_CAMPAIGN;
    import Communication.VO.TriggerVO;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import GUI.Assets.gAssetManager;
    import Trigger.Trigger;
    import Trigger.TriggerFactory;
    import nLib.cLog;
    import Interface.cGeneralInterface;
    import __AS3__.vec.*;

    public class cAdventureDefinition 
    {

        public static var map_AdventureName_AdventureDefinition:HashMapWrapper = new HashMapWrapper();
        public static var mDifficultyIcons:Object = {};
        public static var mTeaserImages:Object = {};
        public static var mAvatarImages:Object = {};
        public static var mapFolder:String = "";
        public static var mapFolderExpeditionAdventure:String = "";
        public static var mapFolderExpeditionPvE:String = "";
        public static var mapFolderExpeditionPvP:String = "";
        public static var questFolder:String = "";
        public static var genericAdventureQuestsFile:String = "";

        private var mLevelRangeExpedition:int = 0;
        private var mDifficulty:int = 0;
        private var mAdventureBuffGroup:String;
        private var mDifficultyTier:int = 0;
        private var mIsTradable:Boolean = false;
        public var mName_string:String;
        private var mAdventureResoures:Vector.<String>;
        private var mRequiresEvent:String = "";
        private var mDuration:int;
        private var mPreventTravel:Boolean = false;
        private var mIsRecurring:Boolean = true;
        private var mIsDeletable:Boolean = false;
        private var mXpConvertInto:String;
        private var mCampaign:int;
        private var mColorSchema:String;
        private var mXpConversionRate:Number;
        public var mStartConditions_vector:ArrayCollection = null;
        private var mMode:int = 0;
        private var mType:int;
        private var mQuality:int = 0;
        private var mValorFromXPRate:Number;
        private var mTheme:int;
        public var mLevelRange:String;
        public var mSuccessLootTableID:int;
        public var mId:int;
        private var mUseElite:Boolean = true;
        public var mQuestFileName_string:String;
        private var mMusic_string:String;
        public var mMapFileName_string:String;
        public var mMaxPlayers:int;


        public static function CalcAdventureMapLevel(_arg_1:int):Number
        {
            return (((Number(_arg_1) - 15) * (170 / 34)) + 1);
        }

        public static function CreateFromXML(_arg_1:cXML):cAdventureDefinition
        {
            var _local_3:cXML;
            var _local_4:String;
            var _local_2:cAdventureDefinition = new (cAdventureDefinition)();
            _local_2.mId = _arg_1.GetAttributeInt("id");
            _local_2.mName_string = _arg_1.GetAttributeString_string("name");
            _local_2.mDifficulty = _arg_1.GetAttributeInt("difficulty");
            _local_2.mDifficultyTier = _arg_1.GetAttributeInt("difficultyTier", -1);
            if (_local_2.mDifficultyTier == -1)
            {
                _local_2.mDifficultyTier = ((_local_2.mDifficulty / 3) + 1);
            };
            _local_2.mQuality = _arg_1.GetAttributeInt("quality", 1);
            if (StringUtils.startsWith(_local_2.mName_string, "$ExpeditionAdventure"))
            {
                _local_2.mMapFileName_string = (mapFolderExpeditionAdventure + _arg_1.GetAttributeString_string("mapFileName"));
                _local_2.mMode = ADVENTURE_MODE.MODE_EXPEDITION;
                _local_2.mLevelRangeExpedition = StringUtils.ToInt(StringUtils.SubString(_local_2.mName_string, ("$ExpeditionAdventure".length + 1), 2));
            }
            else
            {
                if (StringUtils.startsWith(_local_2.mName_string, "$ExpeditionPvE"))
                {
                    _local_2.mMapFileName_string = (mapFolderExpeditionPvE + _arg_1.GetAttributeString_string("mapFileName"));
                    _local_2.mMode = ADVENTURE_MODE.MODE_EXPEDITION_PVE;
                    _local_2.mLevelRangeExpedition = StringUtils.ToInt(StringUtils.SubString(_local_2.mName_string, ("$ExpeditionPvE".length + 1), 2));
                }
                else
                {
                    if (StringUtils.startsWith(_local_2.mName_string, "$ExpeditionPvP"))
                    {
                        _local_2.mMapFileName_string = (mapFolderExpeditionPvP + _arg_1.GetAttributeString_string("mapFileName"));
                        _local_2.mMode = ADVENTURE_MODE.MODE_EXPEDITION_PVP;
                        _local_2.mLevelRangeExpedition = StringUtils.ToInt(StringUtils.SubString(_local_2.mName_string, ("$ExpeditionPvP".length + 1), 2));
                    }
                    else
                    {
                        if (StringUtils.startsWith(_arg_1.GetName_string(), "BuffAdventure"))
                        {
                            _local_2.mMapFileName_string = (mapFolder + _arg_1.GetAttributeString_string("mapFileName"));
                            _local_2.mMode = ADVENTURE_MODE.MODE_BUFF_ADVENTURE;
                        }
                        else
                        {
                            if (StringUtils.startsWith(_arg_1.GetName_string(), "MixedAdventure"))
                            {
                                _local_2.mMapFileName_string = (mapFolder + _arg_1.GetAttributeString_string("mapFileName"));
                                _local_2.mMode = ADVENTURE_MODE.MODE_MIXED_ADVENTURE;
                            }
                            else
                            {
                                _local_2.mMapFileName_string = (mapFolder + _arg_1.GetAttributeString_string("mapFileName"));
                                _local_2.mMode = ADVENTURE_MODE.MODE_CLASSIC;
                            };
                        };
                    };
                };
            };
            _local_2.mQuestFileName_string = (questFolder + _arg_1.GetAttributeString_string("questFileName"));
            _local_2.mMaxPlayers = _arg_1.GetAttributeInt("maxPlayers");
            _local_2.mLevelRange = _arg_1.GetAttributeString_string("levelRange", "None");
            _local_2.mDuration = (((_arg_1.GetAttributeInt("durationHours") * 60) * 60) * 1000);
            _local_2.mSuccessLootTableID = _arg_1.GetAttributeInt("successLootTable");
            _local_2.mColorSchema = _arg_1.GetAttributeString_string("colorSchema");
            _local_2.mIsTradable = _arg_1.GetAttributeBool("tradable", false);
            _local_2.mMusic_string = _arg_1.GetAttributeString_string("music", "");
            _local_2.mPreventTravel = _arg_1.GetAttributeBool("preventTravel");
            _local_2.mXpConversionRate = _arg_1.GetAttributeFloatingPoint("xpConversionRate");
            _local_2.mXpConvertInto = _arg_1.GetAttributeString_string("xpConvertInto");
            _local_2.mValorFromXPRate = _arg_1.GetAttributeFloatingPoint("valorFromXPRate", 0);
            _local_2.mUseElite = _arg_1.GetAttributeBool("useElite", false);
            _local_2.mIsRecurring = _arg_1.GetAttributeBool("isRecurring", false);
            _local_2.mRequiresEvent = _arg_1.GetAttributeString_string("requiresEvent", "");
            _local_2.mIsDeletable = _arg_1.GetAttributeBool("deletable", true);
            _local_2.mType = ADVENTURE_TYPE.parse(_arg_1.GetAttributeString_string("type", ""));
            _local_2.mTheme = ADVENTURE_THEME.parse(_arg_1.GetAttributeString_string("theme", ""));
            _local_2.mCampaign = ADVENTURE_CAMPAIGN.parse(_arg_1.GetAttributeString_string("campaign", ""));
            for each (_local_3 in _arg_1.MoveToSubNodeAndCreateChildrenArray("startconditions"))
            {
                if (_local_2.mStartConditions_vector == null)
                {
                    _local_2.mStartConditions_vector = new ArrayCollection();
                };
                _local_2.mStartConditions_vector.addItem(TriggerVO.createFromXML(_local_3, -1));
            };
            if (((_local_2.mMode == ADVENTURE_MODE.MODE_BUFF_ADVENTURE) || (_local_2.mMode == ADVENTURE_MODE.MODE_MIXED_ADVENTURE)))
            {
                _local_2.mAdventureBuffGroup = _arg_1.GetAttributeString_string("adventureBuffGroup");
                _local_2.mAdventureResoures = new Vector.<String>();
                for each (_local_4 in _arg_1.GetAttributeString_string("adventureResources").split(","))
                {
                    if (_local_4 != "")
                    {
                        _local_2.mAdventureResoures.push(_local_4);
                    };
                };
            };
            return (_local_2);
        }

        public static function GetDifficultyColor(_arg_1:int):uint
        {
            if (_arg_1 <= 3)
            {
                return (0xFFFFFF);
            };
            if (_arg_1 <= 6)
            {
                return (8828783);
            };
            if (_arg_1 <= 9)
            {
                return (6000639);
            };
            if (_arg_1 <= 12)
            {
                return (12219903);
            };
            return (16724787);
        }

        public static function GetAdventureIcon(_arg_1:String, _arg_2:Boolean):Bitmap
        {
            var _local_4:String;
            var _local_5:Bitmap;
            var _local_6:Bitmap;
            var _local_7:Point;
            var _local_3:cAdventureDefinition = FindAdventureDefinition(_arg_1);
            if (_local_3 != null)
            {
                _local_4 = _local_3.GetType_string();
                _local_5 = gAssetManager.GetBuffIcon(_arg_1, _arg_2);
                if (((!(_local_4 == "")) && (!(_local_4 == "Expedition"))))
                {
                    _local_6 = gAssetManager.ColorFilterImage(gAssetManager.GetBitmap(("adventureType" + _local_4)), cAdventureDefinition.GetDifficultyColor(_local_3.mDifficulty));
                    if (((((!(_local_6 == null)) && (!(_local_5.bitmapData == null))) && (_local_6.width > 0)) && (_local_6.height > 0)))
                    {
                        _local_7 = new Point(((_local_5.bitmapData.width - _local_6.bitmapData.width) - 3), ((_local_5.bitmapData.height - _local_6.bitmapData.height) - 2));
                        gAssetManager.AddIconToImage(_local_5, _local_6, _local_7);
                    };
                };
                return (_local_5);
            };
            return (null);
        }

        private static function CreateGenericAdventures(_arg_1:cXML):void
        {
            var _local_8:cXML;
            var _local_9:int;
            var _local_10:int;
            var _local_11:cAdventureDefinition;
            var _local_2:int = _arg_1.GetAttributeInt("levelRangeMin");
            var _local_3:int = _arg_1.GetAttributeInt("levelRangeMax");
            var _local_4:int = _arg_1.GetAttributeInt("difficultyMin");
            var _local_5:int = _arg_1.GetAttributeInt("difficultyMax");
            var _local_6:int = _arg_1.GetAttributeInt("id");
            var _local_7:cAdventureDefinition = new (cAdventureDefinition)();
            _local_7.mName_string = _arg_1.GetAttributeString_string("name");
            _local_7.mQuality = _arg_1.GetAttributeInt("quality", 1);
            if (StringUtils.startsWith(_local_7.mName_string, "$ExpeditionAdventure"))
            {
                _local_7.mMode = ADVENTURE_MODE.MODE_EXPEDITION;
                _local_7.mMapFileName_string = (mapFolderExpeditionAdventure + _arg_1.GetAttributeString_string("mapFileName"));
            }
            else
            {
                if (StringUtils.startsWith(_local_7.mName_string, "$ExpeditionPvE"))
                {
                    _local_7.mMode = ADVENTURE_MODE.MODE_EXPEDITION_PVE;
                    _local_7.mMapFileName_string = (mapFolderExpeditionPvE + _arg_1.GetAttributeString_string("mapFileName"));
                }
                else
                {
                    if (StringUtils.startsWith(_local_7.mName_string, "$ExpeditionPvP"))
                    {
                        _local_7.mMode = ADVENTURE_MODE.MODE_EXPEDITION_PVP;
                        _local_7.mMapFileName_string = (mapFolderExpeditionPvP + _arg_1.GetAttributeString_string("mapFileName"));
                    };
                };
            };
            _local_7.mQuestFileName_string = (questFolder + _arg_1.GetAttributeString_string("questFileName"));
            _local_7.mMaxPlayers = _arg_1.GetAttributeInt("maxPlayers");
            _local_7.mLevelRange = _arg_1.GetAttributeString_string("levelRange", "None");
            _local_7.mDuration = (((_arg_1.GetAttributeInt("durationHours") * 60) * 60) * 1000);
            _local_7.mSuccessLootTableID = _arg_1.GetAttributeInt("successLootTable");
            _local_7.mColorSchema = _arg_1.GetAttributeString_string("colorSchema");
            _local_7.mType = ADVENTURE_TYPE.parse(_arg_1.GetAttributeString_string("type", ""));
            _local_7.mTheme = ADVENTURE_THEME.parse(_arg_1.GetAttributeString_string("theme", ""));
            _local_7.mCampaign = ADVENTURE_CAMPAIGN.parse(_arg_1.GetAttributeString_string("campaign", ""));
            _local_7.mIsTradable = _arg_1.GetAttributeBool("tradable", false);
            _local_7.mMusic_string = _arg_1.GetAttributeString_string("music", "");
            _local_7.mPreventTravel = _arg_1.GetAttributeBool("preventTravel");
            _local_7.mXpConversionRate = _arg_1.GetAttributeFloatingPoint("xpConversionRate");
            _local_7.mXpConvertInto = _arg_1.GetAttributeString_string("xpConvertInto");
            _local_7.mValorFromXPRate = _arg_1.GetAttributeFloatingPoint("valorFromXPRate", 0);
            _local_7.mUseElite = _arg_1.GetAttributeBool("useElite", true);
            _local_7.mIsRecurring = _arg_1.GetAttributeBool("isRecurring", false);
            _local_7.mRequiresEvent = _arg_1.GetAttributeString_string("requiresEvent", "");
            _local_7.mIsDeletable = _arg_1.GetAttributeBool("deletable", true);
            for each (_local_8 in _arg_1.MoveToSubNodeAndCreateChildrenArray("startconditions"))
            {
                if (_local_7.mStartConditions_vector == null)
                {
                    _local_7.mStartConditions_vector = new ArrayCollection();
                };
                _local_7.mStartConditions_vector.addItem(TriggerVO.createFromXML(_local_8, -1));
            };
            _local_9 = _local_2;
            while (_local_9 <= _local_3)
            {
                _local_10 = _local_4;
                while (_local_10 <= _local_5)
                {
                    _local_11 = new (cAdventureDefinition)();
                    _local_11.mId = _local_6;
                    _local_11.mName_string = (((((_local_7.GetName() + "_") + StringUtils.zeroPad(_local_9, 2)) + "_") + StringUtils.zeroPad(_local_10, 2)) + "_01");
                    _local_11.mLevelRangeExpedition = _local_9;
                    _local_11.mDifficulty = _local_10;
                    _local_11.mDifficultyTier = _local_7.GetDifficultyTier();
                    _local_11.mQuality = _local_7.GetQuality();
                    _local_11.mMode = _local_7.GetMode();
                    _local_11.mQuestFileName_string = _local_7.mQuestFileName_string;
                    _local_11.mMapFileName_string = _local_7.mMapFileName_string;
                    _local_11.mMaxPlayers = _local_7.mMaxPlayers;
                    _local_11.mLevelRange = _local_7.mLevelRange;
                    _local_11.mDuration = _local_7.GetDuration();
                    _local_11.mSuccessLootTableID = _local_7.mSuccessLootTableID;
                    _local_11.mColorSchema = _local_7.mColorSchema;
                    _local_11.mType = _local_7.mType;
                    _local_11.mIsTradable = _local_7.mIsTradable;
                    _local_11.mMusic_string = _local_7.mMusic_string;
                    _local_11.mPreventTravel = _local_7.mPreventTravel;
                    _local_11.mXpConversionRate = _local_7.mXpConversionRate;
                    _local_11.mXpConvertInto = _local_7.mXpConvertInto;
                    _local_11.mValorFromXPRate = _local_7.mValorFromXPRate;
                    _local_11.mUseElite = _local_7.mUseElite;
                    _local_11.mIsRecurring = _local_7.mIsRecurring;
                    _local_11.mRequiresEvent = _local_7.mRequiresEvent;
                    _local_11.mIsDeletable = _local_7.mIsDeletable;
                    _local_11.mStartConditions_vector = _local_7.mStartConditions_vector;
                    map_AdventureName_AdventureDefinition.putItem(_local_11.mName_string, _local_11);
                    _local_6++;
                    _local_10++;
                };
                _local_9++;
            };
        }

        public static function parseXML(_arg_1:cXML):void
        {
            var _local_4:cXML;
            var _local_5:cAdventureDefinition;
            var _local_2:cXML = _arg_1.MoveToSubNode("Adventures");
            mapFolder = _local_2.GetAttributeString_string("mapFolder");
            mapFolderExpeditionAdventure = _local_2.GetAttributeString_string("expeditionAdventureFolder");
            mapFolderExpeditionPvE = _local_2.GetAttributeString_string("expeditionPvEFolder");
            mapFolderExpeditionPvP = _local_2.GetAttributeString_string("expeditionPvPFolder");
            questFolder = _local_2.GetAttributeString_string("questFolder");
            genericAdventureQuestsFile = _local_2.GetAttributeString_string("genericAdventureQuestsFile");
            var _local_3:Vector.<cXML> = _local_2.CreateChildrenArray();
            for each (_local_4 in _local_3)
            {
                if (_local_4.GetAttributeInt("levelRangeMin", -1) < 0)
                {
                    _local_5 = CreateFromXML(_local_4);
                    map_AdventureName_AdventureDefinition.putItem(_local_5.mName_string, _local_5);
                }
                else
                {
                    CreateGenericAdventures(_local_4);
                };
            };
        }

        public static function FindAdventureDefinition(_arg_1:String):cAdventureDefinition
        {
            return (map_AdventureName_AdventureDefinition.getItem(_arg_1) as cAdventureDefinition);
        }


        public function GetMode():int
        {
            return (this.mMode);
        }

        public function isStartConditionsFullfilled(_arg_1:cGeneralInterface):Boolean
        {
            var _local_3:TriggerVO;
            var _local_4:Trigger;
            if (this.mStartConditions_vector == null)
            {
                return (true);
            };
            var _local_2:TriggerFactory = new TriggerFactory(_arg_1);
            for each (_local_3 in this.mStartConditions_vector)
            {
                _local_4 = _local_2.createTrigger(_local_3, null);
                if (!_local_4.check())
                {
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info("Adventure start requirements not met");
                    };
                    _local_4.dispose();
                    return (false);
                };
                _local_4.dispose();
            };
            return (true);
        }

        public function GetXpConversionRate():Number
        {
            return (this.mXpConversionRate);
        }

        public function GetXpConvertInto():String
        {
            return (this.mXpConvertInto);
        }

        public function IsUsingAdventureSpecificBuffs():Boolean
        {
            return ((this.IsBuffAdventure()) || (this.IsMixedAdventure()));
        }

        public function IsExpedition():Boolean
        {
            return (this.GetMode() == ADVENTURE_MODE.MODE_EXPEDITION);
        }

        public function IsClassicAdventure():Boolean
        {
            return (this.GetMode() == ADVENTURE_MODE.MODE_CLASSIC);
        }

        public function GetDifficulty():int
        {
            return (this.mDifficulty);
        }

        public function GetDifficultyTier():int
        {
            return (this.mDifficultyTier);
        }

        public function GetTheme():int
        {
            return (this.mTheme);
        }

        public function GetType():int
        {
            return (this.mType);
        }

        public function GetTheme_string():String
        {
            return (ADVENTURE_THEME.toString(this.mTheme));
        }

        public function IsTrainingExpedition():Boolean
        {
            return (this.mName_string == "$ExpeditionAdventure_01_01_01");
        }

        public function GetType_string():String
        {
            return (ADVENTURE_TYPE.toString(this.mType));
        }

        public function GetCampaign_string():String
        {
            return (ADVENTURE_CAMPAIGN.toString(this.mCampaign));
        }

        public function GetRequiresEvent():String
        {
            return (this.mRequiresEvent);
        }

        public function IsRecurring():Boolean
        {
            return (this.mIsRecurring);
        }

        public function GetConnectedBuffGroup():String
        {
            return (this.mAdventureBuffGroup);
        }

        public function IsMixedAdventure():Boolean
        {
            return (this.GetMode() == ADVENTURE_MODE.MODE_MIXED_ADVENTURE);
        }

        public function GetMusic_string():String
        {
            return (this.mMusic_string);
        }

        public function IsPreventTravel():Boolean
        {
            return (this.mPreventTravel);
        }

        public function GetColorSchema():String
        {
            return (this.mColorSchema);
        }

        public function isDeletable(_arg_1:cGeneralInterface):Boolean
        {
            return ((this.mIsDeletable) || (!((StringUtils.isEmpty(this.GetRequiresEvent())) || (_arg_1.mEventManager.isEventStarted(this.GetRequiresEvent())))));
        }

        public function GetTeaserImage():String
        {
            if (cAdventureDefinition.mTeaserImages[this.mName_string] != null)
            {
                return (cAdventureDefinition.mTeaserImages[this.mName_string]);
            };
            if (((this.mName_string.indexOf("$") == 0) && (this.mName_string.indexOf("_") > 2)))
            {
                return (cAdventureDefinition.mTeaserImages[(this.mName_string.split("_")[0] + "*")]);
            };
            return (null);
        }

        public function GetLevelRangeExpedition():int
        {
            return (this.mLevelRangeExpedition);
        }

        public function IsBuffAdventure():Boolean
        {
            return (this.GetMode() == ADVENTURE_MODE.MODE_BUFF_ADVENTURE);
        }

        public function GetDifficulityIcon():String
        {
            return (cAdventureDefinition.mDifficultyIcons[this.mName_string]);
        }

        public function GetName():String
        {
            return (this.mName_string);
        }

        public function IsColony():Boolean
        {
            return ((this.IsPvE()) || (this.IsPvP()));
        }

        public function IsTradable():Boolean
        {
            return (this.mIsTradable);
        }

        public function IsPvP():Boolean
        {
            return (this.GetMode() == ADVENTURE_MODE.MODE_EXPEDITION_PVP);
        }

        public function GetQuality():int
        {
            return (this.mQuality);
        }

        public function GetAvatarImage():String
        {
            if (cAdventureDefinition.mAvatarImages[this.mName_string] != null)
            {
                return (cAdventureDefinition.mAvatarImages[this.mName_string]);
            };
            if (((this.mName_string.indexOf("$") == 0) && (this.mName_string.indexOf("_") > 2)))
            {
                return (cAdventureDefinition.mAvatarImages[(this.mName_string.split("_")[0] + "*")]);
            };
            return (null);
        }

        public function IsPvE():Boolean
        {
            return (this.GetMode() == ADVENTURE_MODE.MODE_EXPEDITION_PVE);
        }

        public function GetConnectedResources():Vector.<String>
        {
            return (this.mAdventureResoures);
        }

        public function UseElite():Boolean
        {
            return (this.mUseElite);
        }

        public function GetCampaign():int
        {
            return (this.mCampaign);
        }

        public function GetValorFromXPRate():Number
        {
            return (this.mValorFromXPRate);
        }

        public function GetDuration():int
        {
            return (this.mDuration);
        }

        public function UsesCombatThree():Boolean
        {
            return (((!(this.GetMode() == ADVENTURE_MODE.MODE_CLASSIC)) && (!(this.GetMode() == ADVENTURE_MODE.MODE_BUFF_ADVENTURE))) && (!(this.GetMode() == ADVENTURE_MODE.MODE_MIXED_ADVENTURE)));
        }


    }
}
