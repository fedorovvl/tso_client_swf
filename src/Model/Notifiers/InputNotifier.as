package Model.Notifiers
{
    import Model.Notifier;
    import mx.core.Application;
    import flash.events.MouseEvent;
    import GUI.Components.StandardButton;
    import flash.display.DisplayObject;
    import Communication.VO.InputVO;
    import flash.events.KeyboardEvent;

    public final class InputNotifier extends Notifier 
    {

        public static const CAMERA_CHANGED_string:String = "cameraChanged";


        public function init():void
        {
            Application.application.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.notifyHandler);
        }

        protected function notifyHandler(_arg_1:MouseEvent):void
        {
            if (((_arg_1.target is StandardButton) && (_arg_1.target.enabled == false)))
            {
                return;
            };
            var _local_2:String = global.getApplication().getGUIAdress((_arg_1.target as DisplayObject));
            notifyPropertyObserver("click", _local_2);
        }

        public function input(_arg_1:InputVO):void
        {
            notifyPropertyObserver(_arg_1.action, _arg_1.input);
        }

        protected function notifyKeyHandler(_arg_1:KeyboardEvent):void
        {
            notifyPropertyObserver(_arg_1.type, _arg_1.keyCode);
        }

        public function notifyClick(_arg_1:String):void
        {
            notifyPropertyObserver("click", _arg_1);
        }


    }
}
