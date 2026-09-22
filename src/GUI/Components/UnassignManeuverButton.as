package GUI.Components
{
    import mx.controls.Button;
    import Sound.cSoundManager;
    import flash.events.MouseEvent;

    public class UnassignManeuverButton extends Button 
    {

        public function UnassignManeuverButton()
        {
            super();
            this.styleName = "unassign";
            this.width = 13;
            this.height = 12;
            this.addEventListener("click", this.___UnassignManeuverButton_Button1_click);
        }

        override public function initialize():void
        {
            super.initialize();
        }

        public function ___UnassignManeuverButton_Button1_click(_arg_1:MouseEvent):void
        {
            cSoundManager.getInstance().playEffect("ButtonClick");
        }


    }
}
