package nLib.SpriteLibDataClass
{
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import flash.geom.Matrix;

    public class dFrameCalculated 
    {

        private static const mNullPoint:Point = new Point(0, 0);
        private static const sMaxAntialiasOperationsPerFrame:int = 5;

        public var applyFilter:Boolean = false;
        public var frameOffsX:Number;
        public var frameOffsY:Number;
        public var renderRect:Rectangle;
        private var _scaledBitmapWidth:int;
        public var frameOffsYScaledCache:Number;
        public var filteredBitmap:BitmapData = null;
        public var scaledBitmap:BitmapData = null;
        private var highlightCache:BitmapData = null;
        public var size_u:int;
        public var size_v:int;
        public var needAntialias:Boolean;
        public var frameOffsXScaledCache:Number;
        public var orginalBitmap:BitmapData = null;
        public var imageOffsetX:Number;
        public var imageOffsetY:Number;
        private var _scaledBitmapHeight:int;
        public var alreadyScaled:Boolean;
        public var lastFilterId:int = 0;
        public var calculateRect:Rectangle = null;
        public var enforceAntialias:Boolean = false;


        public function getScaledBitmapHeight():int
        {
            return (this._scaledBitmapHeight);
        }

        public function setScaledBitmapHeight(_arg_1:int):void
        {
            if (_arg_1 == 0)
            {
                this._scaledBitmapHeight = 1;
            }
            else
            {
                this._scaledBitmapHeight = _arg_1;
            };
        }

        public function getHighlightBitmap():BitmapData
        {
            if (this.highlightCache == null)
            {
                this.highlightCache = this.getRenderBitmap(false).clone();
                if (this.highlightCache != null)
                {
                    this.highlightCache.applyFilter(this.getRenderBitmap(false), this.highlightCache.rect, mNullPoint, gGfxResource.mOutline_ShaderFilter);
                };
            };
            return (this.highlightCache);
        }

        public function getRenderSourceBitmap():BitmapData
        {
            if (this.filteredBitmap != null)
            {
                return (this.filteredBitmap);
            };
            return (this.orginalBitmap);
        }

        public function setScaledBitmapWidth(_arg_1:int):void
        {
            if (_arg_1 == 0)
            {
                this._scaledBitmapWidth = 1;
            }
            else
            {
                this._scaledBitmapWidth = _arg_1;
            };
        }

        public function setOriginalBitmap(_arg_1:BitmapData):void
        {
            this.orginalBitmap = _arg_1;
            this.filteredBitmap = null;
        }

        public function getScaledBitmapWidth():int
        {
            return (this._scaledBitmapWidth);
        }

        public function updateFilterCache():void
        {
            if (((this.applyFilter) && ((this.filteredBitmap == null) || (!(this.lastFilterId == gGfxResource.gUseFilterType)))))
            {
                this.filteredBitmap = new BitmapData(this.size_u, this.size_v, true, 0);
                this.filteredBitmap.applyFilter(this.orginalBitmap, this.orginalBitmap.rect, mNullPoint, gGfxResource.mCurrent_ShaderFilter);
                this.lastFilterId = gGfxResource.gUseFilterType;
            }
            else
            {
                if (((!(this.applyFilter)) && (!(this.filteredBitmap == null))))
                {
                    this.filteredBitmap = null;
                };
            };
        }

        public function getRenderBitmap(_arg_1:Boolean):BitmapData
        {
            var _local_2:BitmapData;
            var _local_5:Number;
            var _local_3:Matrix;
            this.updateFilterCache();
            if (this.scaledBitmap == null)
            {
                _local_2 = this.getRenderSourceBitmap();
                if (_local_2 == null)
                {
                    return (null);
                };
                this.alreadyScaled = false;
                if (global.ui.mZoom.GetScaleFactor() == (1000 * global.mGraphicScaleFactor))
                {
                    this.scaledBitmap = _local_2;
                    this.renderRect = this.scaledBitmap.rect;
                }
                else
                {
                    this.scaledBitmap = new BitmapData(this.getScaledBitmapWidth(), this.getScaledBitmapHeight(), true, 0);
                    this.needAntialias = true;
                    this.renderRect = this.scaledBitmap.rect;
                    _local_3 = global.ui.mZoom.getGraphicScaleMatrix();
                    this.scaledBitmap.draw(_local_2, _local_3, null, null, this.scaledBitmap.rect, true);
                    this.alreadyScaled = true;
                };
            };
            var _local_4:Boolean = ((global.ui.mZoom.GetInvScaleFactor() >= 2) || (global.mGraphicScaleFactor < 1));
            if (this.needAntialias)
            {
                if ((((this.enforceAntialias) && (_arg_1)) || (global.mSwitchToAntialiasingCntr < sMaxAntialiasOperationsPerFrame)))
                {
                    _local_2 = this.getRenderSourceBitmap();
                    if (_local_2 == null)
                    {
                        return (null);
                    };
                    global.mSwitchToAntialiasingCntr++;
                    if ((((this.enforceAntialias) && (_arg_1)) || (_local_4)))
                    {
                        _local_5 = (global.ui.mZoom.GetInvScaleFactor() * global.mGraphicScaleFactor);
                        if (_local_5 < 1)
                        {
                            if (!this.alreadyScaled)
                            {
                                _local_3 = global.ui.mZoom.getGraphicScaleMatrix();
                                this.scaledBitmap.draw(_local_2, _local_3, null, null, this.scaledBitmap.rect, true);
                            };
                        }
                        else
                        {
                            gGfxResource.mAntialiasingZoom_Shader.data.dimension.value = [_local_5];
                            this.scaledBitmap.applyFilter(_local_2, _local_2.rect, mNullPoint, gGfxResource.mAntialiasingZoom_ShaderFilter);
                        };
                    };
                    this.needAntialias = false;
                };
            };
            return (this.scaledBitmap);
        }

        public function clearScale():void
        {
            this.scaledBitmap = null;
            this.highlightCache = null;
        }


    }
}
