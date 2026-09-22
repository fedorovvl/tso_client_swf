package com.bluebyte.tso.ui.assets
{
    import flash.utils.Dictionary;
    import com.bluebyte.tso.ui.assets.renderer.CampHealthbarRenderer;
    import com.bluebyte.tso.ui.assets.renderer.TextRenderer;
    import flash.xml.XMLNode;
    import flash.display.Bitmap;
    import flash.display.PixelSnapping;

    public final class Assets 
    {

        private static var inst:Assets;

        private var source:IAssetSource = new AssetManagerWrapper();
        private var animationCache:Dictionary = new Dictionary();
        private var cache:Dictionary = new Dictionary();
        private var renderers:Dictionary = new Dictionary();

        public function Assets(_arg_1:SingletonEnforcer)
        {
            super();
            if (inst)
            {
                throw (new Error("There is already an instance of Assets()!"));
            };
            this.renderers[CampHealthbarRenderer.NAME] = new CampHealthbarRenderer(this);
            this.renderers[TextRenderer.NAME] = new TextRenderer();
        }

        public static function getInstance():Assets
        {
            if (!inst)
            {
                inst = new Assets(new SingletonEnforcer());
            };
            return (inst);
        }


        public function getXML(_arg_1:String):XMLNode
        {
            return (this.source.getXML(_arg_1));
        }

        public function getBitmap(_arg_1:String):Bitmap
        {
            var _local_2:Bitmap = this.getCachedBitmap(_arg_1);
            if (!_local_2)
            {
                _local_2 = this.cacheBitmap(_arg_1, this.getMappedAsset(_arg_1));
            };
            return (_local_2);
        }

        private function getMappedAsset(_arg_1:String):Bitmap
        {
            var _local_2:Array = _arg_1.split(":");
            if (_local_2.length == 1)
            {
                return (this.source.getBitmap(_arg_1));
            };
            return (this.source.getMappedBitmap(_local_2[0], _local_2[1]));
        }

        public function getCombinedBitmap(_arg_1:AssetCombineChain):Bitmap
        {
            var _local_2:String = _arg_1.calculateHashKey();
            var _local_3:Bitmap = this.getCachedBitmap(_local_2);
            if (!_local_3)
            {
                _local_3 = this.cacheBitmap(_local_2, _arg_1.renderBitmap());
            };
            return (_local_3);
        }

        internal function getUnclonedBitmap(_arg_1:String):Bitmap
        {
            return (this.getBitmap(_arg_1));
        }

        public function getAnimation(_arg_1:String):TexturePackerAsset
        {
            var _local_2:TexturePackerAsset = (this.animationCache[_arg_1] as TexturePackerAsset);
            if (!_local_2)
            {
                _local_2 = new TexturePackerAsset(_arg_1);
                this.animationCache[_arg_1] = _local_2;
            };
            return (_local_2);
        }

        private function cacheBitmap(_arg_1:String, _arg_2:Bitmap, _arg_3:Boolean=true):Bitmap
        {
            if (((!(_arg_2)) || (!(_arg_2.bitmapData))))
            {
                return (null);
            };
            this.cache[_arg_1] = _arg_2;
            return (this.getCachedBitmap(_arg_1, _arg_3));
        }

        public function getCustomBitmap(_arg_1:String, _arg_2:Object):Bitmap
        {
            var _local_3:String = ((("#" + _arg_1) + "#") + _arg_2.toString());
            var _local_4:Bitmap = this.getCachedBitmap(_local_3);
            if (!_local_4)
            {
                _local_4 = this.cacheBitmap(_local_3, new Bitmap((this.renderers[_arg_1] as CustomBitmapRenderer).render(_arg_2)));
            };
            return (_local_4);
        }

        private function getCachedBitmap(_arg_1:String, _arg_2:Boolean=true):Bitmap
        {
            var _local_3:Bitmap = (this.cache[_arg_1] as Bitmap);
            if (_local_3)
            {
                if (_arg_2)
                {
                    _local_3 = new Bitmap(_local_3.bitmapData.clone(), PixelSnapping.AUTO, true);
                }
                else
                {
                    _local_3 = new Bitmap(_local_3.bitmapData, PixelSnapping.AUTO, true);
                };
            };
            return (_local_3);
        }


    }
}//package com.bluebyte.tso.ui.assets

class SingletonEnforcer 
{

    public function SingletonEnforcer()
    {
        super();
    }

}


