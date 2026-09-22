package nLib
{
    import Model.Notifier;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import nLib.SpriteLibDataClass.dMain;
    import __AS3__.vec.Vector;
    import nLib.SpriteLibDataClass.dSubtypeCalculated;
    import flash.display.DisplayObject;
    import flash.display.BitmapData;
    import flash.events.Event;
    import nLib.SpriteLibDataClass.dFrameCalculated;
    import flash.geom.Matrix;
    import nLib.SpriteLibDataClass.dIndices;
    import GUI.Assets.gAssetManager;
    import flash.utils.ByteArray;
    import __AS3__.vec.*;

    public class cSpriteLibContainer extends Notifier 
    {

        public static const LOADING_DONE:String = "LOADING_DONE";
        public static var mActivateAntialiasing:Boolean = false;
        private static var mTempRect:Rectangle = new Rectangle();
        private static var mTempRect2:Rectangle = new Rectangle();
        private static var mTempPoint:Point = new Point();
        private static var mTempPoint2:Point = new Point();
        private static var mNullPoint:Point = new Point(0, 0);

        public var mIgnoreFilterMask:int = 0;
        public var mStreamingFinished:Boolean = false;
        private var mSpriteContainer:cSpriteContainer;
        public var mSpriteLib:dMain = new dMain();
        public var mSubtypeCalculated_vector:Vector.<dSubtypeCalculated> = new Vector.<dSubtypeCalculated>();
        public var mDeltaCompression:Boolean = true;
        public var mStreamFrame:int = -1;
        public var mLoadingFinished:Boolean = false;
        public var mExternalData:Object = null;
        public var mLoadingFinishedLib:Boolean = false;
        public var useDefaultHighlight:Boolean = false;
        public var mNofStreamUpgrades:int = 0;
        private var mSpriteIsUsed:Boolean = false;
        public var mStreamingInProgress:Boolean = false;
        public var mStream:Boolean = true;
        public var mLoadedSpriteLib:dMain;
        public var mOriginalGraphicsImage:DisplayObject = null;
        public var mSubtypeCalculatedNof:int;
        private var mDispatcherLoadAll:cCustomDispatcher = new cCustomDispatcher();
        private var mLibLoadedCallback:Function;
        public var mId:int = -1;
        public var mOriginalGraphicsImageBitmapData:BitmapData = null;
        public var mStreamSubtype:int = -1;
        public var mStreamSubtypeAndFrameState:int = 0;
        public var mAnimationSpeed:Number = 1;
        public var mRefreshAfterStream:Boolean;
        public var mOriginalScaleFactor:Number = 1000;
        public var mFileName_string:String;

        public function cSpriteLibContainer(_arg_1:String, _arg_2:Function, _arg_3:int, _arg_4:Boolean, _arg_5:Boolean, _arg_6:int)
        {
            super();
            this.mStreamingInProgress = false;
            if (_arg_1 == null)
            {
                return;
            };
            if (_arg_2 == null)
            {
                _arg_2 = this.dummyFinished;
            };
            this.mOriginalScaleFactor = _arg_3;
            this.mStream = _arg_5;
            this.mStreamingFinished = false;
            this.mNofStreamUpgrades = _arg_6;
            if (_arg_5)
            {
                this.mDeltaCompression = _arg_4;
                this.SetToStreamDummyGfxReplacement();
                this.mFileName_string = _arg_1;
                this.mLoadingFinished = false;
                this.mDispatcherLoadAll = new cCustomDispatcher();
                this.mDispatcherLoadAll.addEventListener(cCustomDispatcher.mAction_string, _arg_2);
            }
            else
            {
                this.mStreamSubtypeAndFrameState = 1;
                this.mStreamSubtype = 0;
                this.mStreamFrame = 0;
                this.LoadAll(_arg_1, _arg_2, _arg_4);
            };
        }

        private function fastCeil(_arg_1:Number):Number
        {
            return ((_arg_1 == int(_arg_1)) ? _arg_1 : ((_arg_1 >= 0) ? int((_arg_1 + 1)) : int(_arg_1)));
        }

        public function CreateObject():cSpriteLib
        {
            var _local_1:cSpriteLib = new cSpriteLib();
            _local_1.SetContainer(this);
            return (_local_1);
        }

        public function GetSpritePackIDByNameNr(_arg_1:String):int
        {
            var _local_2:String = _arg_1.toLowerCase();
            var _local_3:int;
            while (_local_3 < this.mSpriteLib.spriteIndices_vector.length)
            {
                if (this.mSpriteLib.spriteIndices_vector[_local_3].name_string == _local_2)
                {
                    return (_local_3);
                };
                _local_3++;
            };
            return (-1);
        }

        public function IsStreamingActiveIfNotActivate(_arg_1:int, _arg_2:int):Boolean
        {
            this.mSpriteIsUsed = true;
            if (this.mNofStreamUpgrades != 0)
            {
                if (this.mStreamSubtypeAndFrameState == 0)
                {
                    this.mStreamSubtypeAndFrameState = 1;
                    this.mStreamSubtype = _arg_1;
                    this.mStreamFrame = _arg_2;
                    this.mStreamingInProgress = false;
                    return (true);
                };
                if (this.mStreamSubtypeAndFrameState != 4)
                {
                    return (true);
                };
                if (this.mStreamSubtypeAndFrameState == 4)
                {
                    if (_arg_1 >= this.mSubtypeCalculatedNof)
                    {
                        this.mStreamSubtypeAndFrameState = 1;
                        this.mStreamSubtype = _arg_1;
                        this.mStreamFrame = _arg_2;
                        this.mStreamingInProgress = false;
                        this.mStream = true;
                        this.mStreamingFinished = false;
                        return (true);
                    };
                    if (_arg_2 >= this.mSubtypeCalculated_vector[_arg_1].numFrames)
                    {
                        this.mStreamSubtypeAndFrameState = 1;
                        this.mStreamSubtype = _arg_1;
                        this.mStreamFrame = _arg_2;
                        this.mStreamingInProgress = false;
                        this.mStream = true;
                        this.mStreamingFinished = false;
                        return (true);
                    };
                    if (this.mSubtypeCalculated_vector[_arg_1].frameList_vector[_arg_2].orginalBitmap == null)
                    {
                        this.mStreamSubtypeAndFrameState = 1;
                        this.mStreamSubtype = _arg_1;
                        this.mStreamFrame = _arg_2;
                        this.mStreamingInProgress = false;
                        this.mStream = true;
                        this.mStreamingFinished = false;
                        return (true);
                    };
                };
            };
            if (this.mStream)
            {
                return (true);
            };
            return (false);
        }

        private function LoadLib(_arg_1:String, _arg_2:Function):void
        {
            var _local_4:TSOURLLoader;
            this.mLoadingFinishedLib = false;
            this.mLibLoadedCallback = _arg_2;
            var _local_3:* = (_arg_1 + ".bin");
            if (this.mNofStreamUpgrades != 0)
            {
                _local_3 = this.CheckForSplitLibStreaming(_local_3, 1);
            };
            if (!this.LoadBinLib(_local_3))
            {
                _local_4 = new TSOURLLoader();
                _local_4.addEventListener(Event.COMPLETE, this.CompleteHandlerLoadLib, false, 0, true);
                _local_4.loadFile(_local_3);
            };
        }

        public function ActivateDispatcherEvent():void
        {
            if (this.mStream)
            {
                this.mLoadingFinished = true;
                this.mDispatcherLoadAll.doActionWithData(this.mFileName_string, this);
            };
        }

        public function SetDirty():void
        {
            var _local_2:Number;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:dSubtypeCalculated;
            var _local_6:dFrameCalculated;
            var _local_1:Number = this.mOriginalScaleFactor;
            if (global.ui != null)
            {
                _local_2 = global.ui.mZoom.mFactorDivDefaultZoom;
                for each (_local_5 in this.mSubtypeCalculated_vector)
                {
                    for each (_local_6 in _local_5.frameList_vector)
                    {
                        _local_6.clearScale();
                        _local_6.setScaledBitmapWidth(global.ui.mZoom.InvScale(_local_6.size_u, _local_1));
                        _local_6.setScaledBitmapHeight(global.ui.mZoom.InvScale(_local_6.size_v, _local_1));
                        _local_3 = (-((_local_5.seqFootX * 1000) / _local_1) + ((_local_6.frameOffsX * 1000) / _local_1));
                        _local_4 = (-((_local_5.seqFootY * 1000) / _local_1) + ((_local_6.frameOffsY * 1000) / _local_1));
                        _local_3 = (_local_3 * _local_2);
                        _local_4 = (_local_4 * _local_2);
                        _local_6.frameOffsXScaledCache = (_local_3 << 0);
                        _local_6.frameOffsYScaledCache = (_local_4 << 0);
                    };
                };
            };
        }

        public function getSubtypeCalculated(_arg_1:int):dSubtypeCalculated
        {
            var _local_2:dSubtypeCalculated = ((_arg_1 < this.mSubtypeCalculated_vector.length) ? this.mSubtypeCalculated_vector[_arg_1] : null);
            var _local_3:dFrameCalculated = (((!(_local_2 == null)) && (_local_2.frameList_vector.length > 0)) ? _local_2.frameList_vector[0] : null);
            this.mSpriteIsUsed = true;
            if (((_local_2 == null) || (_local_3.orginalBitmap == null)))
            {
                this.streamTypeAndFrame(_arg_1, 0);
                return (null);
            };
            return (_local_2);
        }

        public function PrepareScaling(_arg_1:Boolean):void
        {
            var _local_2:BitmapData;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_12:dSubtypeCalculated;
            var _local_13:int;
            var _local_14:BitmapData;
            var _local_15:dFrameCalculated;
            var _local_16:int;
            var _local_17:int;
            var _local_18:int;
            var _local_19:int;
            var _local_20:int;
            var _local_21:uint;
            var _local_22:Number;
            var _local_23:BitmapData;
            var _local_24:Matrix;
            var _local_3:Point = new Point(0, 0);
            var _local_8:Number = global.mGraphicScaleFactor;
            mTempRect2.x = 0;
            mTempRect2.y = 0;
            var _local_9:dIndices = this.mSpriteLib.spriteIndices_vector[0];
            var _local_10:int = _local_9.subtypeCalculated_vector.length;
            this.mSubtypeCalculated_vector = _local_9.subtypeCalculated_vector;
            this.mSubtypeCalculatedNof = this.mSubtypeCalculated_vector.length;
            var _local_11:int;
            while (_local_11 < _local_10)
            {
                _local_12 = _local_9.subtypeCalculated_vector[_local_11];
                _local_13 = _local_12.frameList_vector.length;
                _local_16 = 0;
                while (_local_16 < _local_13)
                {
                    _local_15 = _local_12.frameList_vector[_local_16];
                    if (_local_15.calculateRect != null)
                    {
                        _local_6 = _local_15.calculateRect.width;
                        _local_7 = _local_15.calculateRect.height;
                        if (_local_15.orginalBitmap != null)
                        {
                            _local_15.updateFilterCache();
                        }
                        else
                        {
                            if (_local_8 != 1)
                            {
                                _local_4 = this.fastCeil((_local_6 * _local_8));
                                _local_5 = this.fastCeil((_local_7 * _local_8));
                                _local_6 = int((_local_4 / _local_8));
                                _local_7 = int((_local_5 / _local_8));
                            };
                            _local_6 = Math.max(1, _local_6);
                            _local_7 = Math.max(1, _local_7);
                            _local_2 = new BitmapData((_local_6 + _local_15.imageOffsetX), (_local_7 + _local_15.imageOffsetY), true, 0);
                            _local_2.lock();
                            if (((!(_local_14 == null)) && (_arg_1)))
                            {
                                mTempRect2.x = 0;
                                mTempRect2.y = 0;
                                mTempRect2.width = _local_14.width;
                                mTempRect2.height = _local_14.height;
                                mTempPoint2.x = 0;
                                mTempPoint2.y = 0;
                                _local_2.copyPixels(_local_14, mTempRect2, mTempPoint2, null, null, false);
                                _local_20 = _local_15.imageOffsetY;
                                _local_22 = _local_15.calculateRect.right;
                                _local_18 = _local_15.calculateRect.top;
                                while (_local_18 < _local_15.calculateRect.bottom)
                                {
                                    _local_19 = _local_15.imageOffsetX;
                                    _local_17 = _local_15.calculateRect.left;
                                    while (_local_17 < _local_22)
                                    {
                                        _local_21 = this.mOriginalGraphicsImageBitmapData.getPixel32(_local_17, _local_18);
                                        if (_local_21 != 0xFFFF00FF)
                                        {
                                            _local_2.setPixel32(_local_19, _local_20, _local_21);
                                        };
                                        _local_19++;
                                        _local_17++;
                                    };
                                    _local_20++;
                                    _local_18++;
                                };
                                if (_local_15.imageOffsetX != 0)
                                {
                                    mTempRect.x = 0;
                                    mTempRect.y = 0;
                                    mTempRect.width = _local_15.imageOffsetX;
                                    mTempRect.height = _local_2.height;
                                    _local_2.fillRect(mTempRect, 0);
                                };
                                if (_local_15.imageOffsetY != 0)
                                {
                                    mTempRect.x = 0;
                                    mTempRect.y = 0;
                                    mTempRect.width = _local_2.width;
                                    mTempRect.height = _local_15.imageOffsetY;
                                    _local_2.fillRect(mTempRect, 0);
                                };
                            }
                            else
                            {
                                _local_3.x = _local_15.imageOffsetX;
                                _local_3.y = _local_15.imageOffsetY;
                                _local_2.copyPixels(this.mOriginalGraphicsImageBitmapData, _local_15.calculateRect, _local_3, null, null, false);
                            };
                            _local_14 = _local_2;
                            if (_local_8 != 1)
                            {
                                _local_4 = int((_local_2.width * _local_8));
                                _local_5 = int((_local_2.height * _local_8));
                                if (((_local_4 > 0) && (_local_5 > 0)))
                                {
                                    _local_23 = new BitmapData(_local_4, _local_5, true, 0);
                                    _local_24 = new Matrix();
                                    _local_24.scale(_local_8, _local_8);
                                    _local_23.draw(_local_2, _local_24, null, null, _local_23.rect, true);
                                    _local_2 = _local_23;
                                };
                            };
                            _local_15.setOriginalBitmap(_local_2);
                            _local_15.updateFilterCache();
                            _local_2.unlock();
                            _local_15.calculateRect = null;
                        };
                    };
                    _local_16++;
                };
                _local_11++;
            };
            _local_2 = null;
            _local_4 = null;
            _local_23 = null;
        }

        private function dummyFinished(_arg_1:Event):void
        {
        }

        public function SetToStreamDummyGfxReplacement():void
        {
            var _local_1:cSpriteLibContainer = gGfxResource.mStreamReplacementSpriteContainer;
            this.mSubtypeCalculated_vector = _local_1.mSubtypeCalculated_vector;
            this.mSubtypeCalculatedNof = this.mSubtypeCalculated_vector.length;
            this.mSpriteContainer = _local_1.mSpriteContainer;
        }

        public function setSpriteAsUsed():void
        {
            this.mSpriteIsUsed = true;
        }

        private function LoadBinLib(_arg_1:String):Boolean
        {
            var _local_3:dMain;
            var _local_4:dIndices;
            var _local_2:ByteArray = gAssetManager.GetBin(_arg_1);
            if (_local_2 == null)
            {
                return (false);
            };
            if (this.mNofStreamUpgrades != 0)
            {
                _local_3 = this.LoadSpriteLibFromBinaryData(_local_2);
                if (this.mLoadedSpriteLib == null)
                {
                    this.mLoadedSpriteLib = new dMain();
                    _local_4 = new dIndices();
                    this.mLoadedSpriteLib.spriteIndices_vector.push(_local_4);
                };
                if (this.mStreamSubtypeAndFrameState == 2)
                {
                    this.InsertSubTypeAndFrame(_local_3, this.mStreamSubtype, this.mStreamFrame);
                };
            }
            else
            {
                this.mLoadedSpriteLib = this.LoadSpriteLibFromBinaryData(_local_2);
            };
            this.mLoadingFinishedLib = true;
            this.mLibLoadedCallback();
            return (true);
        }

        public function LoadAll(_arg_1:String, _arg_2:Function, _arg_3:Boolean):void
        {
            this.mDeltaCompression = _arg_3;
            this.mLoadingFinished = false;
            this.mDispatcherLoadAll = new cCustomDispatcher();
            this.mDispatcherLoadAll.addEventListener(cCustomDispatcher.mAction_string, _arg_2);
            this.mFileName_string = _arg_1;
            var _local_4:String = gMisc.GetFileNameWithoutExtensionString(this.mFileName_string);
            this.LoadLib(_local_4, this.CompleteHandlerLoadAllLib);
        }

        public function LoadSpriteLibFromBinaryData(_arg_1:ByteArray):dMain
        {
            var _local_8:dIndices;
            var _local_9:int;
            var _local_10:int;
            var _local_11:dIndices;
            var _local_12:int;
            var _local_13:Vector.<int>;
            var _local_14:int;
            var _local_15:dSubtypeCalculated;
            var _local_16:int;
            var _local_17:int;
            var _local_18:int;
            var _local_19:int;
            var _local_20:int;
            var _local_21:int;
            var _local_22:int;
            var _local_23:int;
            var _local_24:int;
            var _local_25:int;
            var _local_26:int;
            var _local_27:int;
            var _local_28:int;
            var _local_29:int;
            var _local_30:int;
            var _local_31:int;
            var _local_32:int;
            var _local_33:int;
            var _local_34:int;
            var _local_35:int;
            var _local_36:int;
            var _local_37:int;
            var _local_38:int;
            var _local_39:int;
            var _local_40:int;
            var _local_41:dFrameCalculated;
            var _local_2:dMain = new dMain();
            gBinaryStream.InitBinaryStream(_arg_1, 0);
            var _local_3:int = gBinaryStream.ReadInt();
            var _local_4:ByteArray = _arg_1;
            var _local_5:Vector.<int> = new Vector.<int>();
            _local_2.spriteIndices_vector = new Vector.<dIndices>();
            var _local_6:int;
            while (_local_6 < _local_3)
            {
                _local_8 = new dIndices();
                _local_9 = gBinaryStream.ReadInt();
                _local_10 = gBinaryStream.ReadInt();
                _local_8.name_string = gBinaryStream.ReadCStringAtPos_string(_local_9);
                _local_5.push(_local_10);
                _local_2.spriteIndices_vector.push(_local_8);
                _local_6++;
            };
            var _local_7:int;
            while (_local_7 < _local_3)
            {
                _local_11 = _local_2.spriteIndices_vector[_local_7];
                gBinaryStream.InitBinaryStream(_local_4, _local_5[_local_7]);
                _local_12 = gBinaryStream.ReadInt();
                _local_13 = new Vector.<int>(_local_12);
                _local_14 = 0;
                while (_local_14 < _local_12)
                {
                    _local_13[_local_14] = gBinaryStream.ReadInt();
                    _local_14++;
                };
                _local_11.subtypeCalculated_vector = new Vector.<dSubtypeCalculated>();
                _local_14 = 0;
                while (_local_14 < _local_12)
                {
                    _local_15 = new dSubtypeCalculated();
                    _local_16 = _local_13[_local_14];
                    gBinaryStream.InitBinaryStream(_local_4, _local_16);
                    _local_17 = gBinaryStream.ReadShort();
                    _local_18 = gBinaryStream.ReadShort();
                    _local_19 = gBinaryStream.ReadShort();
                    _local_20 = gBinaryStream.ReadShort();
                    _local_21 = gBinaryStream.ReadShort();
                    _local_22 = gBinaryStream.ReadShort();
                    _local_15.seqFootX = _local_18;
                    _local_15.seqFootY = _local_19;
                    _local_15.numFrames = _local_22;
                    _local_23 = gBinaryStream.a;
                    _local_24 = 32767;
                    _local_25 = 32767;
                    _local_26 = 0;
                    while (_local_26 < _local_22)
                    {
                        gBinaryStream.a = (gBinaryStream.a + 16);
                        _local_28 = gBinaryStream.ReadShort();
                        _local_29 = gBinaryStream.ReadShort();
                        if (_local_28 < _local_24)
                        {
                            _local_24 = _local_28;
                        };
                        if (_local_29 < _local_25)
                        {
                            _local_25 = _local_29;
                        };
                        _local_26++;
                    };
                    gBinaryStream.a = _local_23;
                    _local_27 = 0;
                    while (_local_27 < _local_22)
                    {
                        _local_30 = gBinaryStream.ReadShort();
                        gBinaryStream.ReadShort();
                        _local_31 = gBinaryStream.ReadShort();
                        _local_32 = gBinaryStream.ReadShort();
                        _local_33 = gBinaryStream.ReadShort();
                        _local_34 = gBinaryStream.ReadShort();
                        _local_35 = gBinaryStream.ReadShort();
                        _local_36 = gBinaryStream.ReadShort();
                        _local_37 = gBinaryStream.ReadShort();
                        _local_38 = gBinaryStream.ReadShort();
                        _local_39 = (_local_37 - _local_24);
                        _local_40 = (_local_38 - _local_25);
                        _local_41 = new dFrameCalculated();
                        _local_41.size_u = (_local_35 + _local_39);
                        _local_41.size_v = (_local_36 + _local_40);
                        _local_41.frameOffsX = _local_24;
                        _local_41.frameOffsY = _local_25;
                        _local_41.calculateRect = new Rectangle(_local_33, _local_34, (_local_35 - 1), (_local_36 - 1));
                        _local_41.imageOffsetX = _local_39;
                        _local_41.imageOffsetY = _local_40;
                        _local_15.frameList_vector.push(_local_41);
                        _local_27++;
                    };
                    _local_11.subtypeCalculated_vector.push(_local_15);
                    _local_14++;
                };
                _local_7++;
            };
            return (_local_2);
        }

        public function GetSpritePackIDByName(_arg_1:String):dIndices
        {
            var _local_3:dIndices;
            var _local_2:String = _arg_1.toLowerCase();
            for each (_local_3 in this.mSpriteLib.spriteIndices_vector)
            {
                if (_local_3.name_string == _local_2)
                {
                    return (_local_3);
                };
            };
            return (null);
        }

        private function CompleteHandlerLoadAllLib():void
        {
            this.mSpriteContainer = new cSpriteContainer();
            var _local_1:String = this.mFileName_string;
            if (((!(this.mNofStreamUpgrades == 0)) || (true)))
            {
                _local_1 = this.CheckForSplitLibStreaming(_local_1, 2);
            };
            this.mSpriteContainer.LoadGfx(_local_1, this.CompleteHandlerLoadAll);
        }

        private function CompleteHandlerLoadLib(_arg_1:Event):void
        {
            var _local_3:dMain;
            var _local_4:dIndices;
            var _local_2:TSOURLLoader = (_arg_1.target as TSOURLLoader);
            _local_2.removeEventListener(Event.COMPLETE, this.CompleteHandlerLoadLib);
            if (this.mNofStreamUpgrades != 0)
            {
                _local_3 = this.LoadSpriteLibFromBinaryData(_local_2.data);
                if (this.mLoadedSpriteLib == null)
                {
                    this.mLoadedSpriteLib = new dMain();
                    _local_4 = new dIndices();
                    this.mLoadedSpriteLib.spriteIndices_vector.push(_local_4);
                };
                if (this.mStreamSubtypeAndFrameState == 2)
                {
                    this.InsertSubTypeAndFrame(_local_3, this.mStreamSubtype, this.mStreamFrame);
                };
            }
            else
            {
                this.mLoadedSpriteLib = this.LoadSpriteLibFromBinaryData(_local_2.data);
            };
            this.mLoadingFinishedLib = true;
            this.mLibLoadedCallback();
            _local_2.dispose();
            _local_2 = null;
        }

        public function streamTypeAndFrame(_arg_1:int, _arg_2:int):void
        {
            if (this.mNofStreamUpgrades != 0)
            {
                switch (this.mStreamSubtypeAndFrameState)
                {
                    case 0:
                    case 4:
                        this.mStreamSubtypeAndFrameState = 1;
                        this.mStreamSubtype = _arg_1;
                        this.mStreamFrame = _arg_2;
                        this.mStreamingInProgress = false;
                        this.mStream = true;
                        this.mStreamingFinished = false;
                        return;
                    default:
                        return;
                };
            };
        }

        public function CheckForSplitLibStreaming(_arg_1:String, _arg_2:int):String
        {
            var _local_4:String;
            var _local_5:String;
            var _local_3:String = _arg_1;
            if (this.mStreamSubtypeAndFrameState == _arg_2)
            {
                this.mStreamSubtypeAndFrameState++;
                _local_4 = gMisc.GetExtensionString(_arg_1);
                _local_5 = gMisc.GetFileNameWithoutExtensionString(_arg_1);
                _local_3 = ((((((_local_5 + "[") + this.mStreamSubtype) + "_") + this.mStreamFrame) + "]") + _local_4);
            };
            return (_local_3);
        }

        public function getFrameCalculated(_arg_1:int, _arg_2:int):dFrameCalculated
        {
            var _local_3:Vector.<dSubtypeCalculated> = this.mSubtypeCalculated_vector;
            var _local_4:dSubtypeCalculated = ((_arg_1 < _local_3.length) ? _local_3[_arg_1] : null);
            var _local_5:dFrameCalculated = (((!(_local_4 == null)) && (_arg_2 < _local_4.frameList_vector.length)) ? _local_4.frameList_vector[_arg_2] : null);
            this.mSpriteIsUsed = true;
            if ((((!(this.mStreamingFinished)) || (_local_5 == null)) || (_local_5.orginalBitmap == null)))
            {
                this.streamTypeAndFrame(_arg_1, _arg_2);
                return (null);
            };
            return (_local_5);
        }

        public function isLoaded(_arg_1:int, _arg_2:int):Boolean
        {
            this.mSpriteIsUsed = true;
            if (!this.mStreamingFinished)
            {
                return (false);
            };
            var _local_3:Vector.<dSubtypeCalculated> = this.mSubtypeCalculated_vector;
            if (_arg_1 >= _local_3.length)
            {
                return (false);
            };
            var _local_4:dSubtypeCalculated = _local_3[_arg_1];
            if (_arg_2 >= _local_4.frameList_vector.length)
            {
                return (false);
            };
            var _local_5:dFrameCalculated = (((!(_local_4 == null)) && (_arg_2 < _local_4.frameList_vector.length)) ? _local_4.frameList_vector[_arg_2] : null);
            return (!(_local_5.orginalBitmap == null));
        }

        public function IsStreamingEnabled():Boolean
        {
            if (this.mNofStreamUpgrades != 0)
            {
                if (this.mStreamSubtypeAndFrameState != 1)
                {
                    return (false);
                };
            };
            return (true);
        }

        private function CompleteHandlerLoadAll():void
        {
            this.mLoadingFinished = true;
            this.PostProcessGfxLoading();
            if (this.mNofStreamUpgrades != 0)
            {
                if (this.mStreamSubtypeAndFrameState == 3)
                {
                    this.mStreamSubtypeAndFrameState++;
                };
            };
            this.mDispatcherLoadAll.doActionWithData(this.mFileName_string, this);
        }

        public function isSpriteUsed():Boolean
        {
            return (this.mSpriteIsUsed);
        }

        private function InsertSubTypeAndFrame(_arg_1:dMain, _arg_2:int, _arg_3:int):void
        {
            var _local_6:int;
            var _local_7:int;
            var _local_8:dSubtypeCalculated;
            var _local_9:int;
            var _local_4:int = _arg_2;
            var _local_5:int = _arg_3;
            if (_local_4 >= this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector.length)
            {
                _local_6 = (this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector.length - 1);
                while (_local_6 < _local_4)
                {
                    _local_8 = new dSubtypeCalculated();
                    this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector.push(_local_8);
                    _local_6++;
                };
                _local_7 = (this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector[_local_4].frameList_vector.length - 1);
                while (_local_7 < _local_5)
                {
                    this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector[_local_4].frameList_vector.push(new dFrameCalculated());
                    this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector[_local_4].numFrames = this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector[_local_4].frameList_vector.length;
                    _local_7++;
                };
            }
            else
            {
                if (_local_5 >= this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector[_local_4].frameList_vector.length)
                {
                    _local_9 = (this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector[_local_4].frameList_vector.length - 1);
                    while (_local_9 < _local_5)
                    {
                        this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector[_local_4].frameList_vector.push(new dFrameCalculated());
                        this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector[_local_4].numFrames = this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector[_local_4].frameList_vector.length;
                        _local_9++;
                    };
                };
            };
            this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector[_local_4].frameList_vector[_local_5] = _arg_1.spriteIndices_vector[0].subtypeCalculated_vector[0].frameList_vector[0];
            this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector[_local_4].seqFootX = _arg_1.spriteIndices_vector[0].subtypeCalculated_vector[0].seqFootX;
            this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector[_local_4].seqFootY = _arg_1.spriteIndices_vector[0].subtypeCalculated_vector[0].seqFootY;
            this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector[_local_4].numFrames = this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector[_local_4].frameList_vector.length;
            this.mSubtypeCalculated_vector = this.mLoadedSpriteLib.spriteIndices_vector[0].subtypeCalculated_vector;
            this.mSubtypeCalculatedNof = this.mSubtypeCalculated_vector.length;
        }

        public function PostProcessGfxLoading():void
        {
            this.mSpriteLib = this.mLoadedSpriteLib;
            this.mOriginalGraphicsImage = this.mSpriteContainer.mOriginalGraphicsImage;
            this.mOriginalGraphicsImageBitmapData = this.mSpriteContainer.mOriginalGraphicsImageBitmapData;
            this.PrepareScaling(this.mDeltaCompression);
            this.mOriginalGraphicsImage = null;
            this.mOriginalGraphicsImageBitmapData = null;
            this.mSpriteContainer.mOriginalGraphicsImage = null;
            this.mSpriteContainer.mOriginalGraphicsImageBitmapData = null;
            this.SetDirty();
            this.mStreamingFinished = true;
            notifyPropertyObserver(LOADING_DONE, this);
            this.mSpriteContainer.dispose();
            this.mSpriteContainer = null;
        }


    }
}
