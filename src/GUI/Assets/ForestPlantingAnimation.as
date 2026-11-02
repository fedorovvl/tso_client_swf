package GUI.Assets
{
    import flash.display.Bitmap;
    import flash.utils.ByteArray;
    import GOSets.cGOSet;
    import GOSets.cGOSetItem;
    import GOSets.cGOSetList;
    import GOSets.cGOSetListControllerStatic;
    import GOSets.cGOSetListItem;
    import nLib.cPosInt;
    import nLib.cSpriteLib;
    import nLib.cSpriteLibContainer;

    public class ForestPlantingAnimation
    {
        [Embed(source="../../../assets/forest-planting/forester-planting.png")]
        private static const Atlas:Class;

        [Embed(source="../../../assets/forest-planting/forester-planting.bin", mimeType="application/octet-stream")]
        private static const Frames:Class;

        private static var container:cSpriteLibContainer;
        private static var zoomFactor:Number = NaN;

        public static function GetPlantingOffset(graphicsName:String):cPosInt
        {
            var offset:cPosInt = new cPosInt();
            if (graphicsName == null || graphicsName == "")
            {
                // Legacy snapshots may omit the future tree graphics; do not guess it.
                return (offset);
            }
            for each (var list:cGOSetList in global.goSetList_vector)
            {
                if (list.mName_string != graphicsName)
                {
                    continue;
                }
                for each (var listItem:cGOSetListItem in list.mGOSetListItem_vector)
                {
                    if (listItem.mValue != 1)
                    {
                        continue;
                    }
                    for each (var set:cGOSet in global.goSet_vector)
                    {
                        if (set.mName_string == listItem.mName_string && set.mGOSetItem_vector.length == 1)
                        {
                            offset.x = set.mGOSetItem_vector[0].mOffsetX;
                            offset.y = set.mGOSetItem_vector[0].mOffsetY;
                            return (offset);
                        }
                    }
                }
            }
            return (offset);
        }

        public static function RefreshScale():void
        {
            var currentZoom:Number = global.ui.mZoom.mFactorDivDefaultZoom;
            if (container != null && currentZoom != zoomFactor)
            {
                container.SetDirty();
                zoomFactor = currentZoom;
            }
        }

        public static function Create():cGOSetList
        {
            if (container == null)
            {
                // Use the original BIN decoder and zoom/filter preparation.
                container = new cSpriteLibContainer(null, null, 1000, false, false, 0);
                container.mStream = false;
                container.mDeltaCompression = false;
                container.mSpriteLib = container.LoadSpriteLibFromBinaryData(new Frames() as ByteArray);
                var atlas:Bitmap = new Atlas() as Bitmap;
                container.mOriginalGraphicsImageBitmapData = atlas.bitmapData;
                container.PrepareScaling(false);
                container.mOriginalGraphicsImageBitmapData = null;
                atlas.bitmapData.dispose();
                container.SetDirty();
                container.mLoadingFinished = true;
                container.mLoadingFinishedLib = true;
                container.mStreamingFinished = true;
            }

            RefreshScale();
            var sprite:cSpriteLib = container.CreateObject();
            sprite.SetSubType(0);
            // Original woodcutter effectdefaultanimspeed in gfx_settings.xml.
            sprite.SetAnim(0.5, true);
            sprite.SetAnimFrame(0);
            var item:cGOSetItem = new cGOSetItem();
            item.mSpriteLib = sprite;
            var set:cGOSet = new cGOSet();
            set.mGOSetItem_vector.push(item);
            var listItem:cGOSetListItem = new cGOSetListItem();
            listItem.mValue = 0;
            listItem.mGOSet = set;
            var controller:cGOSetListControllerStatic = new cGOSetListControllerStatic();
            var list:cGOSetList = new cGOSetList(controller);
            list.mName_string = "embeddedForestPlanting";
            list.mType_string = "effectAnim";
            list.mGOSetListItem_vector.push(listItem);
            controller.SetValue(0);
            return (list);
        }
    }
}
