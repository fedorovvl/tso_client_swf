package GUI.Components.DataGrid
{
    import mx.skins.ProgrammaticSkin;

    public class CustomDataGridHeaderSeparator extends ProgrammaticSkin 
    {


        override public function get measuredWidth():Number
        {
            return (1);
        }

        override public function get measuredHeight():Number
        {
            return (10);
        }

        override protected function updateDisplayList(_arg_1:Number, _arg_2:Number):void
        {
            super.updateDisplayList(_arg_1, _arg_2);
            graphics.clear();
            graphics.lineStyle(1, getStyle("borderColor"));
            graphics.moveTo(1, 0);
            graphics.lineTo(1, _arg_2);
        }


    }
}
