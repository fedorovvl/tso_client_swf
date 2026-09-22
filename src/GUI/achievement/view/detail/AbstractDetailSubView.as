package GUI.achievement.view.detail
{
    import Utils.Disposable;
    import flash.display.DisplayObject;
    import mx.events.FlexEvent;
    import flash.display.DisplayObjectContainer;

    public class AbstractDetailSubView implements Disposable 
    {

        protected var viewComponent:DisplayObject;
        protected var initialized:Boolean;

        public function AbstractDetailSubView()
        {
            super();
            this.viewComponent = this.createViewComponent();
            this.initialized = false;
            this.viewComponent.addEventListener(FlexEvent.CREATION_COMPLETE, this.handleCreationComplete, false, 0, true);
        }

        public function setCoordinates(_arg_1:int, _arg_2:int):void
        {
            this.viewComponent.x = _arg_1;
            this.viewComponent.y = _arg_2;
        }

        protected function handleSetActiveParent():void
        {
        }

        protected function handleSetNullParent():void
        {
        }

        public function setParent(_arg_1:DisplayObjectContainer):void
        {
            if (_arg_1 != null)
            {
                _arg_1.addChild(this.viewComponent);
                this.handleSetActiveParent();
            }
            else
            {
                if (this.viewComponent.parent)
                {
                    this.viewComponent.parent.removeChild(this.viewComponent);
                };
                this.handleSetNullParent();
            };
        }

        protected function handleCreationComplete(_arg_1:FlexEvent):void
        {
            this.viewComponent.removeEventListener(FlexEvent.CREATION_COMPLETE, this.handleCreationComplete);
            this.initialized = true;
        }

        public function populateDetails(... _args):void
        {
        }

        public function updateDetails(... _args):void
        {
        }

        protected function createViewComponent():DisplayObject
        {
            return (null);
        }

        public function getInitialized():Boolean
        {
            return (this.initialized);
        }

        public function dispose():void
        {
            if (this.viewComponent)
            {
                if (this.viewComponent.parent)
                {
                    this.viewComponent.parent.removeChild(this.viewComponent);
                };
                this.viewComponent.removeEventListener(FlexEvent.CREATION_COMPLETE, this.handleCreationComplete);
                this.viewComponent = null;
            };
        }


    }
}
