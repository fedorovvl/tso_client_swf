package com.bluebyte.tso.bootstrap.steps
{
    import com.bluebyte.tso.bootstrap.BootstrapStep;
    import __AS3__.vec.Vector;
    import flash.utils.ByteArray;
    import mx.core.Singleton;
    import mx.events.ModuleEvent;
    import mx.modules.IModuleInfo;
    import mx.modules.ModuleManager;
    import nLib.cXML;
    import nLib.cLog;
    import Interface.gInitStaticForAllZones;
    import com.bluebyte.tso.ui.util.KeyState;
    import Utils.RabbidCode;
    import GUI.ApplicationFacade;
    import GUI.Notifications.ApplicationNotifications;
    import GUI.Controller.dconsole.TsoConsole;

    public class StepInitialize extends BootstrapStep 
    {

        // Модуль держим статиком: локальную переменную GC съедает вместе
        // со слушателями раньше, чем Loader диспатчит события (тихий вис).
        private static var haloModule:IModuleInfo;

        [Embed(source="../../../../../../assets/theme/swmmo-theme.swf", mimeType="application/octet-stream")]
        private var SWWMOStyles:Class;


        private function prepareLoadingScreenBar():void
        {
            var _local_3:BootstrapStep;
            var _local_1:int;
            var _local_2:Vector.<BootstrapStep> = this.getBootstrap().getRemainingSteps(this);
            for each (_local_3 in _local_2)
            {
                if ((_local_3 is StepHideLoadingscreen)) break;
                _local_1 = (_local_1 + _local_3.getProgressWeight());
            };
            global.getApplication().loadingScreen.attachToBootstrap(_local_1);
        }

        override protected function execute():void
        {
            this.prepareLoadingScreenBar();
            cXML.init();
            global.getApplication().isoengine.init();
            gInitStaticForAllZones.Init(null);
            KeyState.attach(global.getApplication().stage);
            global.getApplication().checker = new RabbidCode();
            ApplicationFacade.sendNotification(ApplicationNotifications.INITIALIZE, global.getApplication());
            TsoConsole.init();
            var _bytes:ByteArray = new SWWMOStyles() as ByteArray;
            haloModule = ModuleManager.getModule("SWWMOStyles");
            haloModule.addEventListener(ModuleEvent.READY, onHaloThemeReady);
            haloModule.addEventListener(ModuleEvent.ERROR, onHaloThemeError);
            haloModule.load(null, null, _bytes);
        }

        private function onHaloThemeReady(_arg_1:ModuleEvent):void
        {
            ModuleManager.getModule("SWWMOStyles").factory.create();
            Singleton.getInstance("mx.styles::IStyleManager2").styleDeclarationsChanged();
            next(this);
        }

        private function onHaloThemeError(_arg_1:ModuleEvent):void
        {
            next(this);
        }


    }
}
