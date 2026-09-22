package Tracks
{
    import Model.Observer;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import mx.core.Application;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import Model.Notifier;
    import flash.events.Event;

    public class IdleDetection implements Observer 
    {

        private var start:Number = 0;
        private var timer:Timer = new Timer(60000);

        public function IdleDetection()
        {
            super();
            this.timer.start();
            this.timer.addEventListener(TimerEvent.TIMER, this.startCountingIdleTime);
            Application.application.addEventListener(MouseEvent.MOUSE_MOVE, this.stopTimer);
            Application.application.addEventListener(MouseEvent.MOUSE_DOWN, this.stopTimer);
            Application.application.addEventListener(MouseEvent.MOUSE_UP, this.stopTimer);
            Application.application.addEventListener(KeyboardEvent.KEY_DOWN, this.stopTimer);
            Application.application.addEventListener(KeyboardEvent.KEY_UP, this.stopTimer);
            TrackManager.getInstance().addPropertyObserver(TrackManager.FLUSH_EVENT, this);
        }

        private function startCountingIdleTime(_arg_1:TimerEvent):void
        {
            if (this.start == 0)
            {
                this.start = new Date().getTime();
            };
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.trackIdle(true);
        }

        private function stopTimer(_arg_1:Event):void
        {
            this.trackIdle(false);
        }

        private function trackIdle(_arg_1:Boolean):void
        {
            var _local_2:Number = new Date().getTime();
            if (this.start != 0)
            {
                TrackManager.getInstance().trackUI(global.ui.mCurrentPlayer.GetPlayerId(), "UI Idle Time", null, ((_local_2 - this.start) / 1000), true);
                if (_arg_1)
                {
                    this.start = _local_2;
                }
                else
                {
                    this.timer.stop();
                    this.timer.start();
                    this.start = 0;
                };
            };
        }


    }
}
