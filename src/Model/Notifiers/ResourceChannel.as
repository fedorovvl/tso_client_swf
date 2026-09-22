package Model.Notifiers
{
    import Utils.Pair;

    public class ResourceChannel extends Channel 
    {

        public static const GUILDBANK_DONATED_string:String = "guildbank_donation";
        public static const EVENT_DONATED_string:String = "event_donation";
        public static const DEPOSIT_CHANGED_AMOUNT_string:String = "depositChangedAmount";


        public function eventDonated(_arg_1:String, _arg_2:int):void
        {
            var _local_3:Pair = new Pair(_arg_1, _arg_2);
            send(EVENT_DONATED_string, _local_3);
        }

        public function guildbankDonated(_arg_1:String, _arg_2:int):void
        {
            var _local_3:Pair = new Pair(_arg_1, _arg_2);
            send(GUILDBANK_DONATED_string, _local_3);
        }


    }
}
