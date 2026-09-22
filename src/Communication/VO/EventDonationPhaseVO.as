package Communication.VO
{
    import Enums.EVENT_DONATION_PHASE_STATE;

    public class EventDonationPhaseVO 
    {

        public var state:int;
        public var current:Number;
        public var limit:Number;
        public var phase:int;


        public function isReached():Boolean
        {
            return (((this.state == EVENT_DONATION_PHASE_STATE.FINISHED_REACHED) || (this.state == EVENT_DONATION_PHASE_STATE.ONGOING_REACHED)) || (this.current >= this.limit));
        }


    }
}
