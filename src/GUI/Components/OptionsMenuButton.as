package GUI.Components
{
    import mx.controls.Button;
    import mx.styles.CSSStyleDeclaration;
    import Sound.cSoundManager;
    import flash.events.MouseEvent;
    import GUI.Components.ToolTips.cToolTipUtil;
    import mx.events.ToolTipEvent;
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import mx.styles.*;
    import flash.text.*;
    import flash.media.*;
    import mx.binding.*;
    import flash.filters.*;
    import flash.utils.*;
    import flash.net.*;
    import flash.system.*;
    import flash.accessibility.*;
    import flash.xml.*;
    import flash.ui.*;
    import flash.external.*;
    import flash.desktop.*;
    import flash.data.*;
    import flash.debugger.*;
    import flash.errors.*;
    import flash.filesystem.*;
    import flash.html.*;
    import flash.html.script.*;
    import flash.printing.*;
    import flash.profiler.*;

    public class OptionsMenuButton extends Button 
    {

        private var _soundEffect:String = "ButtonClick";
        private var _playSound:Boolean = true;

        public function OptionsMenuButton()
        {
            super();
            if (!this.styleDeclaration)
            {
                this.styleDeclaration = new CSSStyleDeclaration();
            };
            this.styleDeclaration.defaultFactory = function ():void
            {
                this.color = 15123590;
            };
            this.styleName = "optionsMenu";
            this.width = 110;
            this.height = 21;
            this.addEventListener("toolTipCreate", this.___OptionsMenuButton_Button1_toolTipCreate);
            this.addEventListener("click", this.___OptionsMenuButton_Button1_click);
        }

        public function get soundEffect():String
        {
            return (this._soundEffect);
        }

        public function set soundEffect(_arg_1:String):void
        {
            this._soundEffect = _arg_1;
        }

        override public function initialize():void
        {
            super.initialize();
        }

        private function play():void
        {
            if (this._playSound)
            {
                cSoundManager.getInstance().playEffect(this._soundEffect);
            };
        }

        public function set playSound(_arg_1:Boolean):void
        {
            this._playSound = _arg_1;
        }

        public function ___OptionsMenuButton_Button1_click(_arg_1:MouseEvent):void
        {
            this.play();
        }

        public function get playSound():Boolean
        {
            return (this._playSound);
        }

        public function ___OptionsMenuButton_Button1_toolTipCreate(_arg_1:ToolTipEvent):void
        {
            cToolTipUtil.createToolTip(cToolTipUtil.SIMPLE_string, _arg_1);
        }


    }
}
