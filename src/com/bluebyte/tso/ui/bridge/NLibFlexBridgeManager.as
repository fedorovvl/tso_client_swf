package com.bluebyte.tso.ui.bridge
{
    import mx.containers.Canvas;
    import Model.Observer;
    import flash.utils.Dictionary;
    import mx.core.ScrollPolicy;
    import mx.core.ContainerCreationPolicy;
    import Model.Notifiers.InputNotifier;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import mx.core.UIComponent;
    import nLib.cPosInt;
    import Model.Notifier;
    import mx.core.mx_internal; 

    use namespace mx_internal;

    public class NLibFlexBridgeManager extends Canvas implements Observer 
    {

        private var registered:Dictionary = new Dictionary(true);

        public function NLibFlexBridgeManager()
        {
            super();
            clipContent = false;
            mouseEnabled = false;
            verticalScrollPolicy = ScrollPolicy.OFF;
            horizontalScrollPolicy = ScrollPolicy.OFF;
            creationPolicy = ContainerCreationPolicy.ALL;
            setStyle("left", 0);
            setStyle("right", 0);
            setStyle("top", 0);
            setStyle("bottom", 0);
        }

        public function init():void
        {
            global.ui.channels.INPUT.addPropertyObserver(InputNotifier.CAMERA_CHANGED_string, this);
            globalFlash.nLibFlexBridgeManager = this;
        }

        public function add(_arg_1:UIComponent, _arg_2:NLibFlexBridgeSettingsProvider):void
        {
            if (!(_arg_1 in this.registered))
            {
                this.registered[_arg_1] = _arg_2;
                _arg_1.addEventListener(FlexEvent.SHOW, this.bridgeShowHandler, false, 0, true);
                _arg_1.addEventListener(MouseEvent.MOUSE_MOVE, this.bridgeOverHandler, false, 0, true);
            };
            if (_arg_1.parent != this)
            {
                addChild(_arg_1);
            };
            this.updateBridge(_arg_1);
        }

        public function updateBridge(_arg_1:UIComponent):void
        {
            var _local_3:cPosInt;
            var _local_4:cPosInt;
            if (((!(_arg_1)) || (!(_arg_1.visible))))
            {
                return;
            };
            var _local_2:NLibFlexBridgeSettingsProvider = (this.registered[_arg_1] as NLibFlexBridgeSettingsProvider);
            if (!_local_2)
            {
                return;
            };
            if (_local_2.scaleWithZoom)
            {
                _arg_1.scaleX = (_arg_1.scaleY = global.ui.mZoom.mFactorDivDefaultZoom);
            };
            if (_local_2.gridPos > -1)
            {
                _local_3 = new cPosInt();
                gCalculations.ConvertStreetGridToPixelPos(global.ui.mCurrentPlayerZone, _local_2.gridPos, _local_3);
                global.ui.mZoom.CalculateScrollPos(_local_3);
                if (_local_2.offsetPoint)
                {
                    _local_4 = _local_2.offsetPoint.clone();
                    if (_local_2.scaleWithZoom)
                    {
                        _local_4.multiply(global.ui.mZoom.mFactorDivDefaultZoom);
                    };
                    _local_3.add(_local_4);
                };
                _arg_1.move(_local_3.x, _local_3.y);
            };
            if (_arg_1.parent != this)
            {
                addChild(_arg_1);
            };
        }

        override mx_internal function createContentPane():void
        {
            super.createContentPane();
            if (contentPane)
            {
                contentPane.mouseEnabled = false;
            };
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:Object;
            for (_local_4 in this.registered)
            {
                this.updateBridge((_local_4 as UIComponent));
            };
        }

        public function remove(_arg_1:UIComponent):void
        {
            if ((_arg_1 in this.registered))
            {
                _arg_1.removeEventListener(FlexEvent.SHOW, this.bridgeShowHandler);
                _arg_1.removeEventListener(MouseEvent.MOUSE_MOVE, this.bridgeOverHandler);
                delete this.registered[_arg_1];
            };
            if (_arg_1.parent == this)
            {
                _arg_1.removeEventListener(FlexEvent.SHOW, this.bridgeShowHandler);
                _arg_1.removeEventListener(MouseEvent.MOUSE_MOVE, this.bridgeOverHandler);
                removeChild(_arg_1);
            };
        }

        private function bridgeShowHandler(_arg_1:FlexEvent):void
        {
            this.updateBridge((_arg_1.target as UIComponent));
        }

        private function bridgeOverHandler(_arg_1:MouseEvent):void
        {
            var _local_2:UIComponent = (_arg_1.currentTarget as UIComponent);
            if ((((_local_2) && (_local_2.parent == this)) && (!(getChildIndex(_local_2) == (numChildren - 1)))))
            {
                setChildIndex(_local_2, (numChildren - 1));
            };
        }


    }
}
