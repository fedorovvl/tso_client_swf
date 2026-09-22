package GUI.Components
{
    import flash.events.KeyboardEvent;

    public class ButtonWithoutKeyboard extends StandardButton 
    {


        override public function initialize():void
        {
            super.initialize();
        }

        override protected function keyUpHandler(_arg_1:KeyboardEvent):void
        {
        }


    }
}
