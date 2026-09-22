package Modifier.Modifiers.Common
{
    import Modifier.Modifier;
    import Specialists.cSpecialistTask;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;

    public final class SearchTime extends Modifier 
    {

        public static const xml_string:String = "searchtime";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(cSpecialistTask.TASK_START);
            registerPropertySignal(cSpecialistTask.TASK_RUNNING_UPDATE);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_2:cSpecialistTask = (_arg_1 as cSpecialistTask);
            var _local_3:int = _local_2.GetNeededTime();
            if (modifierVO.value != 0)
            {
                _local_3 = modifierVO.value;
            };
            _local_2.SetNeededTime(int(((_local_3 * modifierVO.multiplier) + modifierVO.adder)));
            setModified(this);
            return (_local_2);
        }


    }
}
