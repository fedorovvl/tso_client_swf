package 
{
    import Enums.FILTER;
    import flash.display.Shader;
    import flash.filters.ShaderFilter;
    import GO.cGO;
    import GO.cBuilding;
    import GO.cGuiIcon;
    import GO.cBackground;
    import GO.cGOSpriteLibContainer;
    import Enums.OBJECTTYPE;
    import nLib.cEventWithData;
    import GUI.Assets.gAssetManager;
    import GUI.Loca.cLocaManager;
    import flash.events.Event;
    import nLib.gMisc;
    import Communication.VO.dFilterVO;
    import Utils.StringUtils;
    import Interface.cGeneralInterface;
    import flash.utils.ByteArray;
    import GOSets.cGOSetManager;
    import Interface.gInitStaticForAllZones;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import ServerState.*;
    import GO.*;
    import nLib.*;
    import nLib.SpriteLibDataClass.*;
    import Enums.*;

    public final class gGfxResource 
    {

        private static const MAX_GFX_FILES:int = 4652;
        public static var gUseFilterType:int = FILTER.NONE;//0

        [Embed(source="../assets/gGfxResource/mOutline_Filter.bin", mimeType="application/octet-stream")]
        private static var mOutline_Filter:Class;
        public static var mOutline_Shader:Shader;
        public static var mOutline_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mCopyWithAlpha_Filter.bin", mimeType="application/octet-stream")]
        private static var mCopyWithAlpha_Filter:Class;
        private static var mCopyWithAlpha_Shader:Shader;
        public static var mCopyWithAlpha_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mArminNightFinal_Filter.bin", mimeType="application/octet-stream")]
        private static var mArminNightFinal_Filter:Class;
        public static var mArminNightFinal_Shader:Shader;
        public static var mArminNightFinal_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mArminSnowLight_Filter.bin", mimeType="application/octet-stream")]
        private static var mArminSnowLight_Filter:Class;
        public static var mArminSnowLight_Shader:Shader;
        public static var mArminSnowLight_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mArminSnow_Filter.bin", mimeType="application/octet-stream")]
        private static var mArminSnow_Filter:Class;
        public static var mArminSnow_Shader:Shader;
        public static var mArminSnow_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mArminSnowNoWater_Filter.bin", mimeType="application/octet-stream")]
        private static var mArminSnowNoWater_Filter:Class;
        public static var mArminSnowNoWater_Shader:Shader;
        public static var mArminSnowNoWater_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mArminOven_Filter.bin", mimeType="application/octet-stream")]
        private static var mArminOven_Filter:Class;
        public static var mArminOven_Shader:Shader;
        public static var mArminOven_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mColorMod_Filter.bin", mimeType="application/octet-stream")]
        private static var mColorMod_Filter:Class;
        public static var mColorMod_Shader:Shader;
        public static var mColorMod_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mZoom_Filter.bin", mimeType="application/octet-stream")]
        private static var mZoom_Filter:Class;
        public static var mZoom_Shader:Shader;
        public static var mZoom_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mAntialiasingZoom_Filter.bin", mimeType="application/octet-stream")]
        private static var mAntialiasingZoom_Filter:Class;
        public static var mAntialiasingZoom_Shader:Shader;
        public static var mAntialiasingZoom_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mfloDoomsday_Filter.bin", mimeType="application/octet-stream")]
        private static var mfloDoomsday_Filter:Class;
        public static var mfloDoomsday_Shader:Shader;
        public static var mfloDoomsday_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mDesertScenario_Filter.bin", mimeType="application/octet-stream")]
        private static var mDesertScenario_Filter:Class;
        public static var mDesertScenario_Shader:Shader;
        public static var mDesertScenario_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mTropicalScenario_Filter.bin", mimeType="application/octet-stream")]
        private static var mTropicalScenario_Filter:Class;
        public static var mTropicalScenario_Shader:Shader;
        public static var mTropicalScenario_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mBlackAndWhite_Filter.bin", mimeType="application/octet-stream")]
        private static var mBlackAndWhite_Filter:Class;
        public static var mBlackAndWhite_Shader:Shader;
        public static var mBlackAndWhite_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mSpooky_Filter.bin", mimeType="application/octet-stream")]
        private static var mSpooky_Filter:Class;
        public static var mSpooky_Shader:Shader;
        public static var mSpooky_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mSnowMedium_Filter.bin", mimeType="application/octet-stream")]
        private static var mSnowMedium_Filter:Class;
        public static var mSnowMedium_Shader:Shader;
        public static var mSnowMedium_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mTundra_Filter.bin", mimeType="application/octet-stream")]
        private static var mTundra_Filter:Class;
        public static var mTundra_Shader:Shader;
        public static var mTundra_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mDarkershadow_Filter.bin", mimeType="application/octet-stream")]
        private static var mDarkershadow_Filter:Class;
        public static var mDarkershadow_Shader:Shader;
        public static var mDarkershadow_ShaderFilter:ShaderFilter;

        [Embed(source="../assets/gGfxResource/mMagicsepia_Filter.bin", mimeType="application/octet-stream")]
        private static var mMagicsepia_Filter:Class;
        public static var mMagicsepia_Shader:Shader;
        public static var mMagicsepia_ShaderFilter:ShaderFilter;
        public static var mCurrent_Shader:Shader;
        public static var mCurrent_ShaderFilter:ShaderFilter;
        public static var mWaitForCommandIcon:cGO;
        public static var mBuildingQueuedIcon:cGO;
        public static var mPreBuild:cBuilding;
        public static var mPreBuildWater:cBuilding;
        public static var mAttackCursor:cGO;
        public static var mBuildingInfoIcons:cGuiIcon;
        public static var mUpgradeLevelIcons:cGuiIcon;
        public static var mUpgradeLevelNumbers:cGuiIcon;
        public static var mGeneralStateIcons:cGuiIcon;
        public static var mHealthBarIcons:cGuiIcon;
        public static var mProgressBarIcons:cGuiIcon;
        public static var mBuildingRepairIcon:cGuiIcon;
        public static var mBuildingCountBG:cGuiIcon;
        public static var mWaterTile:cBackground;
        public static var mStreamReplacementSpriteContainer:cGOSpriteLibContainer;
        public static var mActivateStreaming:Boolean;
        private static var mCountLoadingScreen:int;
        private static var mGFXLoadedCallback:Function;


        public static function InitializeGlobalGfx():void
        {
            mWaitForCommandIcon = cGuiIcon.CreateFromString("WaitForCommand", null);
            mWaitForCommandIcon.mSprite.SetAnim(mWaitForCommandIcon.GetGOContainer().mEffectDefaultAnimSpeed, true);
            mBuildingQueuedIcon = cGuiIcon.CreateFromString("BuildingQueued", null);
            mPreBuild = cBuilding.CreateFromString(null, global.buildingGroup, "prebuild", null);
            mPreBuildWater = cBuilding.CreateFromString(null, global.buildingGroup, "prebuild_water", null);
            mAttackCursor = cGO.CreateGoFromLevelObject(null, OBJECTTYPE.STREET, "Street_AttackCursor", null);
            mBuildingInfoIcons = cGuiIcon.CreateFromString("BuildingInfoIcons", null);
            mUpgradeLevelIcons = cGuiIcon.CreateFromString("UpgradeLevelIcons", null);
            mUpgradeLevelNumbers = cGuiIcon.CreateFromString("UpgradeLevelNumbers", null);
            mGeneralStateIcons = cGuiIcon.CreateFromString("GeneralState", null);
            mHealthBarIcons = cGuiIcon.CreateFromString("HealthbarIcons", null);
            mHealthBarIcons.SetSubType(0);
            mProgressBarIcons = cGuiIcon.CreateFromString("ProgressbarIcons", null);
            mProgressBarIcons.SetSubType(0);
            mBuildingRepairIcon = cGuiIcon.CreateFromString("RepairBuilding", null);
            mBuildingRepairIcon.SetSubType(0);
            mBuildingCountBG = cGuiIcon.CreateFromString("BuildingCountBG", null);
            mBuildingCountBG.SetSubType(0);
            mWaterTile = cBackground.CreateFromString("P13", null);
            mGFXLoadedCallback();
        }

        public static function IsFilterActive():Boolean
        {
            return (!(gUseFilterType == FILTER.NONE));
        }

        public static function ReplacementGfxLoaded(_arg_1:cEventWithData):void
        {
            global.guiIconGroup.CreateContainer("guiicon_lib/", InitCompleteHandlerguiIconGroup, false, mActivateStreaming);
        }

        private static function InitCompleteHandlerstreetGroup(_arg_1:cEventWithData):void
        {
            IncreaseCountFromLoadingScreen();
            if (global.streetGroup.IsSpriteListLoaded())
            {
                global.buildingGroup.CreateContainer("building_lib/", InitCompleteHandlerbuildingGroup, true, mActivateStreaming);
            };
        }

        private static function InitCompleteHandlerFinished(_arg_1:cEventWithData):void
        {
            IncreaseCountFromLoadingScreen();
            if (global.animalGroup.IsSpriteListLoaded())
            {
                InitializeGlobalGfx();
            };
        }

        private static function InitCompleteHandlersettlerGroup(_arg_1:cEventWithData):void
        {
            IncreaseCountFromLoadingScreen();
            if (global.settlerGroup.IsSpriteListLoaded())
            {
                global.effectGroup.CreateContainer("effect_lib/", InitCompleteHandlereffectGroup, false, mActivateStreaming);
            };
        }

        private static function InitCompleteHandlerbackgroundGroup(_arg_1:cEventWithData):void
        {
            IncreaseCountFromLoadingScreen();
            if (global.backgroundGroup.IsSpriteListLoaded())
            {
                global.streetGroup.CreateContainer("street_lib/", InitCompleteHandlerstreetGroup, false, mActivateStreaming);
            };
        }

        private static function InitCompleteHandlerlandscapeGroup(_arg_1:cEventWithData):void
        {
            IncreaseCountFromLoadingScreen();
            if (global.landscapeGroup.IsSpriteListLoaded())
            {
                global.settlerGroup.CreateContainer("settler_lib/", InitCompleteHandlersettlerGroup, true, mActivateStreaming);
            };
        }

        private static function InitCompleteHandlerbuildingGroup(_arg_1:cEventWithData):void
        {
            IncreaseCountFromLoadingScreen();
            if (global.buildingGroup.IsSpriteListLoaded())
            {
                global.landscapeGroup.CreateContainer("landscape_lib/", InitCompleteHandlerlandscapeGroup, true, mActivateStreaming);
            };
        }

        private static function InitCompleteHandlericons(_arg_1:Event):void
        {
            IncreaseCountFromLoadingScreen();
            if (gAssetManager.IsLoaded())
            {
                cLocaManager.GetInstance().Init(InitCompleteHandlerlocalization);
            };
        }

        public static function SetFilter(_arg_1:String):Boolean
        {
            var _local_3:String;
            var _local_4:Array;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_2:int = FILTER.toInt(_arg_1);
            if (_local_2 > -1)
            {
                gGfxResource.gUseFilterType = _local_2;
                gGfxResource.ActivateShader();
                if (_local_2 == FILTER.COLORMOD)
                {
                    _local_3 = _arg_1.substr(8);
                    _local_4 = _local_3.split(",");
                    _local_5 = gMisc.ParseFloat(_local_4[1]);
                    _local_6 = gMisc.ParseFloat(_local_4[2]);
                    _local_7 = gMisc.ParseFloat(_local_4[3]);
                    _local_8 = gMisc.ParseFloat(_local_4[4]);
                    _local_9 = gMisc.ParseFloat(_local_4[5]);
                    _local_10 = gMisc.ParseFloat(_local_4[6]);
                    mCurrent_Shader.data.AddRed.value = [_local_5];
                    mCurrent_Shader.data.AddGreen.value = [_local_6];
                    mCurrent_Shader.data.AddBlue.value = [_local_7];
                    mCurrent_Shader.data.MulRed.value = [_local_8];
                    mCurrent_Shader.data.MulGreen.value = [_local_9];
                    mCurrent_Shader.data.MulBlue.value = [_local_10];
                };
            }
            else
            {
                gGfxResource.gUseFilterType = FILTER.NONE;
            };
            return (true);
        }

        public static function ApplyZoom(_arg_1:Number):void
        {
            if (!defines.FILTER_ACTIVATED)
            {
                return;
            };
            mCurrent_Shader.data.dimension.value = [_arg_1];
        }

        private static function colorToRGBA(_arg_1:uint):Array
        {
            return ([(((_arg_1 >> 16) & 0xFF) / 0xFF), (((_arg_1 >> 8) & 0xFF) / 0xFF), ((_arg_1 & 0xFF) / 0xFF), 1]);
        }

        private static function InitCompleteHandlerlocalization(_arg_1:Event):void
        {
            IncreaseCountFromLoadingScreen();
            global.animalGroup.CreateContainer("animal_lib/", InitCompleteHandlerFinished, true, mActivateStreaming);
        }

        private static function InitCompleteHandlerguiIconGroup(_arg_1:cEventWithData):void
        {
            IncreaseCountFromLoadingScreen();
            if (global.guiIconGroup.IsSpriteListLoaded())
            {
                global.backgroundGroup.CreateContainer("background_lib/", InitCompleteHandlerbackgroundGroup, false, mActivateStreaming);
            };
        }

        public static function applyFilter(_arg_1:String, _arg_2:cGeneralInterface):void
        {
            var _local_3:int;
            var _local_4:dFilterVO;
            if (defines.CLIENT_FILTER)
            {
                _arg_1 = _arg_1.toLowerCase();
                _local_3 = FILTER.toInt(_arg_1);
                if (_local_3 <= FILTER.NONE)
                {
                    for each (_local_4 in global.defaultFilter_vector)
                    {
                        if (!((!(StringUtils.isEmpty(_local_4.requiresEvent))) && (!(_arg_2.mEventManager.isEventStarted(_local_4.requiresEvent)))))
                        {
                            _local_3 = _local_4.id;
                            break;
                        };
                    };
                };
                SetFilter(FILTER.toString(_local_3));
                _arg_2.mCurrentPlayerZone.filter = _local_3;
                _arg_2.mCurrentPlayerZone.SetBackgroundHasChanged(true);
                _arg_2.mCurrentPlayerZone.SetAllRescaleDirtyFlags();
                _arg_2.channels.ZONE.filterApplied(_arg_1);
            };
        }

        public static function InitPreLoadFilter():void
        {
            mAntialiasingZoom_Shader = new Shader((new mAntialiasingZoom_Filter() as ByteArray));
            mAntialiasingZoom_ShaderFilter = new ShaderFilter(mAntialiasingZoom_Shader);
            if (!defines.FILTER_ACTIVATED)
            {
                return;
            };
            mCopyWithAlpha_Shader = new Shader((new mCopyWithAlpha_Filter() as ByteArray));
            mCopyWithAlpha_ShaderFilter = new ShaderFilter(mCopyWithAlpha_Shader);
            mArminNightFinal_Shader = new Shader((new mArminNightFinal_Filter() as ByteArray));
            mArminNightFinal_ShaderFilter = new ShaderFilter(mArminNightFinal_Shader);
            mArminSnow_Shader = new Shader((new mArminSnow_Filter() as ByteArray));
            mArminSnow_ShaderFilter = new ShaderFilter(mArminSnow_Shader);
            mArminSnowLight_Shader = new Shader((new mArminSnowLight_Filter() as ByteArray));
            mArminSnowLight_ShaderFilter = new ShaderFilter(mArminSnowLight_Shader);
            mArminSnowNoWater_Shader = new Shader((new mArminSnowNoWater_Filter() as ByteArray));
            mArminSnowNoWater_ShaderFilter = new ShaderFilter(mArminSnowNoWater_Shader);
            mArminOven_Shader = new Shader((new mArminOven_Filter() as ByteArray));
            mArminOven_ShaderFilter = new ShaderFilter(mArminOven_Shader);
            mColorMod_Shader = new Shader((new mColorMod_Filter() as ByteArray));
            mColorMod_ShaderFilter = new ShaderFilter(mColorMod_Shader);
            mZoom_Shader = new Shader((new mZoom_Filter() as ByteArray));
            mZoom_ShaderFilter = new ShaderFilter(mZoom_Shader);
            mfloDoomsday_Shader = new Shader((new mfloDoomsday_Filter() as ByteArray));
            mfloDoomsday_ShaderFilter = new ShaderFilter(mfloDoomsday_Shader);
            mDesertScenario_Shader = new Shader((new mDesertScenario_Filter() as ByteArray));
            mDesertScenario_ShaderFilter = new ShaderFilter(mDesertScenario_Shader);
            mTropicalScenario_Shader = new Shader((new mTropicalScenario_Filter() as ByteArray));
            mTropicalScenario_ShaderFilter = new ShaderFilter(mTropicalScenario_Shader);
            mBlackAndWhite_Shader = new Shader((new mBlackAndWhite_Filter() as ByteArray));
            mBlackAndWhite_ShaderFilter = new ShaderFilter(mBlackAndWhite_Shader);
            mSpooky_Shader = new Shader((new mSpooky_Filter() as ByteArray));
            mSpooky_ShaderFilter = new ShaderFilter(mSpooky_Shader);
            mSnowMedium_Shader = new Shader((new mSnowMedium_Filter() as ByteArray));
            mSnowMedium_ShaderFilter = new ShaderFilter(mSnowMedium_Shader);
            mTundra_Shader = new Shader((new mTundra_Filter() as ByteArray));
            mTundra_ShaderFilter = new ShaderFilter(mTundra_Shader);
            mOutline_Shader = new Shader((new mOutline_Filter() as ByteArray));
            mOutline_ShaderFilter = new ShaderFilter(mOutline_Shader);
            mDarkershadow_Shader = new Shader((new mDarkershadow_Filter() as ByteArray));
            mDarkershadow_ShaderFilter = new ShaderFilter(mDarkershadow_Shader);
            mMagicsepia_Shader = new Shader((new mMagicsepia_Filter() as ByteArray));
            mMagicsepia_ShaderFilter = new ShaderFilter(mMagicsepia_Shader);
            ActivateShader();
        }

        public static function LoadAll(_arg_1:Function, _arg_2:int):void
        {
            mCountLoadingScreen = _arg_2;
            mGFXLoadedCallback = _arg_1;
            InitPreLoadFilter();
            mActivateStreaming = defines.ACTIVATE_STREAMING;
            if (((global.gameState == "Editor") || (global.gameState == "MainMenu")))
            {
                mActivateStreaming = false;
            };
            mStreamReplacementSpriteContainer = new cGOSpriteLibContainer(null, "guiicon_lib/empty.png", ReplacementGfxLoaded, 1000, false, false, 0);
        }

        public static function ActivateShader():void
        {
            if (!defines.FILTER_ACTIVATED)
            {
                return;
            };
            switch (gUseFilterType)
            {
                case FILTER.NONE:
                    mCurrent_Shader = mZoom_Shader;
                    mCurrent_ShaderFilter = mZoom_ShaderFilter;
                    return;
                case FILTER.NIGHT:
                    mCurrent_Shader = mArminNightFinal_Shader;
                    mCurrent_ShaderFilter = mArminNightFinal_ShaderFilter;
                    return;
                case FILTER.SNOW:
                    mCurrent_Shader = mArminSnow_Shader;
                    mCurrent_ShaderFilter = mArminSnow_ShaderFilter;
                    return;
                case FILTER.SNOW_LIGHT:
                    mCurrent_Shader = mArminSnowLight_Shader;
                    mCurrent_ShaderFilter = mArminSnowLight_ShaderFilter;
                    return;
                case FILTER.SNOW_NO_WATER:
                    mCurrent_Shader = mArminSnowNoWater_Shader;
                    mCurrent_ShaderFilter = mArminSnowNoWater_ShaderFilter;
                    return;
                case FILTER.OVEN:
                    mCurrent_Shader = mArminOven_Shader;
                    mCurrent_ShaderFilter = mArminOven_ShaderFilter;
                    return;
                case FILTER.COLORMOD:
                    mCurrent_Shader = mColorMod_Shader;
                    mCurrent_ShaderFilter = mColorMod_ShaderFilter;
                    return;
                case FILTER.DOOMSDAY:
                    mCurrent_Shader = mfloDoomsday_Shader;
                    mCurrent_ShaderFilter = mfloDoomsday_ShaderFilter;
                    return;
                case FILTER.DESERT:
                    mCurrent_Shader = mDesertScenario_Shader;
                    mCurrent_ShaderFilter = mDesertScenario_ShaderFilter;
                    return;
                case FILTER.TROPICAL:
                    mCurrent_Shader = mTropicalScenario_Shader;
                    mCurrent_ShaderFilter = mTropicalScenario_ShaderFilter;
                    return;
                case FILTER.BLACK_AND_WHITE:
                    mCurrent_Shader = mBlackAndWhite_Shader;
                    mCurrent_ShaderFilter = mBlackAndWhite_ShaderFilter;
                    return;
                case FILTER.SPOOKY:
                    mCurrent_Shader = mSpooky_Shader;
                    mCurrent_ShaderFilter = mSpooky_ShaderFilter;
                    return;
                case FILTER.SNOW_MEDIUM:
                    mCurrent_Shader = mSnowMedium_Shader;
                    mCurrent_ShaderFilter = mSnowMedium_ShaderFilter;
                    return;
                case FILTER.TUNDRA:
                    mCurrent_Shader = mTundra_Shader;
                    mCurrent_ShaderFilter = mTundra_ShaderFilter;
                    return;
                case FILTER.DARKERSHADOW:
                    mCurrent_Shader = mDarkershadow_Shader;
                    mCurrent_ShaderFilter = mDarkershadow_ShaderFilter;
                    return;
                case FILTER.MAGICSEPIA:
                    mCurrent_Shader = mMagicsepia_Shader;
                    mCurrent_ShaderFilter = mMagicsepia_ShaderFilter;
                    return;
            };
        }

        private static function InitCompleteHandlereffectGroup(_arg_1:cEventWithData):void
        {
            IncreaseCountFromLoadingScreen();
            if (global.effectGroup.IsSpriteListLoaded())
            {
                cGOSetManager.LoadGOSetData();
                gAssetManager.LoadIcons("icons/", InitCompleteHandlericons);
            };
        }

        private static function IncreaseCountFromLoadingScreen():void
        {
            mCountLoadingScreen = (mCountLoadingScreen + 1);
            gInitStaticForAllZones.ShowLoadingScreen(mCountLoadingScreen);
        }


    }
}
