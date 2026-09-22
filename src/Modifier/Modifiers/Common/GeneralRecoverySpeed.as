package Modifier.Modifiers.Common
{
    import Modifier.Modifier;
    import Specialists.cSpecialistTask_Recover;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;

    public class GeneralRecoverySpeed extends Modifier 
    {

        public static const xml_string:String = "generalrecoveryspeed";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(cSpecialistTask_Recover.NOTIFY_STRING);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_2:cSpecialistTask_Recover = (_arg_1 as cSpecialistTask_Recover);
            if (((!(_local_2 == null)) && (!(_local_2.isModified()))))
            {
                if (modifierVO.value != 0)
                {
                    _local_2.SetNeededTime(modifierVO.value);
                };
                _local_2.SetNeededTime(Math.round(((_local_2.GetNeededTime() * modifierVO.multiplier) + modifierVO.adder)));
                _local_2.setModified(this);
                return (_local_2);
            };
            return (_arg_1);
        }


    }
}
