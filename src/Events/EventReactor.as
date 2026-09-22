package Events
{
    import Trigger.Triggerable;
    import __AS3__.vec.Vector;
    import Communication.VO.EffectVO;
    import Trigger.TriggerFactory;
    import Effects.EffectFactory;
    import Communication.VO.TriggerVO;
    import Trigger.Trigger;
    import Interface.cGameInterface;
    import __AS3__.vec.*;

    public class EventReactor implements Triggerable 
    {

        private var effects_vector:Vector.<EffectVO> = new Vector.<EffectVO>();
        private var triggerFactory:TriggerFactory;
        private var effectFactory:EffectFactory;
        public var eventName_string:String;
        private var triggerVO:TriggerVO;
        private var _trigger:Trigger;

        public function EventReactor(_arg_1:cGameInterface, _arg_2:EventReactorVO, _arg_3:String)
        {
            super();
            this.effects_vector = _arg_2.effects_vector;
            this.triggerVO = _arg_2.triggerVO;
            this.eventName_string = _arg_3;
            this.effectFactory = _arg_1.effectFactory;
            this.triggerFactory = new TriggerFactory(_arg_1);
            this._trigger = this.triggerFactory.createTrigger(this.triggerVO, this);
        }

        public function dispose():void
        {
            if (this._trigger != null)
            {
                this._trigger.dispose();
            };
            this._trigger = null;
        }

        public function reset():void
        {
            this.dispose();
            this._trigger = this.triggerFactory.createTrigger(this.triggerVO, this);
        }

        public function trigger(_arg_1:Trigger):void
        {
            var _local_2:EffectVO;
            if (this.effects_vector != null)
            {
                for each (_local_2 in this.effects_vector)
                {
                    this.effectFactory.createEffect(_local_2).apply();
                };
                this.reset();
            };
        }


    }
}
