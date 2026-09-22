package Effects
{
    import Model.Observer;
    import Communication.VO.EffectVO;
    import Model.Notifier;

    public class GUIReaction implements Observer 
    {

        private var effect:Effect;

        public function GUIReaction(_arg_1:Effect)
        {
            super();
            this.effect = _arg_1;
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:EffectVO = this.effect.effect.clone();
            if ((_arg_1 is EffectEnricher))
            {
                EffectEnricher(_arg_1).enrichEffect(this.effect.effect);
            };
            if ((_arg_3 is EffectEnricher))
            {
                EffectEnricher(_arg_3).enrichEffect(this.effect.effect);
            };
            this.effect.apply();
            this.effect.effect = _local_4;
        }


    }
}
