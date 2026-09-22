package MilitarySystem
{
    import Communication.VO.CombatSlotVO;

    public class cCombatSlot 
    {

        private var mSquad:cSquad = null;
        private var mHitPointsLeft:Number = 0;

        public function cCombatSlot(_arg_1:cSquad)
        {
            super();
            this.mSquad = _arg_1;
        }

        public static function Create(_arg_1:cSquad, _arg_2:int):cCombatSlot
        {
            var _local_3:cCombatSlot = new cCombatSlot(_arg_1);
            _local_3.SetHitPointsLeft((_arg_1.GetUnitData().GetHitPoints() * _arg_2));
            return (_local_3);
        }

        public static function CreateFromVO(_arg_1:CombatSlotVO, _arg_2:cSquad):cCombatSlot
        {
            var _local_3:cCombatSlot;
            if (_arg_1 != null)
            {
                _local_3 = new cCombatSlot(_arg_2);
                _local_3.SetHitPointsLeft(_arg_1.hitPointsLeft);
            };
            return (_local_3);
        }


        public function SetHitPointsLeft(_arg_1:Number):void
        {
            this.mHitPointsLeft = _arg_1;
        }

        public function GetSquad():cSquad
        {
            return (this.mSquad);
        }

        public function GetHitPointsLeft():Number
        {
            return (this.mHitPointsLeft);
        }

        public function IsOccupied():Boolean
        {
            return ((!(this.IsDead())) && (!(this.GetUnitData() == null)));
        }

        public function GetUnitData():cMilitaryUnitData
        {
            return ((this.mSquad != null) ? this.mSquad.GetUnitData() : null);
        }

        public function IsDead():Boolean
        {
            return (this.GetHitPointsLeft() <= 0);
        }

        public function Reset(_arg_1:cSquad, _arg_2:int):void
        {
            this.mSquad = _arg_1;
            this.mHitPointsLeft = (this.GetUnitData().GetHitPoints() * _arg_2);
        }

        public function GetAmount():int
        {
            return (int(Math.ceil((this.GetHitPointsLeft() / this.GetUnitData().GetHitPoints()))));
        }

        public function Refill(_arg_1:int):void
        {
            var _local_2:Number = Math.max(0, (this.GetHitPointsLeft() - int((this.GetUnitData().GetHitPoints() * this.GetAmountFullHealth()))));
            if (_local_2 > 0)
            {
                _arg_1--;
            };
            this.mHitPointsLeft = ((this.GetUnitData().GetHitPoints() * _arg_1) + _local_2);
        }

        public function GetAmountFullHealth():int
        {
            return (int((this.GetHitPointsLeft() / this.GetUnitData().GetHitPoints())));
        }

        public function DecHitPointsLeft(_arg_1:Number):Number
        {
            var _local_2:Number = Math.min(_arg_1, this.mHitPointsLeft);
            this.mHitPointsLeft = (this.mHitPointsLeft - _local_2);
            return (_local_2);
        }


    }
}
