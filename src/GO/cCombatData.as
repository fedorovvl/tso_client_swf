package GO
{
    import MilitarySystem.cCombat;
    import GUI.Components.circularmenu.BattleGround;
    import Interface.cGeneralInterface;
    import nLib.cPosInt;
    import Specialists.cSpecialist;

    public class cCombatData 
    {

        public static const EMPTY_SLOT_STRING:String = "EmptySlot";

        private var mCombat:cCombat;
        private var grid:int = 0;
        private var mBossEnabled:Boolean = false;
        private var mEnabled:Boolean = true;
        private var battleUI:BattleGround;

        public function cCombatData(_arg_1:cGeneralInterface, _arg_2:int, _arg_3:int, _arg_4:cCombat)
        {
            super();
            this.mCombat = _arg_4;
            this.grid = _arg_3;
            this.initUI();
        }

        private function initUI():void
        {
            this.battleUI = new BattleGround();
            this.battleUI.attachToEngine();
            this.battleUI.offsetPoint = new cPosInt(global.battlegroundDefinition.campOffset.x, global.battlegroundDefinition.campOffset.y);
            this.battleUI.gridPos = this.grid;
        }

        public function GetCombat():cCombat
        {
            return (this.mCombat);
        }

        public function updateMenu(_arg_1:cSpecialist, _arg_2:cCombat):void
        {
            if (this.battleUI)
            {
                this.battleUI.updateCombat(_arg_1, _arg_2);
            };
        }

        public function IsBossEnabled():Boolean
        {
            return (this.mBossEnabled);
        }

        public function EnableBossSlot(_arg_1:String, _arg_2:int):void
        {
            this.mBossEnabled = true;
        }

        public function dispose():void
        {
            if (this.battleUI)
            {
                this.battleUI.dispose();
                this.battleUI = null;
            };
        }


    }
}
