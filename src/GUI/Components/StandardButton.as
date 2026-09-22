package GUI.Components
{
    import mx.controls.Button;
    import flash.display.Bitmap;
    import mx.styles.CSSStyleDeclaration;
    import GUI.Decorator.GUIDecorator;
    import Sound.cSoundManager;
    import mx.events.ToolTipEvent;
    import flash.events.MouseEvent;
    import GUI.Components.ToolTips.cToolTipUtil;
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

    public class StandardButton extends Button 
    {

        private var _bitmapIcon:Bitmap;
        private var _playSound:Boolean = true;

        public function StandardButton()
        {
            super();
            if (!this.styleDeclaration)
            {
                this.styleDeclaration = new CSSStyleDeclaration();
            };
            this.styleDeclaration.defaultFactory = function ():void
            {
                this.color = 0;
            };
            this.styleName = "standard";
            this.addEventListener("toolTipCreate", this.___StandardButton_Button1_toolTipCreate);
            this.addEventListener("click", this.___StandardButton_Button1_click);
        }

        private function placeIcon():void
        {
            this._bitmapIcon.x = ((width - this._bitmapIcon.width) >> 1);
            this._bitmapIcon.y = ((height - this._bitmapIcon.height) >> 1);
            if (((!(label == null)) && (label.length > 0)))
            {
                this._bitmapIcon.x = (((width >> 1) - this._bitmapIcon.width) - (label.length * 4));
            };
        }

        override public function set enabled(_arg_1:Boolean):void
        {
            super.enabled = _arg_1;
            filters = [];
            if (!_arg_1)
            {
                GUIDecorator.greyFilter(this);
            };
        }

        public function setBitmapIcon(_arg_1:Bitmap):void
        {
            if (this._bitmapIcon != null)
            {
                if (this._bitmapIcon.parent)
                {
                    this._bitmapIcon.parent.removeChild(this._bitmapIcon);
                };
            };
            this._bitmapIcon = _arg_1;
            this.placeIcon();
            this.addChild(this._bitmapIcon);
        }

        override public function initialize():void
        {
            super.initialize();
        }

        private function play():void
        {
            if (this._playSound)
            {
                cSoundManager.getInstance().playEffect(cSoundManager.BUTTON_CLICK);
            };
        }

        public function ___StandardButton_Button1_toolTipCreate(_arg_1:ToolTipEvent):void
        {
            this.handleCreateTooltip(_arg_1);
        }

        public function set playSound(_arg_1:Boolean):void
        {
            this._playSound = _arg_1;
        }

        override protected function updateDisplayList(_arg_1:Number, _arg_2:Number):void
        {
            super.updateDisplayList(_arg_1, _arg_2);
            if (this._bitmapIcon)
            {
                this.setChildIndex(this._bitmapIcon, (numChildren - 1));
            };
        }

        public function get playSound():Boolean
        {
            return (this._playSound);
        }

        public function ___StandardButton_Button1_click(_arg_1:MouseEvent):void
        {
            this.play();
        }

        protected function handleCreateTooltip(_arg_1:ToolTipEvent):void
        {
            cToolTipUtil.createToolTip(cToolTipUtil.SIMPLE_string, _arg_1);
        }


    }
}
