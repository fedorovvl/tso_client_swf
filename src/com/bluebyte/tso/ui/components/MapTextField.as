package com.bluebyte.tso.ui.components
{
    import mx.core.UITextField;
    import flash.text.TextFormat;
    import flash.filters.GlowFilter;
    import flash.text.TextFormatAlign;
    import mx.core.Application;

    public class MapTextField extends UITextField 
    {

        private var textFormat:TextFormat;
        private var glowEffect:GlowFilter;

        public function MapTextField(_arg_1:String, _arg_2:int=13, _arg_3:uint=0xFFFFFF, _arg_4:int=0)
        {
            super();
            selectable = false;
            cacheAsBitmap = false;
            autoSize = "left";
            setStyle("kerning", 2);
            this.textFormat = new TextFormat();
            this.textFormat.font = _arg_1;
            this.textFormat.size = _arg_2;
            this.textFormat.align = TextFormatAlign.LEFT;
            this.textFormat.bold = true;
            this.textFormat.color = _arg_3;
            embedFonts = Application.application.systemManager.isFontFaceEmbedded(this.textFormat);
            defaultTextFormat = this.textFormat;
            this.glowEffect = new GlowFilter(0, 0.8, 2, 2, 5, 2);
            this.glowEffect.color = _arg_4;
            filters = [this.glowEffect];
        }

        public function get color():uint
        {
            return (this.textFormat.color as uint);
        }

        public function set color(_arg_1:uint):void
        {
            this.textFormat.color = _arg_1;
            this.setTextFormat(this.textFormat);
        }

        override public function set text(_arg_1:String):void
        {
            super.text = _arg_1;
            setTextFormat(this.textFormat);
        }

        public function get shadowColor():uint
        {
            return (this.glowEffect.color);
        }

        public function set shadowColor(_arg_1:uint):void
        {
            this.glowEffect.color = _arg_1;
        }


    }
}
