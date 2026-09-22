package 
{
    import flash.events.IEventDispatcher;
    import GuiWrapper.cGuiWrapper;
    import com.bluebyte.tso.ui.bridge.NLibFlexBridgeManager;
    import com.bluebyte.tso.util.HotkeyManager;
    import flash.events.EventDispatcher;
    import mx.events.PropertyChangeEvent;
    import flash.events.Event;

    public class globalFlash implements IEventDispatcher 
    {

        public static const FPS:uint = 30;
        private static var _102715gui:cGuiWrapper = new cGuiWrapper();
        public static var nLibFlexBridgeManager:NLibFlexBridgeManager = null;
        public static var hotkeyManager:HotkeyManager;
        private static var _424460687useNewRender:Boolean = true;
        private static var _477451957mainHudBottomPos:Number = 180;
        private static var _staticBindingEventDispatcher:EventDispatcher = new EventDispatcher();

        private var _bindingEventDispatcher:EventDispatcher;

        public function globalFlash()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public static function set useNewRender(_arg_1:Boolean):void
        {
            var _local_3:IEventDispatcher;
            var _local_2:Object = globalFlash._424460687useNewRender;
            if (_local_2 !== _arg_1)
            {
                globalFlash._424460687useNewRender = _arg_1;
                _local_3 = globalFlash.staticEventDispatcher;
                if (_local_3 != null)
                {
                    _local_3.dispatchEvent(PropertyChangeEvent.createUpdateEvent(globalFlash, "useNewRender", _local_2, _arg_1));
                };
            };
        }

        public static function set gui(_arg_1:cGuiWrapper):void
        {
            var _local_3:IEventDispatcher;
            var _local_2:Object = globalFlash._102715gui;
            if (_local_2 !== _arg_1)
            {
                globalFlash._102715gui = _arg_1;
                _local_3 = globalFlash.staticEventDispatcher;
                if (_local_3 != null)
                {
                    _local_3.dispatchEvent(PropertyChangeEvent.createUpdateEvent(globalFlash, "gui", _local_2, _arg_1));
                };
            };
        }

        [Bindable(event="propertyChange")]
        public static function get gui():cGuiWrapper
        {
            return (globalFlash._102715gui);
        }

        public static function set mainHudBottomPos(_arg_1:Number):void
        {
            var _local_3:IEventDispatcher;
            var _local_2:Object = globalFlash._477451957mainHudBottomPos;
            if (_local_2 !== _arg_1)
            {
                globalFlash._477451957mainHudBottomPos = _arg_1;
                _local_3 = globalFlash.staticEventDispatcher;
                if (_local_3 != null)
                {
                    _local_3.dispatchEvent(PropertyChangeEvent.createUpdateEvent(globalFlash, "mainHudBottomPos", _local_2, _arg_1));
                };
            };
        }

        public static function get staticEventDispatcher():IEventDispatcher
        {
            return (_staticBindingEventDispatcher);
        }

        [Bindable(event="propertyChange")]
        public static function get mainHudBottomPos():Number
        {
            return (globalFlash._477451957mainHudBottomPos);
        }

        [Bindable(event="propertyChange")]
        public static function get useNewRender():Boolean
        {
            return (globalFlash._424460687useNewRender);
        }


        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }


    }
}
