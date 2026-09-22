package GUI.Components.DataGrid
{
    import mx.skins.ProgrammaticSkin;

    public class CustomDataGridHeaderBackgroundSkin extends ProgrammaticSkin 
    {


        override protected function updateDisplayList(_arg_1:Number, _arg_2:Number):void
        {
            super.updateDisplayList(_arg_1, _arg_2);
            graphics.clear();
        }


    }
}
