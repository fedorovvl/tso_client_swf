package converted.bluebyte.tso.reaction
{
    import Model.Observer;
    import Communication.VO.ReactionListVO;
    import Interface.cGameInterface;
    import Model.Notifiers.TickChannel;
    import Enums.KILL_SWITCH;
    import Model.Notifier;

    public class ReactionManager implements Observer 
    {

        private var reactionListVO:ReactionListVO;
        private var gi:cGameInterface;
        private var canActivate:Boolean = false;
        private var reactionsList:ReactionList;

        public function ReactionManager(_arg_1:cGameInterface, _arg_2:ReactionListVO)
        {
            super();
            this.reactionListVO = _arg_2;
            this.gi = _arg_1;
            this.gi.channels.TICK.addPropertyObserver(TickChannel.DELAYED_COMPUTE_TICK, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (((this.gi.killswitch.isAccessible(KILL_SWITCH.REACTIONS)) && (this.canActivate)))
            {
                this.activate();
            }
            else
            {
                if (((this.gi.killswitch.isLocked(KILL_SWITCH.REACTIONS)) && (!(this.reactionsList == null))))
                {
                    this.dispose();
                };
            };
        }

        public function activate():void
        {
            this.canActivate = true;
            if (((this.reactionsList == null) && (this.gi.killswitch.isAccessible(KILL_SWITCH.REACTIONS))))
            {
                this.reactionsList = new ReactionList(this.gi, this.reactionListVO);
            };
        }

        public function dispose():void
        {
            if (this.reactionsList != null)
            {
                this.reactionsList.dispose();
                this.reactionsList = null;
            };
        }


    }
}
