package com.bluebyte.tso.ui.assets
{
    import flash.display.Bitmap;
    import flash.xml.XMLNode;

    public interface IAssetSource 
    {

        function getMappedBitmap(_arg_1:String, _arg_2:String):Bitmap;
        function getXML(_arg_1:String):XMLNode;
        function getBitmap(_arg_1:String):Bitmap;

    }
}
