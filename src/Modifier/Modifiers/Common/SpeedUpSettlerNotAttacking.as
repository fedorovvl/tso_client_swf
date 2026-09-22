package Modifier.Modifiers.Common
{
    import Modifier.Modifier;
    import Specialists.cSpecialistTask_WithSettler;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;

    public class SpeedUpSettlerNotAttacking extends Modifier 
    {

        public static const xml_string:String = "speedupsettlernotattacking";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(cSpecialistTask_WithSettler.TASK_START_WITH_SETTLER);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_2:cSpecialistTask_WithSettler;
            if ((_arg_1 is cSpecialistTask_WithSettler))
            {
                _local_2 = (_arg_1 as cSpecialistTask_WithSettler);
                if (_local_2 != null)
                {
                    _local_2.nonAttackSpeed = (_local_2.speed * modifierVO.multiplier);
                    setModified(this);
                    return (_local_2);
                };
            };
            return (_arg_1);
        }


    }
}
