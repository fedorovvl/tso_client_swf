package Communication.VO
{
    import mx.collections.ArrayCollection;
    import GO.cBuilding;

    public class dBuildingVO 
    {

        public var buildingProgress:Number = 0;
        public var preCombatTipType:String;
        public var recurringChance:int;
        public var upgradeProgress:int = 0;
        public var upgradeStartTime:Number = 0;
        public var minProductionLevel:int;
        public var buildingGrid:int;
        public var destructionTime:Number = 0;
        public var buildingCreationTime:Number = 0;
        public var initialSetOnXMLMap:Boolean;
        public var offsetX:int;
        public var origin:int;
        public var lastRepairTime:Number = 0;
        public var recoveringHitPoints:int = 0;
        public var isEngagedInCombat:Boolean;
        public var offsetY:int;
        public var isBought:Boolean;
        public var playerID:int;
        public var upgradeLevel:int = 0;
        public var hitPoints:int = 0;
        public var isProductionActive:Boolean;
        public var startWorkCounter:int = 0;
        public var buildingName_string:String = null;
        public var campType:int = 0;
        public var specialCombatPreviewVO:dSpecialCombatPreviewVO;
        public var upgradeIsInProgress:Boolean;
        public var skin:String = null;
        public var buildingMode:int = 0;

        public var uniqueId:dUniqueID = new dUniqueID();
        public var armyVO:dArmyVO = new dArmyVO();
        public var buffs:ArrayCollection = new ArrayCollection();


        public function clone():dBuildingVO
        {
            var _local_1:dBuildingVO = new dBuildingVO();
            _local_1.playerID = this.playerID;
            _local_1.buildingCreationTime = this.buildingCreationTime;
            _local_1.buildingName_string = this.buildingName_string;
            _local_1.buildingGrid = this.buildingGrid;
            _local_1.buildingMode = this.buildingMode;
            _local_1.startWorkCounter = this.startWorkCounter;
            _local_1.upgradeLevel = this.upgradeLevel;
            _local_1.hitPoints = this.hitPoints;
            _local_1.lastRepairTime = this.lastRepairTime;
            _local_1.recoveringHitPoints = this.recoveringHitPoints;
            _local_1.initialSetOnXMLMap = this.initialSetOnXMLMap;
            _local_1.isBought = this.isBought;
            _local_1.isProductionActive = this.isProductionActive;
            _local_1.buildingProgress = this.buildingProgress;
            _local_1.upgradeIsInProgress = this.upgradeIsInProgress;
            _local_1.upgradeStartTime = this.upgradeStartTime;
            _local_1.upgradeProgress = this.upgradeProgress;
            _local_1.destructionTime = this.destructionTime;
            _local_1.offsetX = this.offsetX;
            _local_1.offsetY = this.offsetY;
            _local_1.origin = this.origin;
            _local_1.isEngagedInCombat = this.isEngagedInCombat;
            _local_1.preCombatTipType = this.preCombatTipType;
            _local_1.minProductionLevel = this.minProductionLevel;
            _local_1.campType = this.campType;
            _local_1.armyVO = this.armyVO;
            return (_local_1);
        }

        public function toString():String
        {
            var _local_1:* = "<dBuildingVO \n";
            _local_1 = (_local_1 + ((" playerID='" + this.playerID) + "'\n"));
            _local_1 = (_local_1 + ((" buildingCreationTime='" + this.buildingCreationTime) + "'\n"));
            _local_1 = (_local_1 + ((" buildingName_string='" + this.buildingName_string) + "'\n"));
            _local_1 = (_local_1 + ((" buildingGrid='" + this.buildingGrid) + "'\n"));
            _local_1 = (_local_1 + ((" buildingMode='" + this.buildingMode) + "'\n"));
            _local_1 = (_local_1 + ((" buildingModeString='" + cBuilding.GetBuildingModeString(this.buildingMode)) + "'\n"));
            _local_1 = (_local_1 + ((" startWorkCounter='" + this.startWorkCounter) + "'\n"));
            _local_1 = (_local_1 + ((" upgradeLevel='" + this.upgradeLevel) + "'\n"));
            _local_1 = (_local_1 + ((" hitPoints='" + this.hitPoints) + "'\n"));
            _local_1 = (_local_1 + ((" lastRepairTime='" + this.lastRepairTime) + "'\n"));
            _local_1 = (_local_1 + ((" recoveringHitPoints='" + this.recoveringHitPoints) + "'\n"));
            _local_1 = (_local_1 + ((" initialSetOnXMLMap='" + this.initialSetOnXMLMap) + "'\n"));
            _local_1 = (_local_1 + ((" isBought='" + this.isBought) + "'\n"));
            _local_1 = (_local_1 + ((" isProductionActive='" + this.isProductionActive) + "'\n"));
            _local_1 = (_local_1 + ((" buildingProgress='" + this.buildingProgress) + "'\n"));
            _local_1 = (_local_1 + ((" upgradeIsInProgress='" + this.upgradeIsInProgress) + "'\n"));
            _local_1 = (_local_1 + ((" upgradeStartTime='" + this.upgradeStartTime) + "'\n"));
            _local_1 = (_local_1 + ((" upgradeProgress='" + this.upgradeProgress) + "'\n"));
            _local_1 = (_local_1 + ((" destructionTime='" + this.destructionTime) + "'\n"));
            _local_1 = (_local_1 + ((" offsetX='" + this.offsetX) + "'\n"));
            _local_1 = (_local_1 + ((" offsetY='" + this.offsetY) + "'\n"));
            _local_1 = (_local_1 + ((" origin='" + this.origin) + "'\n"));
            _local_1 = (_local_1 + ((" isEngagedInCombat='" + this.isEngagedInCombat) + "'\n"));
            _local_1 = (_local_1 + ((" preCombatTipType='" + this.preCombatTipType) + "'\n"));
            _local_1 = (_local_1 + ((" minProductionLevel='" + this.minProductionLevel) + "'\n"));
            _local_1 = (_local_1 + ((" campType='" + this.campType) + "'\n"));
            _local_1 = (_local_1 + ">\n");
            _local_1 = (_local_1 + this.armyVO.toString());
            return (_local_1 + "</dBuildingVO>");
        }


    }
}
