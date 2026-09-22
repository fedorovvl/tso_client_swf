package com.bluebyte.tso.ui.assets.renderer
{
    import com.bluebyte.tso.ui.assets.CustomBitmapRenderer;
    import flash.geom.Matrix;
    import flash.utils.Dictionary;
    import flash.text.TextFormat;
    import mx.core.UITextField;
    import flash.geom.Point;
    import flash.filters.GlowFilter;
    import flash.text.TextFormatAlign;
    import flash.display.BitmapData;

    public class TextRenderer implements CustomBitmapRenderer 
    {

        public static var NAME:String = "text";

        private var matrix:Matrix;
        private var cache:Dictionary;
        private var color:uint;
        private var textFormat:TextFormat;
        private var shadowColor:uint;
        private var textField:UITextField;
        private var point:Point;
        private var cacheCounter:uint = 0;
        private var glowEffect:GlowFilter;

        public function TextRenderer(_arg_1:int=13, _arg_2:uint=0xFFFFFF, _arg_3:int=0)
        {
            super();
            this.color = _arg_2;
            this.shadowColor = _arg_3;
            this.textFormat = new TextFormat();
            this.textFormat.font = global.getApplication().getStyle("fontFamily");
            this.textFormat.size = _arg_1;
            this.textFormat.align = TextFormatAlign.LEFT;
            this.textFormat.bold = true;
            this.textFormat.color = _arg_2;
            this.textField = new UITextField();
            this.textField.embedFonts = global.getApplication().systemManager.isFontFaceEmbedded(this.textFormat);
            this.textField.defaultTextFormat = this.textFormat;
            this.textField.selectable = false;
            this.textField.cacheAsBitmap = false;
            this.textField.autoSize = "left";
            this.textField.setStyle("kerning", 2);
            this.glowEffect = new GlowFilter(0, 0.8, 2, 2, 5, 2);
            this.glowEffect.color = 0;
            this.textField.filters = [this.glowEffect];
            this.matrix = new Matrix();
        }

        public function render(_arg_1:Object):BitmapData
        {
            this.textField.text = (_arg_1 as String);
            var _local_2:BitmapData = new BitmapData((this.textField.measuredWidth + 2), (this.textField.measuredHeight + 2), true, 0);
            this.matrix.tx = 1;
            this.matrix.ty = 1;
            this.textFormat.color = this.color;
            this.textField.setTextFormat(this.textFormat);
            _local_2.draw(this.textField, this.matrix);
            return (_local_2);
        }


    }
}
