package Effects
{
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import Trigger.TriggerList;
    import nLib.cLog;

    public class Effect 
    {

        public static const XML_string:String = "effect";

        public var effect:EffectVO;
        protected var gi:cGameInterface;
        public var applyAsGameTick:Boolean = true;


        public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            this.gi = _arg_2;
            this.effect = _arg_1;
        }

        final public function apply():void
        {
            if (TriggerList.instantCheck(this.effect.conditions, this.gi))
            {
                this.action();
                if (cLog.isInfoEnabled())
                {
                };
            };
        }

        final public function gameTickApply():void
        {
            if (this.applyAsGameTick)
            {
                this.apply();
            };
        }

        final public function applyControlled():void
        {
            if (this.effect.clientOnly)
            {
                this.apply();
            };
        }

        protected function action():void
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info(("Empty Effect apply. Please Override action()!  Effect:" + this.effect.effect_string));
            };
        }


    }
}
