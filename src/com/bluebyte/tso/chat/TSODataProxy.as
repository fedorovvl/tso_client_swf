package com.bluebyte.tso.chat
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;

    public class TSODataProxy extends Proxy 
    {

        public static const NAME:String = "TSODataProxy";

        private var _playerTag:String;

        public function TSODataProxy()
        {
            super(NAME);
        }

        public function get playerTag():String
        {
            return (this._playerTag);
        }

        public function set playerTag(_arg_1:String):void
        {
            this._playerTag = _arg_1;
        }


    }
}
