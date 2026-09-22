package GUI.Components.ToolTips
{
    import mx.events.ToolTipEvent;
    import mx.core.UIComponent;
    import flash.geom.Point;
    import flash.events.Event;
    import mx.core.IToolTip;
    import flash.utils.getDefinitionByName;

    public class cToolTipUtil 
    {

        public static const SIMPLE_string:String = "Simple";
        public static const SIMPLE_ERROR_string:String = "SimpleError";
        public static const BUILDINGS_LIST_string:String = "BuildingsList";
        public static const UPGRADE_BUILDING_string:String = "UpgradeBuilding";
        public static const DEPOSIT_string:String = "Deposit";
        public static const DEMOLISH_BUILDING_string:String = "DemolishBuilding";
        public static const BUILDQUEUE_ITEM_string:String = "BuildQueueItem";
        public static const POPULATION_OVERVIEW_string:String = "PopulationOverview";
        public static const MILITARY_UNIT_string:String = "MilitaryUnit";
        public static const MILITARY_UNIT_EXTENDED_string:String = "MilitaryUnitExtended";
        public static const MILITARY_UNIT_CONDENSED_string:String = "MilitaryUnitCondensed";
        public static const MILITARY_UNIT_VERBOSE_string:String = "MilitaryUnitVerbose";
        public static const MILITARY_UNIT_SKILL_string:String = "MilitaryUnitSkill";
        public static const MILITARY_UNIT_GENERAL_string:String = "MilitaryUnitGeneral";
        public static const SHOP_ITEM_string:String = "ShopItem";
        public static const SHOP_ITEM_WITH_COSTS_string:String = "ShopItemWithCosts";
        public static const SPECIALIST_string:String = "Specialist";
        public static const BUFF_string:String = "Buff";
        public static const MULTILINE_string:String = "Multiline";
        public static const INSTANT_BUILD_string:String = "InstantBuild";
        public static const TIMED_PRODUCTION_ORDER_string:String = "TimedProductionOrder";
        public static const PRODUCTION_DURATION:String = "ProductionDuration";
        public static const SEND_ARMY:String = "SendArmy";
        public static const SEND_ARMY_NEW_COMBAT:String = "SendArmyNewCombat";
        public static const EXPEDITION_ITEM_string:String = "ExpeditionItem";
        public static const ICON_MULTILINE:String = "IconMultiline";
        public static const MOVE_BUILDING_string:String = "MoveBuilding";
        public static const TRACKED_MISSION_string:String = "TrackedMission";
        public static const COLLECTIBLE_MISSING_RESOURCES_string:String = "CollectibleMissingResources";
        public static const MISSING_RESOURCES_string:String = "MissingResources";
        public static const ADVENT_CALENDAR_DOOR_string:String = "AdventCalendarDoor";
        public static const PVP_LEVEL_UNLOCK_string:String = "PvPLevelUnlock";
        public static const ZONE_BUFF_string:String = "ZoneBuffs";
        public static const ADVENTURE_string:String = "Adventure";
        public static const COST_string:String = "Cost";
        public static const SKILL_LIST_string:String = "SkillList";
        public static const SKILL_string:String = "Skill";
        public static const EPIC_WORKYARD_DETAILS_string:String = "EpicWorkyardDetails";
        public static const PVP_LEVEL_REWARDS_TOOLTIP_string:String = "PvPLevelRewards";
        public static const PVP_XP:String = "PvPXP";
        public static const BUILDINGHITPOINTS_string:String = "BuildingHitpoints";
        private static var inGameTipType:String;
        private static var inGameTipData:Object;
        private static var cache:Object = new Object();

        private var dummy30:AdventCalendarDoorTip;
        private var dummy31:ExpeditionItemTip;
        private var dummy32:SendArmyNewCombatTip;
        private var dummy1:SimpleTip;
        private var dummy2:BuildingsListTip;
        private var dummy3:UpgradeBuildingTip;
        private var dummy4:DemolishBuildingTip;
        private var dummy5:BuildQueueItemTip;
        private var dummy6:PopulationOverviewTip;
        private var dummy7:MilitaryUnitTip;
        private var dummy8:ShopItemTip;
        private var dummy9:SpecialistTip;
        private var dummy37:PvPLevelUnlockTip;
        private var dummy34:MilitaryUnitCondensedTip;
        private var dummy36:PvPLevelRewardsTip;
        private var dummy38:PvPXPTip;
        private var dummy40:MilitaryUnitSkillTip;
        private var dummy42:BuildingHitpointsTip;
        private var dummy35:MilitaryUnitVerboseTip;
        private var dummy39:ZoneBuffsTip;
        private var dummy41:MilitaryUnitGeneralTip;
        private var dummy10:SimpleErrorTip;
        private var dummy11:BuffTip;
        private var dummy12:MultilineTip;
        private var dummy13:InstantBuildTip;
        private var dummy14:TimedProductionOrderTip;
        private var dummy15:ProductionDurationTip;
        private var dummy16:SendArmyTip;
        private var dummy17:MilitaryUnitExtendedTip;
        private var dummy18:IconMultilineTip;
        private var dummy19:MoveBuildingTip;
        private var dummy20:TrackedMissionTip;
        private var dummy21:ShopItemWithCostsTip;
        private var dummy22:DepositTip;
        private var dummy23:CostTip;
        private var dummy24:SkillListTip;
        private var dummy25:SkillTip;
        private var dummy26:EpicWorkyardDetailsTip;
        private var dummy27:CollectibleMissingResourcesTip;
        private var dummy28:MissingResourcesTip;
        private var dummy29:AdventureTip;


        public static function clearInGameToolTip():void
        {
            inGameTipType = null;
            inGameTipData = null;
            global.getApplication().isoengine.removeEventListener(ToolTipEvent.TOOL_TIP_CREATE, inGameTipHandler);
            global.getApplication().isoengine.toolTip = "";
        }

        public static function positionActionBarTip(_arg_1:ToolTipEvent):void
        {
            var _local_2:UIComponent = (_arg_1.currentTarget as UIComponent);
            var _local_3:Point = new Point();
            _local_3 = _local_2.contentToGlobal(_local_3);
            _arg_1.toolTip.x = (_local_3.x + Math.floor(((_local_2.width - _arg_1.toolTip.width) / 2)));
            _arg_1.toolTip.y = (_local_3.y - 25);
        }

        public static function showInGameToolTip(_arg_1:String, _arg_2:String, _arg_3:Object=null):void
        {
            var _local_5:IDataToolTip;
            inGameTipType = _arg_1;
            inGameTipData = _arg_3;
            if (!global.getApplication().isoengine.hasEventListener(ToolTipEvent.TOOL_TIP_CREATE))
            {
                global.getApplication().isoengine.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, inGameTipHandler);
            };
            var _local_4:* = (("GUI.Components.ToolTips." + _arg_1) + "Tip");
            if (cache[_local_4])
            {
                cache[_local_4].text = _arg_2;
                _local_5 = (cache[_local_4] as IDataToolTip);
                if (_local_5)
                {
                    _local_5.toolTipData = _arg_3;
                };
            };
            global.getApplication().isoengine.toolTip = "";
            global.getApplication().isoengine.toolTip = _arg_2;
        }

        private static function inGameTipHandler(_arg_1:ToolTipEvent):void
        {
            createToolTip(inGameTipType, _arg_1, inGameTipData);
        }

        private static function fixPosition(_arg_1:Event):void
        {
            var _local_2:UIComponent = (_arg_1.currentTarget as UIComponent);
            if ((_local_2.x + _local_2.width) > _local_2.stage.stageWidth)
            {
                _local_2.x = (_local_2.stage.stageWidth - _local_2.width);
            };
            if (_local_2.x < 0)
            {
                _local_2.x = 0;
            };
            if (_local_2.y < 0)
            {
                _local_2.y = 0;
            };
            if ((_local_2.y + _local_2.height) > _local_2.stage.stageHeight)
            {
                _local_2.y = (_local_2.stage.stageHeight - _local_2.height);
            };
        }

        public static function createToolTip(_arg_1:String, _arg_2:ToolTipEvent, _arg_3:Object=null):void
        {
            var _local_6:Class;
            var _local_4:* = (("GUI.Components.ToolTips." + _arg_1) + "Tip");
            var _local_5:IToolTip = (cache[_local_4] as IToolTip);
            if (!_local_5)
            {
                _local_6 = (getDefinitionByName(_local_4) as Class);
                _local_5 = new (_local_6)();
                _local_5.addEventListener(Event.RESIZE, fixPosition);
                cache[_local_4] = _local_5;
            };
            if ((_local_5 is IDataToolTip))
            {
                (_local_5 as IDataToolTip).toolTipData = _arg_3;
            };
            _arg_2.toolTip = _local_5;
        }


    }
}
