package GUI.Components
{
    import mx.controls.Button;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.Event;

    public class TwinkleButton extends Button 
    {

        private var _twinkleDuration:int = 500;
        private var _timer:Timer;
        private var _twinkle:Boolean = true;


        public function set twinkleDuration(_arg_1:int):void
        {
            this._twinkleDuration = _arg_1;
            this.InitTimer();
        }

        private function InitTimer():void
        {
            this._timer = new Timer(this._twinkleDuration);
            this._timer.addEventListener(TimerEvent.TIMER, this.SwitchSkins);
        }

        public function set twinkle(_arg_1:Boolean):void
        {
            this._twinkle = _arg_1;
            if (this._twinkle)
            {
                if (!this._timer)
                {
                    this.InitTimer();
                };
                this._timer.start();
                this.SwitchSkins();
            }
            else
            {
                if (this._timer)
                {
                    this._timer.stop();
                };
                this.selected = false;
            };
        }

        private function SwitchSkins(_arg_1:Event=null):void
        {
            this.selected = (!(this.selected));
        }

        public function get twinkle():Boolean
        {
            return (this._twinkle);
        }


    }
}
