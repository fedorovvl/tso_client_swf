package Modifier.Modifiers.SearchDeposit
{
    import Modifier.Modifier;
    import Specialists.cSpecialistTask;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;
    import Specialists.cSpecialistTask_FindDeposit;

    public final class FailoverGroupID extends Modifier 
    {

        public static const xml_string:String = "failovergroupid";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(cSpecialistTask.TASK_START);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_2:cSpecialistTask_FindDeposit = (_arg_1 as cSpecialistTask_FindDeposit);
            _local_2.failOverrideDepositGroupID = modifierVO.value;
            setModified(this);
            return (_local_2);
        }


    }
}
