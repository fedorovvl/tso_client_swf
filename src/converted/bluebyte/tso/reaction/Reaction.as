package converted.bluebyte.tso.reaction
{
    import Trigger.Triggerable;
    import Model.Observer;
    import Interface.cGameInterface;
    import Communication.VO.ReactionVO;
    import Trigger.TriggerList;
    import Model.Notifiers.TickChannel;
    import nLib.cLog;
    import Effects.EffectList;
    import Model.Notifier;
    import Trigger.Trigger;

    public class Reaction implements Triggerable, Observer 
    {

        private var gi:cGameInterface;
        private var vo:ReactionVO;
        private var triggers:TriggerList = null;

        public function Reaction(_arg_1:cGameInterface, _arg_2:ReactionVO)
        {
            super();
            this.vo = _arg_2;
            this.gi = _arg_1;
            this.triggers = new TriggerList(this, _arg_2.triggers, _arg_1);
            this.check();
        }

        public function check():void
        {
            this.triggers.check();
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.gi.channels.TICK.removePropertyObserver(TickChannel.GAME_TICK, this);
            if (cLog.isInfoEnabled())
            {
                cLog.info(("Reaction triggered: " + this.vo.toString()));
            };
            EffectList.apply(this.vo.effects, this.gi);
            this.reset();
        }

        public function reset():void
        {
            this.triggers.reset();
        }

        public function trigger(_arg_1:Trigger):void
        {
            this.gi.channels.TICK.addPropertyObserver(TickChannel.GAME_TICK, this);
        }

        public function dispose():void
        {
            if (this.triggers != null)
            {
                this.triggers.dispose();
            };
            this.triggers = null;
            this.vo = null;
            this.gi = null;
        }


    }
}
