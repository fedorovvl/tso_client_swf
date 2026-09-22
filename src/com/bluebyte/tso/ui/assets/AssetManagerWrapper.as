package com.bluebyte.tso.ui.assets
{
    import GUI.Assets.gAssetManager;
    import flash.display.Bitmap;
    import nLib.cXML;
    import flash.xml.XMLNode;

    public class AssetManagerWrapper implements IAssetSource 
    {


        public function getMappedBitmap(_arg_1:String, _arg_2:String):Bitmap
        {
            if (!_arg_2)
            {
                return (null);
            };
            switch (_arg_1)
            {
                case "m":
                    return (gAssetManager.GetMilitaryIcon(_arg_2));
                case "b":
                    return (gAssetManager.GetBuffIcon(_arg_2));
                case "r":
                    return (gAssetManager.GetResourceIcon(_arg_2));
                default:
                    return (gAssetManager.GetGfx(_arg_2));
            };
        }

        public function getXML(_arg_1:String):XMLNode
        {
            return (cXML.getFirstChildBasedOnAttribute(global.textureAtlas, "imagePath", _arg_1.replace(".xml", ".png")));
        }

        public function getBitmap(_arg_1:String):Bitmap
        {
            if (!_arg_1)
            {
                return (null);
            };
            return (gAssetManager.GetGfx(_arg_1));
        }


    }
}
