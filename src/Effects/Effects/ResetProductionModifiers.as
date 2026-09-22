package Effects.Effects
{
    import Effects.Effect;
    import Interface.cGameInterface;
    import Communication.VO.EffectVO;
    import TimedProduction.cTimedProductionQueue;
    import TimedProduction.cTimedProduction;
    import TimedProduction.cAbstractTimedProductionOrder;

    public final class ResetProductionModifiers extends Effect 
    {

        public static const XML_string:String = "resetproductionmodifiers";

        private var mGI:cGameInterface;


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
            this.mGI = _arg_2;
        }

        override protected function action():void
        {
            var _local_1:cTimedProductionQueue;
            var _local_2:cTimedProduction;
            for each (_local_1 in this.mGI.mCurrentPlayerZone.GetProductionQueue_vector())
            {
                for each (_local_2 in _local_1.mTimedProductions_vector)
                {
                    _local_2.GetProductionOrder().GetProductionVO().ResetModifiers();
                    this.mGI.mCurrentPlayer.notifyPropertyObserver(cAbstractTimedProductionOrder.PRODUCTION_START, _local_2.GetProductionOrder());
                };
            };
        }


    }
}
