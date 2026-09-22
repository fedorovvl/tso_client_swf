package GUI.Loca
{
    import flash.events.EventDispatcher;
    import mx.modules.IModuleInfo;
    import nLib.TSOURLLoader;
    import flash.events.Event;
    import flash.events.ErrorEvent;
    import mx.modules.ModuleManager;
    import mx.core.Singleton;
    import mx.events.StyleEvent;
    import mx.events.ModuleEvent;

    public class TSOStyleLoader extends EventDispatcher 
    {

        private var errorHandler:Function;
        private var module:IModuleInfo;
        private var url:String;

        public function TSOStyleLoader(_arg_1:String, _arg_2:Function)
        {
            super();
            this.url = _arg_1;
            this.errorHandler = _arg_2;
        }

        public function load():void
        {
            var _local_1:TSOURLLoader = new TSOURLLoader();
            _local_1.addEventListener(Event.COMPLETE, this.completeURLHandler);
            _local_1.addEventListener(ErrorEvent.ERROR, this.errorHandler);
            _local_1.loadFile(this.url);
        }

        private function modReadyHandler(_arg_1:ModuleEvent):void
        {
            ModuleManager.getModule(this.url).factory.create();
            Singleton.getInstance("mx.styles::IStyleManager2").styleDeclarationsChanged();
            dispatchEvent(new Event(StyleEvent.COMPLETE));
        }

        private function completeURLHandler(_arg_1:Event):void
        {
            this.module = ModuleManager.getModule(this.url);
            this.module.addEventListener(ModuleEvent.READY, this.modReadyHandler);
            this.module.addEventListener(ModuleEvent.ERROR, this.errorHandler);
            this.module.load(null, null, (_arg_1.currentTarget as TSOURLLoader).data);
        }


    }
}
