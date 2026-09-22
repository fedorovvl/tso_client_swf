package nLib
{
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import nLib.SpriteLibDataClass.dFrameCalculated;
    import mx.core.UIComponent;
    import flash.geom.Matrix;
    import __AS3__.vec.*;

    public class cBackbuffer 
    {

        public static const ACTIVATE_SEGMENTBUFFER:Boolean = true;
        public static var mBackBuffer:BitmapData;
        public static var mBackBufferRect:Rectangle;
        public static var mClipMinX:int;
        public static var mClipMinY:int;
        public static var mClipMaxX:int;
        public static var mClipMaxY:int;
        public static var currentColorTransform:ColorTransform = null;
        public static var colortransform_outline1:ColorTransform = new ColorTransform(0.2, 0.2, 0.2, 0.8, 0, 0, 0, 0);
        public static var colortransform_outline2:ColorTransform = new ColorTransform(0.2, 0.2, 0.2, 0.2, 0, 0, 0, 0);
        private static var mTempRect:Rectangle = new Rectangle();
        private static var mTempPos:Point = new Point();
        private static var mBackbufferDictionary:Dictionary = new Dictionary();
        private static var mBackBufferCache:Vector.<cBackbufferSegment> = new Vector.<cBackbufferSegment>();
        private static var mTransparent:Boolean;
        public static const mWidthSegment:int = 0x0100;
        public static const mHeightSegment:int = 0x0100;
        private static const mWidthSegmentShift:int = 8;
        private static const mHeightSegmentShift:int = 8;
        private static var mRedirectToSegmentBuffer:Boolean;
        internal static const REDIRECT_TARGET_BACKGROUND:int = 0;
        private static const REDIRECT_TARGET_FOG:int = 1;
        private static var redirectTarget:int = REDIRECT_TARGET_BACKGROUND;//0


        public static function SetDefaultClipping():void
        {
            mClipMinX = 0;
            mClipMinY = 0;
            mClipMaxX = mBackBuffer.width;
            mClipMaxY = mBackBuffer.height;
        }

        public static function UpdateSegmentBuffer(_arg_1:int, _arg_2:int):void
        {
            var _local_8:int;
            var _local_3:int = global.ui.mZoom.InvScale(_arg_1, cZoom.HUNDRED_PERCENT_ZOOM);
            var _local_4:int = global.ui.mZoom.InvScale(_arg_2, cZoom.HUNDRED_PERCENT_ZOOM);
            var _local_5:int = (_local_3 + mBackBuffer.width);
            var _local_6:int = (_local_4 + mBackBuffer.height);
            _local_3 = ((_local_3 >> mWidthSegmentShift) - 1);
            _local_4 = ((_local_4 >> mHeightSegmentShift) - 1);
            _local_5 = ((_local_5 >> mWidthSegmentShift) + 1);
            _local_6 = ((_local_6 >> mHeightSegmentShift) + 1);
            var _local_7:int = _local_4;
            while (_local_7 < _local_6)
            {
                _local_8 = _local_3;
                while (_local_8 < _local_5)
                {
                    getSegmentBackbuffer(cBackbufferSegment.getIndex(_local_8, _local_7));
                    _local_8++;
                };
                _local_7++;
            };
        }

        public static function InitSegmentBuffer(_arg_1:Boolean):void
        {
            if (!ACTIVATE_SEGMENTBUFFER)
            {
                return;
            };
            mTransparent = _arg_1;
            verifyBackbufferCacheSize();
        }

        private static function isSegmentInside(_arg_1:cBackbufferSegment):Boolean
        {
            return (isInside(_arg_1.getXP(), _arg_1.getYP()));
        }

        private static function CopyFromSegmentBufferInternal(_arg_1:Rectangle, _arg_2:int):void
        {
            var _local_3:cBackbufferSegment;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:Rectangle;
            for each (_local_3 in mBackbufferDictionary)
            {
                if (_local_3.shouldBeDrawn(_arg_2))
                {
                    mTempPos.x = _local_3.getXP();
                    mTempPos.y = _local_3.getYP();
                    _local_4 = _local_3.getXP();
                    _local_5 = _local_3.getYP();
                    _local_6 = (_local_3.getXP() + mWidthSegment);
                    _local_7 = (_local_3.getYP() + mHeightSegment);
                    if (_local_4 < _arg_1.x)
                    {
                        mTempPos.x = (mTempPos.x + (_arg_1.x - _local_4));
                        _local_4 = _arg_1.x;
                    };
                    if (_local_5 < _arg_1.y)
                    {
                        mTempPos.y = (mTempPos.y + (_arg_1.y - _local_5));
                        _local_5 = _arg_1.y;
                    };
                    if (_local_6 > (_arg_1.x + _arg_1.width))
                    {
                        _local_6 = (_arg_1.x + _arg_1.width);
                    };
                    if (_local_7 > (_arg_1.y + _arg_1.height))
                    {
                        _local_7 = (_arg_1.y + _arg_1.height);
                    };
                    mTempRect.x = (_local_4 - _local_3.getXP());
                    mTempRect.y = (_local_5 - _local_3.getYP());
                    mTempRect.width = (_local_6 - _local_4);
                    mTempRect.height = (_local_7 - _local_5);
                    mTempPos.x = (mTempPos.x - _arg_1.x);
                    mTempPos.y = (mTempPos.y - _arg_1.y);
                    mBackBuffer.copyPixels(_local_3.getBitmap(_arg_2), mTempRect, mTempPos, null, null, (_arg_2 == REDIRECT_TARGET_FOG));
                    if (global.ui.showSegmentBuffer)
                    {
                        _local_8 = (_local_3.getXP() - _arg_1.x);
                        _local_9 = (_local_3.getYP() - _arg_1.y);
                        _local_10 = new Rectangle(_local_8, _local_9, mWidthSegment, 2);
                        mBackBuffer.fillRect(_local_10, 0xFF00);
                        _local_10.top = ((_local_9 + mHeightSegment) - 2);
                        _local_10.height = 2;
                        mBackBuffer.fillRect(_local_10, 0xFF00);
                        _local_10.left = _local_8;
                        _local_10.top = _local_9;
                        _local_10.width = 2;
                        _local_10.height = mHeightSegment;
                        mBackBuffer.fillRect(_local_10, 0xFF00);
                        _local_10.left = ((_local_8 + mWidthSegment) - 2);
                        _local_10.width = 2;
                        mBackBuffer.fillRect(_local_10, 0xFF00);
                        globalFlash.gui.WriteDebugText(mBackBuffer, _local_3.id.toString(), (_local_8 + 10), (_local_9 + 10));
                    };
                };
            };
        }

        public static function preRenderFogCache():void
        {
            SetRedirectToSegmentBuffer(true);
            redirectTarget = REDIRECT_TARGET_FOG;
        }

        public static function setSegmentBackgroundClear():void
        {
            var _local_1:cBackbufferSegment;
            for each (_local_1 in mBackBufferCache)
            {
                if (_local_1.isUsed())
                {
                    _local_1.background.clear();
                };
            };
        }

        public static function Clear(_arg_1:uint):void
        {
            if (mRedirectToSegmentBuffer)
            {
                clearCache(_arg_1);
            }
            else
            {
                mBackBuffer.fillRect(mBackBufferRect, _arg_1);
            };
        }

        public static function CopyPixels(_arg_1:dFrameCalculated, _arg_2:int, _arg_3:int, _arg_4:Boolean):void
        {
            var _local_5:BitmapData;
            var _local_6:int;
            var _local_7:cBackbufferSegment;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            if (mRedirectToSegmentBuffer)
            {
                _local_8 = 0;
                _local_9 = (_arg_2 >> mWidthSegmentShift);
                _local_10 = (_arg_3 >> mHeightSegmentShift);
                _local_11 = ((_arg_2 + _arg_1.getScaledBitmapWidth()) >> mWidthSegmentShift);
                _local_12 = ((_arg_3 + _arg_1.getScaledBitmapHeight()) >> mHeightSegmentShift);
                _local_13 = _local_10;
                while (_local_13 <= _local_12)
                {
                    _local_14 = _local_9;
                    while (_local_14 <= _local_11)
                    {
                        if (isInside((_local_14 * mWidthSegment), (_local_13 * mHeightSegment)))
                        {
                            _local_7 = getSegmentBackbuffer(cBackbufferSegment.getIndex(_local_14, _local_13));
                            if (_local_7 != null)
                            {
                                mTempPos.x = (_arg_2 - _local_7.getXP());
                                mTempPos.y = (_arg_3 - _local_7.getYP());
                                _local_5 = _arg_1.getRenderBitmap(mRedirectToSegmentBuffer);
                                if (_local_5 != null)
                                {
                                    if (redirectTarget == REDIRECT_TARGET_FOG)
                                    {
                                        _local_7.fog.copyPixels(_local_5, _arg_1.renderRect, mTempPos, null, null, _arg_4);
                                    }
                                    else
                                    {
                                        _local_7.background.copyPixels(_local_5, _arg_1.renderRect, mTempPos, null, null, _arg_4);
                                    };
                                };
                            };
                        };
                        _local_14++;
                    };
                    _local_13++;
                };
            }
            else
            {
                if ((((((_arg_2 + _arg_1.getScaledBitmapWidth()) < mClipMinX) || ((_arg_3 + _arg_1.getScaledBitmapHeight()) < mClipMinY)) || (_arg_2 > mClipMaxX)) || (_arg_3 > mClipMaxY)))
                {
                    return;
                };
                _local_5 = _arg_1.getRenderBitmap(mRedirectToSegmentBuffer);
                if (_local_5 != null)
                {
                    mTempPos.x = _arg_2;
                    mTempPos.y = _arg_3;
                    mBackBuffer.copyPixels(_local_5, _arg_1.renderRect, mTempPos, null, null, _arg_4);
                };
            };
        }

        private static function clearCache(_arg_1:uint):void
        {
            var _local_2:cBackbufferSegment;
            for each (_local_2 in mBackBufferCache)
            {
                _local_2.free();
            };
            mBackbufferDictionary = new Dictionary();
        }

        public static function SetClippingXYWH(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            mClipMinX = _arg_1;
            mClipMinY = _arg_2;
            mClipMaxX = (_arg_3 + _arg_1);
            mClipMaxY = (_arg_4 + _arg_2);
        }

        public static function Init(_arg_1:int, _arg_2:int, _arg_3:Boolean):void
        {
            mBackBuffer = new BitmapData(_arg_1, _arg_2, _arg_3, defines.DEFAULT_BACKGROUND_CLEAR_COLOR);
            mBackBufferRect = mBackBuffer.rect;
            SetClippingXYWH(0, 0, _arg_1, _arg_2);
            SetRedirectToSegmentBuffer(false);
            verifyBackbufferCacheSize();
        }

        public static function CopyFromSegmentBuffer(_arg_1:Rectangle):void
        {
            CopyFromSegmentBufferInternal(_arg_1, REDIRECT_TARGET_BACKGROUND);
        }

        private static function findUnusedBackbuffer():cBackbufferSegment
        {
            var _local_1:cBackbufferSegment;
            for each (_local_1 in mBackBufferCache)
            {
                if (((!(_local_1.isUsed())) && (!(_local_1 in mBackbufferDictionary))))
                {
                    return (_local_1);
                };
            };
            return (null);
        }

        public static function GetWidth():int
        {
            return (mBackBufferRect.width);
        }

        public static function setScreenPosition(_arg_1:int, _arg_2:int):void
        {
            mClipMinX = global.ui.mZoom.InvScale(_arg_1, cZoom.HUNDRED_PERCENT_ZOOM);
            mClipMinY = global.ui.mZoom.InvScale(_arg_2, cZoom.HUNDRED_PERCENT_ZOOM);
            mClipMaxX = (mClipMinX + mBackBuffer.width);
            mClipMaxY = (mClipMinY + mBackBuffer.height);
        }

        public static function CopyPixels2(_arg_1:BitmapData, _arg_2:int, _arg_3:int, _arg_4:Boolean):void
        {
            var _local_5:int;
            var _local_6:cBackbufferSegment;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            if (mRedirectToSegmentBuffer)
            {
                _local_7 = 0;
                _local_8 = (_arg_2 >> mWidthSegmentShift);
                _local_9 = (_arg_3 >> mHeightSegmentShift);
                _local_10 = ((_arg_2 + _arg_1.width) >> mWidthSegmentShift);
                _local_11 = ((_arg_3 + _arg_1.height) >> mHeightSegmentShift);
                _local_12 = _local_9;
                while (_local_12 <= _local_11)
                {
                    _local_13 = _local_8;
                    while (_local_13 <= _local_10)
                    {
                        if (isInside((_local_13 * mWidthSegment), (_local_12 * mHeightSegment)))
                        {
                            _local_6 = getSegmentBackbuffer(cBackbufferSegment.getIndex(_local_13, _local_12));
                            if (_local_6 != null)
                            {
                                mTempPos.x = (_arg_2 - _local_6.getXP());
                                mTempPos.y = (_arg_3 - _local_6.getYP());
                                if (_arg_1 != null)
                                {
                                    if (redirectTarget == REDIRECT_TARGET_FOG)
                                    {
                                        _local_6.fog.copyPixels(_arg_1, _arg_1.rect, mTempPos, null, null, _arg_4);
                                    }
                                    else
                                    {
                                        _local_6.background.copyPixels(_arg_1, _arg_1.rect, mTempPos, null, null, _arg_4);
                                    };
                                };
                            };
                        };
                        _local_13++;
                    };
                    _local_12++;
                };
            }
            else
            {
                if ((((((_arg_2 + _arg_1.width) < mClipMinX) || ((_arg_3 + _arg_1.height) < mClipMinY)) || (_arg_2 > mClipMaxX)) || (_arg_3 > mClipMaxY)))
                {
                    return;
                };
                if (_arg_1 != null)
                {
                    mTempPos.x = _arg_2;
                    mTempPos.y = _arg_3;
                    mBackBuffer.copyPixels(_arg_1, _arg_1.rect, mTempPos, null, null, _arg_4);
                };
            };
        }

        private static function verifyBackbufferCacheSize():void
        {
            var _local_7:cBackbufferSegment;
            var _local_1:UIComponent = (global.getApplication() as UIComponent);
            var _local_2:Number = _local_1.stage.width;
            var _local_3:Number = _local_1.stage.height;
            var _local_4:int = int((1 + Math.ceil((_local_2 / mWidthSegment))));
            var _local_5:int = int((1 + Math.ceil((_local_3 / mHeightSegment))));
            var _local_6:int = (_local_4 * _local_5);
            while (mBackBufferCache.length < _local_6)
            {
                _local_7 = new cBackbufferSegment(mWidthSegment, mHeightSegment, mTransparent);
                mBackBufferCache.push(_local_7);
            };
            if (mBackBufferCache.length > _local_6)
            {
                clearCache(defines.DEFAULT_BACKGROUND_CLEAR_COLOR);
                mBackBufferCache.splice(_local_6, (mBackBufferCache.length - _local_6));
            };
        }

        private static function getSegmentBackbuffer(_arg_1:int):cBackbufferSegment
        {
            var _local_2:cBackbufferSegment = mBackbufferDictionary[_arg_1];
            if (((!(_local_2 == null)) && (_local_2.isUsed())))
            {
                return (_local_2);
            };
            _local_2 = findUnusedBackbuffer();
            if (_local_2 != null)
            {
                mBackbufferDictionary[_arg_1] = _local_2;
                _local_2.reuse(_arg_1);
            };
            return (_local_2);
        }

        private static function isInside(_arg_1:int, _arg_2:int):Boolean
        {
            if (_arg_1 <= (mClipMinX - mWidthSegment))
            {
                return (false);
            };
            if (_arg_2 <= (mClipMinY - mHeightSegment))
            {
                return (false);
            };
            if (((_arg_1 > mClipMaxX) || (_arg_2 > mClipMaxY)))
            {
                return (false);
            };
            return (true);
        }

        public static function RemoveUnusedSegments(_arg_1:int, _arg_2:int, _arg_3:uint):void
        {
            var _local_4:cBackbufferSegment;
            for each (_local_4 in mBackbufferDictionary)
            {
                if (_local_4.isUsed())
                {
                    if (isSegmentInside(_local_4))
                    {
                        _local_4.background.redrawn();
                    }
                    else
                    {
                        delete mBackbufferDictionary[_local_4.getIndex()];
                        _local_4.free();
                    };
                };
            };
        }

        public static function getSegmentClipping():Rectangle
        {
            var _local_2:cBackbufferSegment;
            var _local_1:Rectangle = new Rectangle();
            for each (_local_2 in mBackBufferCache)
            {
                if (_local_2.isUsed())
                {
                    if (_local_1.x > _local_2.getXP())
                    {
                        _local_1.x = _local_2.getXP();
                    };
                    if (_local_1.y > _local_2.getYP())
                    {
                        _local_1.y = _local_2.getYP();
                    };
                    if (_local_1.right < (_local_2.getXP() + mWidthSegment))
                    {
                        _local_1.right = (_local_2.getXP() + mWidthSegment);
                    };
                    if (_local_1.bottom < (_local_2.getYP() + mHeightSegment))
                    {
                        _local_1.bottom = (_local_2.getYP() + mHeightSegment);
                    };
                };
            };
            _local_1.x = (_local_1.x + mClipMinX);
            _local_1.y = (_local_1.y + mClipMinY);
            return (_local_1);
        }

        public static function CopyFogFromSegmentBuffer(_arg_1:Rectangle):void
        {
            CopyFromSegmentBufferInternal(_arg_1, REDIRECT_TARGET_FOG);
        }

        public static function postRenderFogCache():void
        {
            var _local_1:cBackbufferSegment;
            SetRedirectToSegmentBuffer(false);
            redirectTarget = REDIRECT_TARGET_BACKGROUND;
            for each (_local_1 in mBackbufferDictionary)
            {
                _local_1.fog.redrawn();
            };
        }

        public static function Lock():void
        {
            mBackBuffer.lock();
        }

        public static function clearFogCache():void
        {
            var _local_1:cBackbufferSegment;
            for each (_local_1 in mBackBufferCache)
            {
                _local_1.fog.clear();
            };
        }

        public static function Unlock():void
        {
            mBackBuffer.unlock();
        }

        public static function Draw(_arg_1:BitmapData, _arg_2:Matrix, _arg_3:String, _arg_4:Rectangle):void
        {
            if (!mRedirectToSegmentBuffer)
            {
                if ((((((_arg_2.tx + _arg_1.width) < mClipMinX) || ((_arg_2.ty + _arg_1.height) < mClipMinY)) || (_arg_2.tx > mClipMaxX)) || (_arg_2.ty > mClipMaxY)))
                {
                    return;
                };
                mBackBuffer.draw(_arg_1, _arg_2, currentColorTransform, _arg_3, _arg_4, true);
            };
        }

        public static function SetRedirectToSegmentBuffer(_arg_1:Boolean):void
        {
            if (!ACTIVATE_SEGMENTBUFFER)
            {
                mRedirectToSegmentBuffer = false;
                return;
            };
            mRedirectToSegmentBuffer = _arg_1;
        }

        public static function GetHeight():int
        {
            return (mBackBufferRect.height);
        }


    }
}
