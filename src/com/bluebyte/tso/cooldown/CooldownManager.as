package com.bluebyte.tso.cooldown
{
    import converted.bluebyte.tso.cooldown.CooldownManagerBase;
    import Interface.cGeneralInterface;
    import Communication.VO.CooldownVO;
    import mx.collections.ArrayCollection;

    public class CooldownManager extends CooldownManagerBase 
    {

        public function CooldownManager(_arg_1:cGeneralInterface)
        {
            super(_arg_1);
        }

        public function updateFromList(_arg_1:ArrayCollection):void
        {
            var _local_2:CooldownVO;
            cooldowns.clear();
            for each (_local_2 in _arg_1)
            {
                cooldowns.putItem(_local_2.id, _local_2);
            };
        }

        public function getList():ArrayCollection
        {
            return (new ArrayCollection(this.cooldowns.valueSet()));
        }


    }
}
