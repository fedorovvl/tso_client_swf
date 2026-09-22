package GUI
{
    import Model.Notifier;
    import Interface.IGUIBase;
    import __AS3__.vec.Vector;
    import mx.core.UIComponent;
    import flash.events.Event;
    import flash.geom.Point;
    import __AS3__.vec.*;

    public class cGuiBaseElement extends Notifier implements IGUIBase 
    {

        protected static var mGuiElements:Vector.<UIComponent> = null;
        protected static var mGuiElementsController:Vector.<cGuiBaseElement> = null;

        protected var mUiElement:UIComponent = null;


        public static function SetVisibleStateForAllGuiElements(_arg_1:Boolean):void
        {
            var _local_2:UIComponent;
            for each (_local_2 in mGuiElements)
            {
                _local_2.visible = _arg_1;
                _local_2.dispatchEvent(new Event("visibilityChanged"));
            };
        }

        public static function SetEnableStateForAllGuiElements(_arg_1:Boolean):void
        {
            var _local_2:UIComponent;
            for each (_local_2 in mGuiElements)
            {
                _local_2.enabled = _arg_1;
            };
        }

        public static function GetPanelController(_arg_1:String):cGuiBaseElement
        {
            var _local_2:int;
            var _local_3:int = mGuiElements.length;
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                if (_arg_1 == mGuiElements[_local_2].id)
                {
                    return (mGuiElementsController[_local_2] as cGuiBaseElement);
                };
                _local_2++;
            };
            return (null);
        }

        public static function GetPanel(_arg_1:String):UIComponent
        {
            var _local_2:int;
            var _local_3:int = mGuiElements.length;
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                if (_arg_1 == mGuiElements[_local_2].id)
                {
                    return (mGuiElements[_local_2] as UIComponent);
                };
                _local_2++;
            };
            return (null);
        }

        public static function InitStatic():void
        {
            mGuiElements = new Vector.<UIComponent>();
            mGuiElementsController = new Vector.<cGuiBaseElement>();
        }


        public function Hide():void
        {
            this.mUiElement.visible = false;
            notifyPropertyObserver("hide", this.mUiElement.id);
            dispatchEvent(new Event("visibilityChanged"));
        }

        public function Show():void
        {
            this.mUiElement.visible = true;
            global.ui.mQuestClientCallbacks.InitiateWindowOpen(this.mUiElement.id);
            notifyPropertyObserver("show", this.mUiElement.id);
            dispatchEvent(new Event("visibilityChanged"));
        }

        public function PositionIsOverGuiElement():Boolean
        {
            if (this.mUiElement == null)
            {
                return (false);
            };
            var _local_1:Array = this.mUiElement.getObjectsUnderPoint(new Point(global.getApplication().mouseX, global.getApplication().mouseY));
            if (_local_1.length > 0)
            {
                return (true);
            };
            return (false);
        }

        protected function AddBaseElement(_arg_1:UIComponent):void
        {
            this.mUiElement = _arg_1;
            mGuiElements.push(_arg_1);
            mGuiElementsController.push(this);
        }

        [Bindable(event="visibilityChanged")]
        public function IsVisible():Boolean
        {
            return ((this.mUiElement) && (this.mUiElement.visible));
        }

        public function SetDataByString(_arg_1:String):void
        {
        }


    }
}
