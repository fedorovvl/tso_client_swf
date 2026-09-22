package Modifier.Modifiers.SearchDeposit
{
    import Modifier.Modifier;
    import Specialists.cSpecialistTask_FindDeposit;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;
    import GO.cDeposit;
    import nLib.cLog;
    import nLib.gMisc;

    public final class DepositCapacity extends Modifier 
    {

        public static const xml_string:String = "searchdepositcapacity";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(cSpecialistTask_FindDeposit.SEARCH_DEPOSIT_SET);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_3:cDeposit;
            var _local_2:cSpecialistTask_FindDeposit = (_arg_1 as cSpecialistTask_FindDeposit);
            if (_local_2.GetExploredDeposit() == null)
            {
                cLog.warning("Cant modify Deposit because no Deposit found");
                return (_local_2);
            };
            this.ApplyToDeposit(_local_2.GetExploredDeposit());
            for each (_local_3 in _local_2.GetExtraExploredDeposits())
            {
                this.ApplyToDeposit(_local_3);
            };
            setModified(this);
            return (_local_2);
        }

        public function ApplyToDeposit(_arg_1:cDeposit):void
        {
            var _local_2:int = _arg_1.GetMaxAmount();
            if (modifierVO.replace_string.length > 0)
            {
                _local_2 = gMisc.ParseInt(modifierVO.replace_string);
            };
            _arg_1.SetMaxAmount((Math.round(((_local_2 * modifierVO.multiplier) + modifierVO.adder)) as int));
            _arg_1.SetAmount(_arg_1.GetMaxAmount());
        }


    }
}
