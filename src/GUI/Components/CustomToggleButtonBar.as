package GUI.Components
{
    import mx.controls.ToggleButtonBar;
    import mx.events.ListEvent;
    import mx.events.FlexEvent;
    import GUI.Components.ToolTips.cToolTipUtil;
    import mx.events.ToolTipEvent;
    import mx.controls.Button;
    import flash.events.Event;

    public class CustomToggleButtonBar extends ToggleButtonBar 
    {

        public function CustomToggleButtonBar()
        {
            super();
            this.addEventListener(ListEvent.ITEM_CLICK, this.changeTextAlignment);
            this.addEventListener(FlexEvent.UPDATE_COMPLETE, this.changeTextAlignment);
            this.addEventListener(FlexEvent.UPDATE_COMPLETE, this.assignToolTips);
            this.addEventListener(FlexEvent.CREATION_COMPLETE, this.assignToolTips);
        }

        private function createToolTip(_arg_1:ToolTipEvent):void
        {
            cToolTipUtil.createToolTip(cToolTipUtil.SIMPLE_string, _arg_1);
        }

        private function changeTextAlignment(_arg_1:Event):void
        {
            var _local_4:Button;
            if (this.dataProvider == null)
            {
                return;
            };
            this.setStyle("buttonWidth", (this.width / this.dataProvider.length));
            var _local_2:int = this.dataProvider.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_4 = (this.getChildAt(_local_3) as Button);
                _local_4.setStyle("paddingTop", -5);
                _local_3++;
            };
            if (this.selectedIndex > -1)
            {
                (this.getChildAt(this.selectedIndex) as Button).setStyle("paddingTop", 0);
            };
        }

        override public function set dataProvider(_arg_1:Object):void
        {
            super.dataProvider = _arg_1;
            if (_arg_1 == null)
            {
                return;
            };
            this.setStyle("buttonWidth", (this.width / this.dataProvider.length));
            this.selectedIndex = 0;
        }

        private function assignToolTips(_arg_1:FlexEvent):void
        {
            var _local_2:Button;
            if (this.getChildren() == null)
            {
                return;
            };
            for each (_local_2 in this.getChildren())
            {
                _local_2.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.createToolTip);
            };
        }


    }
}
