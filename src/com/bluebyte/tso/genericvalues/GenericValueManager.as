package com.bluebyte.tso.genericvalues
{
    import converted.bluebyte.tso.genericvalues.GenericValueManagerBase;
    import Interface.cGeneralInterface;
    import Communication.VO.GenericValueVO;
    import mx.collections.ArrayCollection;

    public class GenericValueManager extends GenericValueManagerBase 
    {

        public static const UPDATED_string:String = "updated";

        public function GenericValueManager(_arg_1:cGeneralInterface)
        {
            super(_arg_1);
        }

        public function updateFrom(_arg_1:ArrayCollection):void
        {
            var _local_2:GenericValueVO;
            genericValues.clear();
            for each (_local_2 in _arg_1)
            {
                genericValues.putItem(_local_2.name, _local_2);
            };
        }

        public function getAll():ArrayCollection
        {
            return (new ArrayCollection(genericValues.valueSet()));
        }


    }
}
