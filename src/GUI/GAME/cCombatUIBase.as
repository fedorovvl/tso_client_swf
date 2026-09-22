package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import GO.cBuilding;
    import Specialists.cSpecialist;
    import MilitarySystem.cArmy;

    public class cCombatUIBase extends cGuiBaseElement 
    {

        public static const MODE_NORMAL:int = 0;
        public static const MODE_PRE_ATTACK:int = 1;
        public static const MODE_SELECT_UNIT:int = 2;

        public var mMode:int;


        public function SetData(_arg_1:cBuilding, _arg_2:cSpecialist, _arg_3:cArmy, _arg_4:cArmy, _arg_5:int, _arg_6:Number):void
        {
        }

        public function SetMode(_arg_1:int):void
        {
        }


    }
}
