package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import Interface.cGameInterface;
    import GUI.Components.HiredTroopsPoolPanel;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import MilitarySystem.cMilitaryUnitBase;
    import flash.utils.Dictionary;
    import mx.events.FlexEvent;
    import mx.events.ResizeEvent;

    public class cHiredTroopsPoolPanel extends cGuiBaseElement 
    {

        private var mGI:cGameInterface;
        protected var mPanel:HiredTroopsPoolPanel;
        private var clickOffsetX:int;
        private var clickOffsetY:int;


        private function MouseDownHandler(_arg_1:MouseEvent):void
        {
            this.mPanel.setConstraintValue("right", null);
            this.mPanel.setConstraintValue("top", null);
            this.clickOffsetX = (_arg_1.target.x + _arg_1.localX);
            this.clickOffsetY = (_arg_1.target.y + _arg_1.localY);
            global.getApplication().addEventListener(MouseEvent.MOUSE_UP, this.MouseUpHandler);
            global.getApplication().stage.addEventListener(Event.MOUSE_LEAVE, this.MouseUpHandler);
            global.getApplication().addEventListener(MouseEvent.MOUSE_MOVE, this.MouseMoveHandler);
        }

        private function SortSquads(_arg_1:Object, _arg_2:Object):int
        {
            return (cMilitaryUnitBase.SortUnits(cMilitaryUnitBase.GetUnitBaseForType(_arg_1.name), cMilitaryUnitBase.GetUnitBaseForType(_arg_2.name)));
        }

        private function MouseUpHandler(_arg_1:Event):void
        {
            global.getApplication().removeEventListener(MouseEvent.MOUSE_UP, this.MouseUpHandler);
            global.getApplication().stage.removeEventListener(Event.MOUSE_LEAVE, this.MouseUpHandler);
            global.getApplication().removeEventListener(MouseEvent.MOUSE_MOVE, this.MouseMoveHandler);
        }

        public function SetData(_arg_1:Dictionary):void
        {
            var _local_4:String;
            var _local_5:Array;
            var _local_6:int;
            var _local_7:Array;
            var _local_8:int;
            var _local_2:Array = [];
            var _local_3:int;
            for (_local_4 in _arg_1)
            {
                if (_arg_1[_local_4] > 0)
                {
                    _local_2.push({
                        "name":_local_4,
                        "amount":_arg_1[_local_4]
                    });
                    _local_3 = (_local_3 + _arg_1[_local_4]);
                };
            };
            if (_local_3 > 0)
            {
                _local_2.sort(this.SortSquads);
                _local_5 = [];
                _local_6 = 0;
                while (_local_6 < _local_2.length)
                {
                    _local_7 = [];
                    _local_8 = _local_6;
                    while (((_local_8 < _local_2.length) && (_local_8 < (_local_6 + 3))))
                    {
                        _local_7.push(_local_2[_local_8]);
                        _local_8++;
                    };
                    _local_5.push(_local_7);
                    _local_6 = (_local_6 + 3);
                };
                this.mPanel.manageHiredUnitsList.dataProvider = _local_5;
                this.mPanel.height = (130 + ((_local_5.length - 1) * 60));
                this.Show();
            }
            else
            {
                this.Hide();
            };
        }

        public function Init(_arg_1:HiredTroopsPoolPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.topOrnamental.addEventListener(MouseEvent.MOUSE_DOWN, this.MouseDownHandler);
            this.mPanel.bottomOrnamental.addEventListener(MouseEvent.MOUSE_DOWN, this.MouseDownHandler);
            this.mPanel.addEventListener(ResizeEvent.RESIZE, this.ResizeHandler);
            global.getApplication().addEventListener(ResizeEvent.RESIZE, this.ResizeHandler);
        }

        private function MouseMoveHandler(_arg_1:MouseEvent):void
        {
            this.mPanel.x = (_arg_1.stageX - this.clickOffsetX);
            this.mPanel.y = (_arg_1.stageY - this.clickOffsetY);
            if (this.mPanel.x < 0)
            {
                this.mPanel.x = 0;
            };
            if (this.mPanel.y < 0)
            {
                this.mPanel.y = 0;
            };
            if (this.mPanel.x > (global.getApplication().stage.stageWidth - this.mPanel.width))
            {
                this.mPanel.x = (global.getApplication().stage.stageWidth - this.mPanel.width);
            };
            if (this.mPanel.y > (global.getApplication().stage.stageHeight - this.mPanel.height))
            {
                this.mPanel.y = (global.getApplication().stage.stageHeight - this.mPanel.height);
            };
        }

        private function ResizeHandler(_arg_1:ResizeEvent):void
        {
            if (this.mPanel.x < 0)
            {
                this.mPanel.x = 0;
            };
            if (this.mPanel.y < 0)
            {
                this.mPanel.y = 0;
            };
            if (this.mPanel.x > (global.getApplication().stage.stageWidth - this.mPanel.width))
            {
                this.mPanel.x = (global.getApplication().stage.stageWidth - this.mPanel.width);
            };
            if (this.mPanel.y > (global.getApplication().stage.stageHeight - this.mPanel.height))
            {
                this.mPanel.y = (global.getApplication().stage.stageHeight - this.mPanel.height);
            };
        }


    }
}
