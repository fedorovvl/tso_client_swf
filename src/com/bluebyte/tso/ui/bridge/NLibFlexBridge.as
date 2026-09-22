package com.bluebyte.tso.ui.bridge
{
    import mx.containers.Box;
    import nLib.cPosInt;
    import mx.core.ScrollPolicy;
    import flash.events.MouseEvent;
    import mx.events.FlexEvent;
    import mx.events.PropertyChangeEvent;

    public class NLibFlexBridge extends Box implements NLibFlexBridgeSettingsProvider 
    {

        private var _scaleWithZoom:Boolean = false;
        private var _offsetPoint:cPosInt = null;
        private var _gridPos:int = -1;

        public function NLibFlexBridge()
        {
            super();
            this._offsetPoint = new cPosInt();
            clipContent = false;
            cacheAsBitmap = false;
            verticalScrollPolicy = ScrollPolicy.OFF;
            horizontalScrollPolicy = ScrollPolicy.OFF;
            addEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelHandler);
            addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        public function set offsetPoint(_arg_1:cPosInt):void
        {
            this._offsetPoint = _arg_1;
        }

        public function attachToEngine():NLibFlexBridge
        {
            if (parent != globalFlash.nLibFlexBridgeManager)
            {
                addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
                globalFlash.nLibFlexBridgeManager.addChild(this);
            }
            else
            {
                globalFlash.nLibFlexBridgeManager.add(this, this);
            };
            return (this);
        }

        public function set scaleWithZoom(_arg_1:Boolean):void
        {
            this._scaleWithZoom = _arg_1;
        }

        public function get scaleWithZoom():Boolean
        {
            return (this._scaleWithZoom);
        }

        [Bindable(event="propertyChange")]
        public function set gridPos(_arg_1:int):void
        {
            var _local_2:Object = this.gridPos;
            if (_local_2 !== _arg_1)
            {
                this._287351086gridPos = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "gridPos", _local_2, _arg_1));
            };
        }

        public function get gridPos():int
        {
            return (this._gridPos);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            globalFlash.nLibFlexBridgeManager.add(this, this);
        }

        private function mouseWheelHandler(_arg_1:MouseEvent):void
        {
            global.getApplication().isoengine.dispatchEvent(_arg_1);
        }

        private function set _287351086gridPos(_arg_1:int):void
        {
            this._gridPos = _arg_1;
        }

        public function get offsetPoint():cPosInt
        {
            return (this._offsetPoint);
        }

        public function detachFromEngine():NLibFlexBridge
        {
            if (this.parent == globalFlash.nLibFlexBridgeManager)
            {
                globalFlash.nLibFlexBridgeManager.remove(this);
            };
            return (this);
        }


    }
}
