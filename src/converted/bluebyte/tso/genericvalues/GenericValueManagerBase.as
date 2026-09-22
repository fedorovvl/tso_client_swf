package converted.bluebyte.tso.genericvalues
{
    import Model.Notifier;
    import Interface.cGeneralInterface;
    import Utils.HashMapWrapper;
    import Communication.VO.GenericValueVO;

    public class GenericValueManagerBase extends Notifier 
    {

        public static const UPDATED_string:String = "updated";

        protected var gi:cGeneralInterface;
        protected var genericValues:HashMapWrapper = new HashMapWrapper();

        public function GenericValueManagerBase(_arg_1:cGeneralInterface)
        {
            super();
            this.gi = _arg_1;
        }

        public function get(_arg_1:String):GenericValueVO
        {
            if (this.genericValues.hasKey(_arg_1))
            {
                return (this.genericValues.getItem(_arg_1) as GenericValueVO);
            };
            return (global.genericValuesFromName.getItem(_arg_1).clone());
        }

        public function set(_arg_1:String, _arg_2:GenericValueVO):void
        {
            this.genericValues.putItem(_arg_1, _arg_2);
            notifyPropertyObserver(UPDATED_string, _arg_2);
        }


    }
}
