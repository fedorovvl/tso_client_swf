package com.bluebyte.tso.ui.battle.battlecloud.definition
{
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import com.bluebyte.tso.ui.battle.battlecloud.BattleFlyoutTargetZone;
    import flash.xml.XMLNode;
    import nLib.cXML;
    import __AS3__.vec.*;

    public final class BattlegroundDefinition 
    {

        public var battleCloudTick:int = 1000;

        public var campOffset:Point = new Point();
        public var enemySpawnOrigin:Point = new Point();
        public var enemySourceList:Vector.<BattleFlyoutListDefinition> = new Vector.<BattleFlyoutListDefinition>();
        public var enemyLandingZone:BattleFlyoutTargetZone = new BattleFlyoutTargetZone();
        public var playerSpawnOrigin:Point = new Point();
        public var playerSourceList:Vector.<BattleFlyoutListDefinition> = new Vector.<BattleFlyoutListDefinition>();
        public var playerLandingZone:BattleFlyoutTargetZone = new BattleFlyoutTargetZone();
        public var battleCloud:Vector.<BattleCloudElementDefinition> = new Vector.<BattleCloudElementDefinition>();
        public var itemShadow:BattleFlyoutShadowDefinition = new BattleFlyoutShadowDefinition();

        public function BattlegroundDefinition(_arg_1:XMLNode)
        {
            var _local_3:XMLNode;
            var _local_4:XMLNode;
            var _local_5:XMLNode;
            var _local_6:XMLNode;
            var _local_7:XMLNode;
            super();
            this.campOffset.x = _arg_1.attributes["campOffsetX"];
            this.campOffset.y = _arg_1.attributes["campOffsetY"];
            var _local_2:XMLNode = cXML.getFirstChildNode(_arg_1, "enemy");
            for each (_local_3 in cXML.getAllChildNodes(_local_2))
            {
                this.enemySourceList.push(BattleFlyoutListDefinition.fromXML(_local_3));
            };
            this.enemyLandingZone.fromXML(cXML.getChildNodes(_local_2, "dropzone"));
            this.enemyLandingZone.debugRender = (String(_local_2.attributes["showDropzones"]) == "true");
            this.enemySpawnOrigin.x = _local_2.attributes["spawnX"];
            this.enemySpawnOrigin.y = _local_2.attributes["spawnY"];
            _local_4 = cXML.getFirstChildNode(_arg_1, "player");
            for each (_local_5 in cXML.getChildNodes(_local_2, "flyouts"))
            {
                this.playerSourceList.push(BattleFlyoutListDefinition.fromXML(_local_5));
            };
            this.playerLandingZone.fromXML(cXML.getChildNodes(_local_2, "dropzone"));
            this.playerLandingZone.debugRender = (String(_local_4.attributes["showDropzones"]) == "true");
            this.playerSpawnOrigin.x = _local_4.attributes["spawnX"];
            this.playerSpawnOrigin.y = _local_4.attributes["spawnY"];
            this.itemShadow.fromXML(cXML.getFirstChildNode(_arg_1, "itemShadow"));
            _local_6 = cXML.getFirstChildNode(_arg_1, "cloud");
            for each (_local_7 in cXML.getAllChildNodes(_local_6))
            {
                this.battleCloud.push(BattleCloudElementDefinition.fromXML(_local_7, true));
            };
            this.battleCloudTick = _local_6.attributes["tick"];
        }

    }
}
