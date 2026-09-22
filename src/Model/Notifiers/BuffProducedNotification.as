package Model.Notifiers
{
    import BuffSystem.cBuffDefinition;

    public class BuffProducedNotification 
    {

        public var amount:int;
        public var definition:cBuffDefinition;

        public function BuffProducedNotification(_arg_1:cBuffDefinition, _arg_2:int)
        {
            super();
            this.definition = _arg_1;
            this.amount = _arg_2;
        }

    }
}
