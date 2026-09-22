package nLib
{
    import flash.geom.Rectangle;
    import flash.geom.Matrix;
    import nLib.SpriteLibDataClass.dFrameCalculated;
    import flash.display.BitmapData;
    import __AS3__.vec.Vector;
    import nLib.SpriteLibDataClass.dSubtypeCalculated;

    public class cSpriteLib 
    {

        private static const mTempRect:Rectangle = new Rectangle();
        private static const mZoomMatrix:Matrix = new Matrix();

        private var mFrame:int;
        private var mAnimSpeed:Number;
        private var mAnimLoop:Boolean;
        private var mSubType:int;
        private var mSpriteLibContainer:cSpriteLibContainer = null;
        public var mAnimFrame:Number;

        public function cSpriteLib()
        {
            super();
            this.Reset();
        }

        public function GetBitmapFromSubTypeAndFrame(_arg_1:int, _arg_2:int):BitmapData
        {
            var _local_3:dFrameCalculated = this.mSpriteLibContainer.getFrameCalculated(_arg_1, _arg_2);
            return ((_local_3 != null) ? _local_3.getRenderSourceBitmap() : null);
        }

        public function GetBitmap():BitmapData
        {
            return (this.GetBitmapFromSubTypeAndFrame(this.mSubType, this.mAnimFrame));
        }

        public function GetMaxHeightForSubType(_arg_1:int):int
        {
            var _local_4:int;
            var _local_5:dFrameCalculated;
            var _local_2:Vector.<dSubtypeCalculated> = this.mSpriteLibContainer.mSubtypeCalculated_vector;
            if (_arg_1 >= _local_2.length)
            {
                return (0);
            };
            var _local_3:dSubtypeCalculated = _local_2[_arg_1];
            for each (_local_5 in _local_3.frameList_vector)
            {
                if (_local_5.size_v > _local_4)
                {
                    _local_4 = _local_5.size_v;
                };
            };
            return (_local_4);
        }

        public function Animate(_arg_1:Number):Boolean
        {
            var _local_2:dSubtypeCalculated = this.mSpriteLibContainer.getSubtypeCalculated(this.mSubType);
            if (_local_2 == null)
            {
                return (false);
            };
            var _local_3:int = _local_2.numFrames;
            this.mAnimFrame = (this.mAnimFrame + (this.mAnimSpeed * _arg_1));
            if (this.mAnimFrame >= _local_3)
            {
                if (this.mAnimLoop)
                {
                    do 
                    {
                        this.mAnimFrame = (this.mAnimFrame - _local_3);
                    } while (this.mAnimFrame >= _local_3);
                }
                else
                {
                    this.mAnimFrame = (_local_3 - 1);
                    return (true);
                };
            };
            return (false);
        }

        public function RenderTransform2NoScaling(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:Number, _arg_5:Number, _arg_6:Number):void
        {
            this.RenderSubTypeAndFrameTransformNoScaling(_arg_1, _arg_2, this.mSubType, this.mFrame, _arg_3, _arg_4, _arg_5, _arg_6);
        }

        public function SetFrame(_arg_1:int):void
        {
            if (this.mFrame != _arg_1)
            {
                this.mFrame = _arg_1;
            };
        }

        public function GetAnimFrame():Number
        {
            return (this.mAnimFrame);
        }

        public function RenderSubTypeAndFrame(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            var _local_5:Number = global.ui.mZoom.mFactorDivDefaultZoom;
            _arg_1 = (_arg_1 * _local_5);
            _arg_2 = (_arg_2 * _local_5);
            this.RenderSubTypeAndFrameNoScaling(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        public function GetMaxWidthForSubType(_arg_1:int):int
        {
            var _local_4:int;
            var _local_5:dFrameCalculated;
            var _local_2:Vector.<dSubtypeCalculated> = this.mSpriteLibContainer.mSubtypeCalculated_vector;
            if (_arg_1 >= _local_2.length)
            {
                return (0);
            };
            var _local_3:dSubtypeCalculated = _local_2[_arg_1];
            for each (_local_5 in _local_3.frameList_vector)
            {
                if (_local_5.size_u > _local_4)
                {
                    _local_4 = _local_5.size_u;
                };
            };
            return (_local_4);
        }

        public function GetSubType():int
        {
            return (this.mSubType);
        }

        public function RenderSubTypeAndFrameTransformNoScaling(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:String, _arg_6:Number, _arg_7:Number, _arg_8:Number):void
        {
            var _local_13:Number;
            if (_arg_3 != -1)
            {
                this.mSubType = _arg_3;
                this.mFrame = _arg_4;
            };
            var _local_9:dFrameCalculated = this.mSpriteLibContainer.getFrameCalculated(this.mSubType, this.mFrame);
            if (_local_9 == null)
            {
                return;
            };
            _local_9.applyFilter = ((gGfxResource.IsFilterActive()) && (this.IsFilterApplyable()));
            var _local_10:int = ((_arg_1 + _local_9.frameOffsXScaledCache) - global.ui.mZoom.mCacheZoomInvScaleScrollPosXMinusHalfScreenWidth);
            var _local_11:int = ((_arg_2 + _local_9.frameOffsYScaledCache) - global.ui.mZoom.mCacheZoomInvScaleScrollPosYMinusHalfScreenHeight);
            var _local_12:BitmapData = _local_9.getRenderBitmap(false);
            if (_local_12 != null)
            {
                _local_13 = global.ui.mZoom.mFactorDivDefaultZoom;
                mTempRect.width = (_local_9.scaledBitmap.width * _arg_6);
                mTempRect.height = (_local_9.scaledBitmap.height * _arg_7);
                mTempRect.x = _local_10;
                mTempRect.y = _local_11;
                mTempRect.x = (mTempRect.x - this.fastCeil((((mTempRect.width - _local_9.scaledBitmap.width) * _local_13) * 0.5)));
                mTempRect.y = (mTempRect.y - this.fastCeil((((mTempRect.height - _local_9.scaledBitmap.height) * _local_13) * 0.5)));
                mZoomMatrix.identity();
                mZoomMatrix.scale(_arg_6, _arg_7);
                mZoomMatrix.translate(mTempRect.x, mTempRect.y);
                cBackbuffer.Draw(_local_12, mZoomMatrix, _arg_5, mTempRect);
            };
        }

        public function RenderPosNoScaling(_arg_1:int, _arg_2:int, _arg_3:Boolean=false):void
        {
            this.RenderSubTypeAndFrameNoScaling(_arg_1, _arg_2, this.mSubType, this.mAnimFrame, _arg_3);
        }

        public function RenderSubTypeAndFrameTransform(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:String, _arg_6:Number, _arg_7:Number, _arg_8:Number):void
        {
            var _local_9:Number = global.ui.mZoom.mFactorDivDefaultZoom;
            _arg_1 = (_arg_1 * _local_9);
            _arg_2 = (_arg_2 * _local_9);
            this.RenderSubTypeAndFrameTransformNoScaling(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8);
        }

        public function SetSubTypeAndFrame(_arg_1:int, _arg_2:int):void
        {
            this.mSubType = _arg_1;
            this.mFrame = _arg_2;
        }

        public function SetContainer(_arg_1:Object):void
        {
            if (_arg_1 != this.mSpriteLibContainer)
            {
                this.mSpriteLibContainer = (_arg_1 as cSpriteLibContainer);
                this.SetSubTypeAndFrame(0, 0);
            };
        }

        private function fastCeil(_arg_1:Number):Number
        {
            return ((_arg_1 == int(_arg_1)) ? _arg_1 : ((_arg_1 >= 0) ? int((_arg_1 + 1)) : int(_arg_1)));
        }

        public function RenderPosNoScalingNoAlpha(_arg_1:int, _arg_2:int):void
        {
            var _local_3:dFrameCalculated = this.mSpriteLibContainer.getFrameCalculated(this.mSubType, this.mFrame);
            if (_local_3 == null)
            {
                return;
            };
            _local_3.applyFilter = ((gGfxResource.IsFilterActive()) && (this.IsFilterApplyable()));
            var _local_4:int = ((_arg_1 + _local_3.frameOffsXScaledCache) - global.ui.mZoom.mCacheZoomInvScaleScrollPosXMinusHalfScreenWidth);
            var _local_5:int = ((_arg_2 + _local_3.frameOffsYScaledCache) - global.ui.mZoom.mCacheZoomInvScaleScrollPosYMinusHalfScreenHeight);
            cBackbuffer.CopyPixels(_local_3, _local_4, _local_5, false);
        }

        public function SetAnimFrame(_arg_1:Number):void
        {
            this.mAnimFrame = _arg_1;
        }

        public function GetNofSubTypes():int
        {
            var _local_1:Vector.<dSubtypeCalculated> = this.mSpriteLibContainer.mSubtypeCalculated_vector;
            return (_local_1.length);
        }

        public function GetContainer():cSpriteLibContainer
        {
            return (this.mSpriteLibContainer);
        }

        public function RenderOutline(_arg_1:int, _arg_2:int):void
        {
            var _local_3:dFrameCalculated = this.mSpriteLibContainer.getFrameCalculated(this.mSubType, this.mFrame);
            if (_local_3 == null)
            {
                return;
            };
            var _local_4:int = ((_arg_1 + _local_3.frameOffsXScaledCache) - global.ui.mZoom.mCacheZoomInvScaleScrollPosXMinusHalfScreenWidth);
            var _local_5:int = ((_arg_2 + _local_3.frameOffsYScaledCache) - global.ui.mZoom.mCacheZoomInvScaleScrollPosYMinusHalfScreenHeight);
            var _local_6:BitmapData = _local_3.getHighlightBitmap();
            if (_local_6 != null)
            {
                cBackbuffer.CopyPixels2(_local_6, _local_4, _local_5, true);
            };
        }

        public function GetWidth():int
        {
            var _local_1:dFrameCalculated = this.mSpriteLibContainer.getFrameCalculated(this.mSubType, this.mAnimFrame);
            return ((_local_1 != null) ? _local_1.size_u : 0);
        }

        public function GetNofFrames(_arg_1:int):int
        {
            if (_arg_1 == -1)
            {
                _arg_1 = this.mSubType;
            };
            var _local_2:dSubtypeCalculated = this.mSpriteLibContainer.getSubtypeCalculated(_arg_1);
            return ((_local_2 != null) ? _local_2.numFrames : 0);
        }

        public function Reset():void
        {
            this.mSpriteLibContainer = null;
            this.mSubType = -1;
            this.mAnimFrame = 0;
            this.mFrame = -1;
            this.mAnimLoop = false;
        }

        public function SetRandomAnimFrame():void
        {
            this.mAnimFrame = gMisc.GetRandomMinMaxInt(0, (this.GetNofFrames(this.mSubType) - 1));
        }

        public function SetSubType(_arg_1:int):void
        {
            if (this.mSubType == _arg_1)
            {
                return;
            };
            this.mSubType = _arg_1;
            this.mFrame = -1;
        }

        public function SetAnim(_arg_1:Number, _arg_2:Boolean):void
        {
            if (_arg_1 < 0)
            {
                _arg_1 = 0;
            };
            this.mAnimFrame = 0;
            this.mAnimSpeed = _arg_1;
            this.mAnimLoop = _arg_2;
        }

        public function RenderSubTypeAndFrameNoScaling(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:Boolean=false):void
        {
            if (_arg_3 != -1)
            {
                this.mSubType = _arg_3;
                this.mFrame = _arg_4;
            };
            var _local_6:dFrameCalculated = this.mSpriteLibContainer.getFrameCalculated(this.mSubType, this.mFrame);
            if (_local_6 == null)
            {
                return;
            };
            _local_6.enforceAntialias = _arg_5;
            _local_6.applyFilter = ((gGfxResource.IsFilterActive()) && (this.IsFilterApplyable()));
            var _local_7:int = ((_arg_1 + _local_6.frameOffsXScaledCache) - global.ui.mZoom.mCacheZoomInvScaleScrollPosXMinusHalfScreenWidth);
            var _local_8:int = ((_arg_2 + _local_6.frameOffsYScaledCache) - global.ui.mZoom.mCacheZoomInvScaleScrollPosYMinusHalfScreenHeight);
            cBackbuffer.CopyPixels(_local_6, _local_7, _local_8, true);
        }

        public function SetRandomSubType():void
        {
            this.mSubType = gMisc.GetRandomMinMaxInt(0, (this.GetNofSubTypes() - 1));
        }

        public function GetHeight():int
        {
            var _local_1:dFrameCalculated = this.mSpriteLibContainer.getFrameCalculated(this.mSubType, this.mAnimFrame);
            return ((_local_1 != null) ? _local_1.size_v : 0);
        }

        public function RenderPos(_arg_1:int, _arg_2:int):void
        {
            this.RenderSubTypeAndFrame(_arg_1, _arg_2, this.mSubType, this.mAnimFrame);
        }

        private function IsFilterApplyable():Boolean
        {
            return ((this.mSpriteLibContainer.mIgnoreFilterMask & (1 << gGfxResource.gUseFilterType)) == 0);
        }


    }
}
