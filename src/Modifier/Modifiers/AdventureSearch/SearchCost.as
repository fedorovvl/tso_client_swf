package Modifier.Modifiers.AdventureSearch
{
    import Modifier.Modifier;
    import Specialists.cSpecialistTask;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;
    import ServerState.dResource;
    import Specialists.cSpecialistTask_FindEventZone;
    import __AS3__.vec.Vector;

    public final class SearchCost extends Modifier 
    {

        public static const xml_string:String = "searchcost";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(cSpecialistTask.TASK_START);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_5:dResource;
            var _local_6:dResource;
            if (!(_arg_1 is cSpecialistTask_FindEventZone))
            {
                return (false);
            };
            var _local_2:cSpecialistTask_FindEventZone = (_arg_1 as cSpecialistTask_FindEventZone);
            var _local_3:Vector.<dResource> = _local_2.getCosts_vector();
            var _local_4:Boolean;
            for each (_local_5 in _local_3)
            {
                if (((modifierVO.replace_string.length <= 0) || (modifierVO.replace_string == _local_5.name_string)))
                {
                    if (modifierVO.value != 0)
                    {
                        _local_5.amount = modifierVO.value;
                    };
                    _local_5.amount = int(((_local_5.amount * modifierVO.multiplier) + modifierVO.adder));
                    _local_4 = true;
                    setModified(this);
                };
            };
            if (!_local_4)
            {
                _local_6 = new dResource();
                _local_3.push(_local_6.Init(modifierVO.replace_string, modifierVO.value));
                setModified(this);
            };
            return (_local_2);
        }


    }
}
