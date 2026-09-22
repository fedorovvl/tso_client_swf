package com.bluebyte.tso.donations
{
    import Model.Notifier;
    import flash.utils.Dictionary;
    import mx.collections.ArrayCollection;
    import Communication.VO.EventDonationPhaseVO;
    import Utils.DictionaryUtils;
    import Communication.VO.UpdateVO.dEnabledResourceDonationsVO;
    import Enums.EVENT_DONATION_PHASE_STATE;

    public class EventDonationController extends Notifier 
    {

        public var requiredEventName:String = "";
        public var enabledEventDonations:Dictionary = new Dictionary();
        private var phases:ArrayCollection;
        public var watchTime:uint = 30000;


        public function getPhase(_arg_1:int):EventDonationPhaseVO
        {
            var _local_2:EventDonationPhaseVO;
            for each (_local_2 in this.phases)
            {
                if (_local_2.phase == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function update(_arg_1:dEnabledResourceDonationsVO):void
        {
            this.enabledEventDonations = DictionaryUtils.fromObject(_arg_1.resources);
            this.phases = _arg_1.phases;
        }

        public function getPhaseRemaining(_arg_1:int, _arg_2:Boolean):int
        {
            var _local_3:EventDonationPhaseVO = this.getPhase(_arg_1);
            if (_local_3)
            {
                if (!_arg_2)
                {
                    return (_local_3.limit - _local_3.current);
                };
                if (_local_3.state == EVENT_DONATION_PHASE_STATE.FINISHED_FAILED)
                {
                    return (0);
                };
            };
            return (1);
        }

        public function getPhaseTotal(_arg_1:int):int
        {
            var _local_2:EventDonationPhaseVO = this.getPhase(_arg_1);
            if (_local_2)
            {
                return (_local_2.limit);
            };
            return (1);
        }


    }
}
