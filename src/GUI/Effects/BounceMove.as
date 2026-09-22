package GUI.Effects
{
    import mx.effects.Move;
    import mx.effects.IEffectInstance;
    import mx.events.EffectEvent;

    public class BounceMove extends Move 
    {

        private var reversed:Boolean = false;
        public var bounceCount:Number = 0;
        private var _currentBounceCount:Number = 0;
        private var ending:Boolean = true;

        public function BounceMove(_arg_1:Object=null)
        {
            super(_arg_1);
        }

        override protected function effectEndHandler(_arg_1:EffectEvent):void
        {
            var _local_2:IEffectInstance = _arg_1.effectInstance;
            if ((((!(this.ending)) && ((this._currentBounceCount <= (this.bounceCount + 1)) || (this.bounceCount == -1))) || (!(this.reversed))))
            {
                this.playAgain(this.targets, (!(this.reversed)));
            }
            else
            {
                this._currentBounceCount = 0;
                super.effectEndHandler(_arg_1);
                super.end(_arg_1.effectInstance);
            };
        }

        override public function end(_arg_1:IEffectInstance=null):void
        {
            this.ending = true;
        }

        private function playAgain(_arg_1:Array=null, _arg_2:Boolean=false):Array
        {
            this._currentBounceCount++;
            this.reversed = _arg_2;
            return (super.play(_arg_1, _arg_2));
        }

        public function get currentBounceCount():Number
        {
            return (this._currentBounceCount);
        }

        override public function play(_arg_1:Array=null, _arg_2:Boolean=false):Array
        {
            if (this._currentBounceCount > 0)
            {
                this._currentBounceCount = 0;
                return (null);
            };
            this.ending = false;
            this._currentBounceCount++;
            this.reversed = _arg_2;
            return (super.play(_arg_1, _arg_2));
        }

        public function get ended():Boolean
        {
            return (this.ending);
        }


    }
}
