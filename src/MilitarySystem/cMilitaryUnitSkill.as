package MilitarySystem
{
    import Enums.MILLITARY_UNIT_SKILLS;

    public class cMilitaryUnitSkill 
    {

        private var mType:int;
        private var mData:int;

        public function cMilitaryUnitSkill(_arg_1:int, _arg_2:int)
        {
            super();
            this.mType = _arg_1;
            this.mData = _arg_2;
        }

        public function GetType():int
        {
            return (this.mType);
        }

        public function toString():String
        {
            return (((("<Skill " + MILLITARY_UNIT_SKILLS.toString(this.mType)) + ", data=") + this.mData) + ">");
        }

        public function GetData():int
        {
            return (this.mData);
        }


    }
}
