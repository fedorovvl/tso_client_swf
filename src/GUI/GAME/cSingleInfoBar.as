package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import Model.Observer;
    import GUI.Components.ItemRenderer.InfoBarResourceItemRendererData;
    import Interface.cGameInterface;
    import GUI.Components.SingleInfoBar;
    import ServerState.cResources;
    import ServerState.dResource;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import AdventureSystem.cAdventureDefinition;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import com.bluebyte.tso.util.TimeUtil;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import MilitarySystem.cCombat;
    import Model.Notifier;
    import mx.events.FlexEvent;
    import GUI.Assets.gAssetManager;

    public class cSingleInfoBar extends cGuiBaseElement implements Observer 
    {

        private var defensePoints:InfoBarResourceItemRendererData;
        private var isColony:Boolean = true;
        private var troopLimit:InfoBarResourceItemRendererData;
        private var adventureArmy:InfoBarResourceItemRendererData;
        private var mGI:cGameInterface;
        private var recoveryPoints:InfoBarResourceItemRendererData;
        private var nextUpdate:Number = 0;
        protected var mInfoBar:SingleInfoBar;
        private var troopsDead:InfoBarResourceItemRendererData;
        private var zoneBuffs:InfoBarResourceItemRendererData;
        private var generalsLimit:InfoBarResourceItemRendererData;


        public function UpdateAll():void
        {
            var _local_2:cResources;
            var _local_3:dResource;
            var _local_4:dAdventureClientInfoVO;
            var _local_5:cAdventureDefinition;
            var _local_6:Boolean;
            var _local_7:int;
            var _local_8:int;
            var _local_1:dAdventureClientInfoVO = AdventureManager.getInstance().getAdventure(this.mGI.mCurrentViewedZoneID);
            if (_local_1)
            {
                this.isColony = ((cAdventureDefinition.FindAdventureDefinition(_local_1.adventureName).IsColony()) || (cAdventureDefinition.FindAdventureDefinition(_local_1.adventureName).IsTrainingExpedition()));
            }
            else
            {
                this.isColony = false;
            };
            this.zoneBuffs.amount = (this.mGI.mZoneBuffManager.getZoneBuffsForPersistence().length + ((((global.ui.mCurrentViewedZoneID == global.ui.mCurrentPlayer.getPlayerID()) || (global.ui.mCurrentViewedZoneID < 0)) && (global.ui.mCurrentPlayer.GetPremiumDuration() > 0)) ? 1 : 0));
            this.defensePoints.visible = this.mGI.mIsDefenseMode;
            this.troopLimit.visible = (this.generalsLimit.visible = (this.troopsDead.visible = (this.recoveryPoints.visible = ((!(this.defensePoints.visible)) && (this.isColony)))));
            this.adventureArmy.visible = (((!(this.mGI.mIsDefenseMode)) && (_local_1)) && (!(cAdventureDefinition.FindAdventureDefinition(_local_1.adventureName).IsBuffAdventure())));
            if (this.mGI.mIsDefenseMode)
            {
                _local_2 = this.mGI.mCurrentPlayerZone.getResourcesFromCurrentZone();
                if (_local_2)
                {
                    _local_3 = _local_2.GetPlayerResource(defines.DEFENSE_POINT_NAME_string);
                    if (_local_3)
                    {
                        this.defensePoints.amount = _local_3.amount;
                        this.defensePoints.glow = (_local_3.amount <= 5);
                        this.defensePoints.visible = this.mGI.mIsDefenseMode;
                    };
                };
            }
            else
            {
                if (this.nextUpdate > TimeUtil.getClientTime())
                {
                    return;
                };
                this.adventureArmy.amount = this.mGI.mCurrentPlayerZone.GetTotalUnitsOnMap(this.mGI.mCurrentPlayer.GetPlayerId());
                for each (_local_4 in AdventureManager.getInstance().getAdventures())
                {
                    _local_5 = cAdventureDefinition.FindAdventureDefinition(_local_4.adventureName);
                    _local_6 = _local_5.UsesCombatThree();
                    if (_local_6)
                    {
                        _local_7 = global.expeditionMapLevelGroupVO.CalcTroopLimit(_local_5.GetLevelRangeExpedition(), _local_4.mapLevel);
                        this.troopLimit.amount = (_local_7 - _local_4.troopLimit);
                        this.troopLimit.limit = _local_7;
                        this.troopLimit.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TroopLimitCompleteData", [this.troopLimit.amount, this.troopLimit.limit, _local_4.troopLimit]);
                        this.troopLimit.glow = (_local_4.troopLimit <= 10);
                        this.troopsDead.amount = ((_local_7 - _local_4.troopLimit) - this.mGI.mCurrentPlayerZone.GetTotalUnitsOnMap(this.mGI.mCurrentPlayer.GetPlayerId()));
                        _local_8 = global.expeditionMapLevelGroupVO.GetGeneralsLimit(_local_5.GetLevelRangeExpedition());
                        this.generalsLimit.amount = _local_4.admiralCount;
                        this.generalsLimit.limit = _local_8;
                        this.generalsLimit.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GeneralLimitCompleteData", [this.generalsLimit.amount, this.generalsLimit.limit, _local_8]);
                        this.generalsLimit.glow = false;
                        this.recoveryPoints.limit = global.expeditionMapLevelGroupVO.GetTacticPointsLimit(_local_5.GetLevelRangeExpedition());
                        this.recoveryPoints.amount = this.mGI.mCurrentPlayerZone.getResourcesFromCurrentZone().GetResourceAmount("Fish");
                        this.recoveryPoints.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TacticPointsLimitCompleteData", [this.recoveryPoints.amount, this.recoveryPoints.limit]);
                        this.nextUpdate = (TimeUtil.getClientTime() + 1000);
                        break;
                    };
                };
            };
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            switch (_arg_2)
            {
                case cCombat.SLOT_UNITS_DIED_string:
                    this.troopsDead.amount = (this.troopLimit.amount - this.mGI.mCurrentPlayerZone.GetTotalUnitsOnMap(this.mGI.mCurrentPlayer.GetPlayerId()));
                    return;
            };
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mInfoBar.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.zoneBuffs = new InfoBarResourceItemRendererData();
            this.zoneBuffs.icon = gAssetManager.GetResourceIcon("ZoneBuff");
            this.zoneBuffs.toolTip = "ZoneBuffs";
            this.troopLimit = new InfoBarResourceItemRendererData();
            this.troopLimit.icon = gAssetManager.GetResourceIcon("TroopLimit");
            this.troopLimit.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, "Military");
            this.generalsLimit = new InfoBarResourceItemRendererData();
            this.generalsLimit.icon = gAssetManager.GetResourceIcon("General");
            this.generalsLimit.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, "General");
            this.troopsDead = new InfoBarResourceItemRendererData();
            this.troopsDead.icon = gAssetManager.GetResourceIcon("Skull");
            this.troopsDead.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, "Dead");
            this.defensePoints = new InfoBarResourceItemRendererData();
            this.defensePoints.icon = gAssetManager.GetResourceIcon(defines.DEFENSE_POINT_NAME_string);
            this.defensePoints.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, defines.DEFENSE_POINT_NAME_string);
            this.defensePoints.visible = this.mGI.mIsDefenseMode;
            this.defensePoints.limit = -1;
            this.recoveryPoints = new InfoBarResourceItemRendererData();
            this.recoveryPoints.icon = gAssetManager.GetResourceIcon("Recovery");
            this.recoveryPoints.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, "Recovery");
            this.adventureArmy = new InfoBarResourceItemRendererData();
            this.adventureArmy.icon = gAssetManager.GetResourceIcon("AdventureArmy");
            this.adventureArmy.toolTip = "Population";
            this.mInfoBar.dataProvider = [this.zoneBuffs, this.troopsDead, this.troopLimit, this.generalsLimit, this.defensePoints, this.recoveryPoints, this.adventureArmy];
        }

        public function Init(_arg_1:SingleInfoBar):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mInfoBar = _arg_1;
            this.mInfoBar.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }


    }
}
