package Model.Notifiers
{
    public final class TickChannel extends Channel 
    {

        public static const GAME_TICK:String = "GAME_TICK";
        public static const RENDER_TICK:String = "RENDER_TICK";
        public static const DELAYED_COMPUTE_TICK:String = "DELAYED_COMPUTE_TICK";


        public function delayedCompute():void
        {
            send(DELAYED_COMPUTE_TICK, null);
        }

        public function tick(_arg_1:Number):void
        {
            send(GAME_TICK, _arg_1);
        }

        public function render():void
        {
            send(RENDER_TICK, null);
        }


    }
}
