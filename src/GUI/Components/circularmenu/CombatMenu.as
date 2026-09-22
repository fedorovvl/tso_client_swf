package GUI.Components.circularmenu
{
    import Utils.Disposable;
    import MilitarySystem.cSquad;
    import Specialists.cSpecialist;
    import GUI.Components.ToolTips.cToolTipUtil;
    import mx.events.ToolTipEvent;
    import mx.collections.ArrayCollection;
    import MilitarySystem.cCombatSlot;

    public class CombatMenu extends CircleMenu implements Disposable 
    {

        private var upcomingUnit:cSquad;
        private var specialist:cSpecialist;
        private var substractAmount:int = 0;
        private var selectedUnit:cSquad;

        public function CombatMenu()
        {
            super();
            addEventListener(CircleSlotEvent.SLOT_CLICKED, this.slotClickedHandler);
        }

        private function slotClickedHandler(_arg_1:CircleSlotEvent):void
        {
            var _local_3:String;
            var _local_2:BattleGroundUnitData = (_arg_1.data as BattleGroundUnitData);
            if (((this.specialist) && (_local_2)))
            {
                _local_3 = _local_2.toolTip;
                global.services.combat.selectNextUnit(this.specialist, _local_3);
                close();
                this.selectedUnit = this.specialist.GetArmy().GetSquad(_local_3);
            };
        }

        public function dispose():void
        {
            this.specialist = null;
            this.selectedUnit = null;
            this.upcomingUnit = null;
        }

        override protected function slotToolTipCreateHandler(_arg_1:ToolTipEvent):void
        {
            cToolTipUtil.createToolTip(cToolTipUtil.MILITARY_UNIT_CONDENSED_string, _arg_1);
        }

        override protected function centerToolTipCreateHandler(_arg_1:ToolTipEvent):void
        {
            this.slotToolTipCreateHandler(_arg_1);
        }

        public function update(_arg_1:cSpecialist, _arg_2:cSquad, _arg_3:int, _arg_4:cCombatSlot):void
        {
            var _local_6:cSquad;
            var _local_7:BattleGroundUnitData;
            var _local_8:BattleGroundUnitData;
            this.substractAmount = this.substractAmount;
            this.specialist = _arg_1;
            this.upcomingUnit = _arg_2;
            var _local_5:ArrayCollection = new ArrayCollection();
            if (_arg_1)
            {
                for each (_local_6 in _arg_1.GetArmy().GetSquads_vector())
                {
                    _local_7 = BattleGroundUnitData.fromSquadVO(_local_6);
                    if (_local_6.GetType() == _arg_4.GetUnitData().GetType())
                    {
                        _local_7.amount = (_local_7.amount - _arg_4.GetAmount());
                    };
                    if (((!(_arg_2 == null)) && (_local_6.GetType() == _arg_2.GetType())))
                    {
                        _local_8 = BattleGroundUnitData.fromSquadVO(_local_6);
                        _local_8.amount = _local_7.amount;
                        center.data = _local_8;
                    };
                    if (_local_7.amount > 0)
                    {
                        _local_5.addItem(_local_7);
                    };
                };
            };
            dataProvider = _local_5;
        }

        public function resetSelection():void
        {
            this.selectedUnit = this.upcomingUnit;
        }


    }
}
