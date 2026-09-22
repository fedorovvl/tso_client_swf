package GUI.Components
{
    import mx.controls.Button;
    import Sound.cSoundManager;
    import flash.events.MouseEvent;

    public class RemoveBuffButton extends Button 
    {

        public function RemoveBuffButton()
        {
            super();
            this.styleName = "closeSmall";
            this.width = 13;
            this.height = 12;
            this.addEventListener("click", this.___RemoveBuffButton_Button1_click);
        }

        override public function initialize():void
        {
            super.initialize();
        }

        public function ___RemoveBuffButton_Button1_click(_arg_1:MouseEvent):void
        {
            cSoundManager.getInstance().playEffect("ButtonClick");
        }


    }
}
