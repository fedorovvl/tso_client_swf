package GUI.Components
{
    import flash.events.KeyboardEvent;
    import mx.events.ToolTipEvent;

    public class ButtonWihtoutKeyboard extends StandardButton 
    {


        override public function initialize():void
        {
            super.initialize();
        }

        override protected function keyDownHandler(_arg_1:KeyboardEvent):void
        {
        }

        override protected function handleCreateTooltip(_arg_1:ToolTipEvent):void
        {
        }


    }
}
