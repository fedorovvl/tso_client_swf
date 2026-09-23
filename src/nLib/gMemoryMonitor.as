// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//nLib.gMemoryMonitor

package nLib
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import Interface.cGeneralInterface;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import flash.display.BitmapData;
    import mx.events.PropertyChangeEvent;
    import GO.cGOSpriteLibContainer;
    import nLib.SpriteLibDataClass.dSubtypeCalculated;
    import nLib.SpriteLibDataClass.dFrameCalculated;
    import GO.cIsoElement;
    import flash.events.Event;
    import mx.formatters.DateFormatter;
    import flash.system.System;
    import com.bluebyte.tso.util.ClientLogger;
    import GUI.Assets.gAssetManager;
    import Interface.*;
    import GO.*;
    import __AS3__.vec.*;

    public class gMemoryMonitor implements IEventDispatcher 
    {

        public static const DETAIL_LEVEL_SHORT:int = 0;
        public static const DETAIL_LEVEL_NORMAL:int = 1;
        public static const DETAIL_LEVEL_COMPLETE:int = 2;

        private const LF_string:String = "\n";

        public var mLoadedGFXCount:uint = 0;
        public var mLoadedBinData:uint = 0;
        public var mLoadedXMLCount:uint = 0;
        public var mLoadedXMLData:uint = 0;
        private var _93406797mUsedBytesSprites:uint = 0;
        private var _969911684mOtherMemory:uint = 0;
        private var _bindingEventDispatcher:EventDispatcher;
        private var _1659820945mLoadedGFXData:uint = 0;
        private var mGeneralInterface:cGeneralInterface;
        public var mLoadedBinCount:uint = 0;
        private var mContainerList_vector:Vector.<cSpriteLibContainer> = new Vector.<cSpriteLibContainer>();
        private var _333785108mUsedBytesUnscaled:uint = 0;
        private var mObjects:Dictionary = new Dictionary();
        private var _840780677mUsedBytesScaled:uint = 0;
        private var _1931678392mTotalMemory:uint = 0;
        public var mAssetBitmapMemory:Number = 0;
        public var mFreeMemory:Number = 0;
        public var mPrivateMemory:Number = 0;
        public var mNativeMemory:Number = 0;
        public var mBitmapAccountingOverlap:Number = 0;

        public function gMemoryMonitor()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function RegisterSpriteLibContainer(_arg_1:cSpriteLibContainer):void
        {
            if (_arg_1)
            {
                this.mContainerList_vector.push(_arg_1);
            };
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get mOtherMemory():uint
        {
            return (this._969911684mOtherMemory);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        private function CalculateMemorySize(_arg_1:BitmapData):Number
        {
            if (_arg_1 == null)
            {
                return (0);
            };
            return ((_arg_1.width * _arg_1.height) * 4);
        }

        [Bindable(event="propertyChange")]
        public function get mLoadedGFXData():uint
        {
            return (this._1659820945mLoadedGFXData);
        }

        [Bindable(event="propertyChange")]
        public function get mUsedBytesUnscaled():uint
        {
            return (this._333785108mUsedBytesUnscaled);
        }

        public function set mOtherMemory(_arg_1:uint):void
        {
            var _local_2:Object = this._969911684mOtherMemory;
            if (_local_2 !== _arg_1)
            {
                this._969911684mOtherMemory = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mOtherMemory", _local_2, _arg_1));
            };
        }

        private function AlignRight_string(_arg_1:String):String
        {
            var _local_2:int = (10 - _arg_1.length);
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _arg_1 = (" " + _arg_1);
                _local_3++;
            };
            return (_arg_1);
        }

        public function set mUsedBytesSprites(_arg_1:uint):void
        {
            var _local_2:Object = this._93406797mUsedBytesSprites;
            if (_local_2 !== _arg_1)
            {
                this._93406797mUsedBytesSprites = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mUsedBytesSprites", _local_2, _arg_1));
            };
        }

        public function set mLoadedGFXData(_arg_1:uint):void
        {
            var _local_2:Object = this._1659820945mLoadedGFXData;
            if (_local_2 !== _arg_1)
            {
                this._1659820945mLoadedGFXData = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mLoadedGFXData", _local_2, _arg_1));
            };
        }

        private function AlignLeft_string(_arg_1:String):String
        {
            var _local_2:int = (24 - _arg_1.length);
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _arg_1 = (_arg_1 + " ");
                _local_3++;
            };
            return (_arg_1);
        }

        private function GenerateReportForGOs_string(_arg_1:int):String
        {
            var _local_4:Object;
            var _local_5:Object;
            var _local_6:int;
            var _local_7:cGOSpriteLibContainer;
            var _local_8:int;
            var _local_9:dSubtypeCalculated;
            var _local_10:int;
            var _local_11:int;
            var _local_12:dFrameCalculated;
            var _local_13:int;
            var _local_14:int;
            var _local_15:uint;
            var _local_16:uint;
            var _local_17:int;
            var _local_2:Array = [];
            var _local_3:* = "";
            _local_3 = (_local_3 + (this.LF_string + ""));
            _local_3 = (_local_3 + (this.LF_string + "MEMORY USAGE BY GAME OBJECT:"));
            if (_arg_1 != -1)
            {
                _local_3 = (_local_3 + (((this.LF_string + "and all Alpha Areas below Alphavalue ") + _arg_1) + " in %"));
            };
            _local_3 = (_local_3 + (this.LF_string + "=================================="));
            for (_local_4 in this.mObjects)
            {
                _local_6 = 0;
                for each (_local_7 in this.mObjects[_local_4])
                {
                    if (((!(_local_7.mStreamingInProgress)) && (!(_local_7.mStream))))
                    {
                        _local_8 = this.CalculateMemorySize(_local_7.mOriginalGraphicsImageBitmapData);
                        for each (_local_9 in _local_7.mSubtypeCalculated_vector)
                        {
                            _local_10 = 0;
                            _local_11 = 0;
                            for each (_local_12 in _local_9.frameList_vector)
                            {
                                _local_8 = (_local_8 + this.CalculateMemorySize(_local_12.orginalBitmap));
                                _local_8 = (_local_8 + this.CalculateMemorySize(_local_12.filteredBitmap));
                                _local_8 = (_local_8 + this.CalculateMemorySize(_local_12.scaledBitmap));
                                if (_arg_1 != -1)
                                {
                                    _local_13 = 0;
                                    while (((_local_12.orginalBitmap != null) && (_local_13 < _local_12.orginalBitmap.height)))
                                    {
                                        _local_14 = 0;
                                        while (_local_14 < _local_12.orginalBitmap.width)
                                        {
                                            _local_15 = _local_12.orginalBitmap.getPixel32(_local_14, _local_13);
                                            _local_16 = (_local_15 >> 24);
                                            if (_local_16 < _arg_1)
                                            {
                                                _local_10++;
                                            }
                                            else
                                            {
                                                _local_11++;
                                            };
                                            _local_14++;
                                        };
                                        _local_13++;
                                    };
                                };
                            };
                            if (_arg_1 != -1)
                            {
                                if ((_local_11 + _local_10) > 0)
                                {
                                    _local_17 = int(((_local_10 * 100) / (_local_11 + _local_10)));
                                    if (_local_17 > _local_6)
                                    {
                                        _local_6 = _local_17;
                                    };
                                };
                            };
                        };
                    };
                };
                if (_arg_1 != -1)
                {
                    _local_2.push({
                        "name":(_local_4 as String),
                        "size":_local_8,
                        "alphaPercentage":_local_6
                    });
                }
                else
                {
                    _local_2.push({
                        "name":(_local_4 as String),
                        "size":_local_8
                    });
                };
            };
            if (_arg_1 != -1)
            {
                _local_2 = _local_2.sortOn("alphaPercentage", (Array.NUMERIC | Array.DESCENDING));
            }
            else
            {
                _local_2 = _local_2.sortOn("size", (Array.NUMERIC | Array.DESCENDING));
            };
            for each (_local_5 in _local_2)
            {
                if (_arg_1 != -1)
                {
                    _local_3 = (_local_3 + ((this.LF_string + this.AlignLeft_string(_local_5.name)) + this.AlignRight_string((((this.FormatAsMB_string(_local_5.size) + "   Alpha ") + _local_5.alphaPercentage) + "%"))));
                }
                else
                {
                    _local_3 = (_local_3 + ((this.LF_string + this.AlignLeft_string(_local_5.name)) + this.AlignRight_string(this.FormatAsMB_string(_local_5.size))));
                };
            };
            return (_local_3);
        }

        public function RegisterLoadedGraphic(_arg_1:int):void
        {
            this.mLoadedGFXData = (this.mLoadedGFXData + _arg_1);
            this.mLoadedGFXCount++;
        }

        public function set mUsedBytesUnscaled(_arg_1:uint):void
        {
            var _local_2:Object = this._333785108mUsedBytesUnscaled;
            if (_local_2 !== _arg_1)
            {
                this._333785108mUsedBytesUnscaled = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mUsedBytesUnscaled", _local_2, _arg_1));
            };
        }

        private function GetBuildingCount():int
        {
            if (((this.mGeneralInterface == null) || (this.mGeneralInterface.mCurrentPlayerZone == null))
                || (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap == null))
            {
                return (0);
            };
            return (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector().length);
        }

        public function Init(_arg_1:cGeneralInterface):void
        {
            this.mGeneralInterface = _arg_1;
        }

        public function RegisterGOSpriteLibContainer(_arg_1:cGOSpriteLibContainer):void
        {
            var _local_2:Vector.<cGOSpriteLibContainer>;
            if (_arg_1 == null)
            {
                return;
            };
            if (this.mObjects[_arg_1.mGfxResourceListName_string])
            {
                _local_2 = this.mObjects[_arg_1.mGfxResourceListName_string];
            }
            else
            {
                _local_2 = new Vector.<cGOSpriteLibContainer>();
            };
            _local_2.push(_arg_1);
            this.mObjects[_arg_1.mGfxResourceListName_string] = _local_2;
        }

        private function GetStreetCount():int
        {
            if (((this.mGeneralInterface == null) || (this.mGeneralInterface.mCurrentPlayerZone == null))
                || (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap == null))
            {
                return (0);
            };
            return (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetStreets_vector().length);
        }

        [Bindable(event="propertyChange")]
        public function get mTotalMemory():uint
        {
            return (this._1931678392mTotalMemory);
        }

        public function RegisterLoadedBin(_arg_1:int):void
        {
            this.mLoadedBinData = (this.mLoadedBinData + _arg_1);
            this.mLoadedBinCount++;
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        [Bindable(event="propertyChange")]
        public function get mUsedBytesSprites():uint
        {
            return (this._93406797mUsedBytesSprites);
        }

        public function RegisterLoadedXML(_arg_1:int):void
        {
            this.mLoadedXMLData = (this.mLoadedXMLData + _arg_1);
            this.mLoadedXMLCount++;
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function GenerateReport_string(_arg_1:int, _arg_2:int):String
        {
            var _local_3:* = "";
            var _local_4:Date = new Date();
            var _local_5:DateFormatter = new DateFormatter();
            _local_5.formatString = "DD.MM.YYYY J:NN";
            _local_3 = (_local_3 + "SWMMO MEMORY MONITOR");
            _local_3 = (_local_3 + ((this.LF_string + "Report created: ") + _local_5.format(_local_4)));
            _local_3 = (_local_3 + (this.LF_string + ""));
            _local_3 = (_local_3 + (this.LF_string + ""));
            _local_3 = (_local_3 + (this.LF_string + "TRAFFIC:"));
            _local_3 = (_local_3 + (this.LF_string + "=================================="));
            _local_3 = (_local_3 + ((this.LF_string + "Client size:            ") + this.AlignRight_string(this.FormatAsMB_string(global.getApplication().loaderInfo.bytesTotal))));
            _local_3 = (_local_3 + ((this.LF_string + "Loaded xml files:       ") + this.AlignRight_string(this.mLoadedXMLCount.toString())));
            _local_3 = (_local_3 + ((this.LF_string + "Loaded xml data:        ") + this.AlignRight_string(this.FormatAsMB_string(this.mLoadedXMLData))));
            _local_3 = (_local_3 + ((this.LF_string + "Loaded gfx files:       ") + this.AlignRight_string(this.mLoadedGFXCount.toString())));
            _local_3 = (_local_3 + ((this.LF_string + "Loaded gfx data:        ") + this.AlignRight_string(this.FormatAsMB_string(this.mLoadedGFXData))));
            _local_3 = (_local_3 + ((this.LF_string + "Loaded bin files:       ") + this.AlignRight_string(this.mLoadedBinCount.toString())));
            _local_3 = (_local_3 + ((this.LF_string + "Loaded bin data:        ") + this.AlignRight_string(this.FormatAsMB_string(this.mLoadedBinData))));
            _local_3 = (_local_3 + ((this.LF_string + "Loaded game data:       ") + this.AlignRight_string("---")));
            _local_3 = (_local_3 + (this.LF_string + "----------------------------------"));
            _local_3 = (_local_3 + ((this.LF_string + "Total traffic:          ") + this.AlignRight_string(this.FormatAsMB_string((((global.getApplication().loaderInfo.bytesTotal + this.mLoadedXMLData) + this.mLoadedGFXData) + this.mLoadedBinData)))));
            _local_3 = (_local_3 + (this.LF_string + ""));
            _local_3 = (_local_3 + (this.LF_string + ""));
            _local_3 = (_local_3 + (this.LF_string + "GAME DETAILS:"));
            _local_3 = (_local_3 + (this.LF_string + "=================================="));
            _local_3 = (_local_3 + ((this.LF_string + "Stage size:             ") + this.AlignRight_string(((global.getApplication().stage.stageWidth + " x ") + global.getApplication().stage.stageHeight))));
            _local_3 = (_local_3 + ((this.LF_string + "Buildings on map:       ") + this.AlignRight_string(this.GetBuildingCount().toString())));
            _local_3 = (_local_3 + ((this.LF_string + "Street segments on map: ") + this.AlignRight_string(this.GetStreetCount().toString())));
            _local_3 = (_local_3 + (this.LF_string + ""));
            _local_3 = (_local_3 + (this.LF_string + ""));
            _local_3 = (_local_3 + (this.LF_string + "MEMORY USAGE:"));
            _local_3 = (_local_3 + (this.LF_string + "=================================="));
            _local_3 = (_local_3 + ((this.LF_string + "Original Sprites:       ") + this.AlignRight_string(this.FormatAsMB_string(this.mUsedBytesSprites))));
            _local_3 = (_local_3 + ((this.LF_string + "Unscaled Bitmaps:       ") + this.AlignRight_string(this.FormatAsMB_string(this.mUsedBytesUnscaled))));
            _local_3 = (_local_3 + ((this.LF_string + "Scaled Bitmaps:         ") + this.AlignRight_string(this.FormatAsMB_string(this.mUsedBytesScaled))));
            _local_3 = (_local_3 + ((this.LF_string + "Asset manager bitmaps:  ") + this.AlignRight_string(this.FormatAsMB_string(this.mAssetBitmapMemory))));
            _local_3 = (_local_3 + ((this.LF_string + "AVM2 unclassified:      ") + this.AlignRight_string(this.FormatAsMB_string(this.mOtherMemory))));
            _local_3 = (_local_3 + ((this.LF_string + "Bitmap estimate overlap:") + this.AlignRight_string(this.FormatAsMB_string(this.mBitmapAccountingOverlap))));
            _local_3 = (_local_3 + (this.LF_string + "----------------------------------"));
            _local_3 = (_local_3 + ((this.LF_string + "AVM2 managed memory:    ") + this.AlignRight_string(this.FormatAsMB_string(this.mTotalMemory))));
            _local_3 = (_local_3 + ((this.LF_string + "AVM2 free reserve:      ") + this.AlignRight_string(this.FormatAsMB_string(this.mFreeMemory))));
            _local_3 = (_local_3 + ((this.LF_string + "AIR native / overhead: ") + this.AlignRight_string(this.FormatAsMB_string(this.mNativeMemory))));
            _local_3 = (_local_3 + ((this.LF_string + "AIR private memory:     ") + this.AlignRight_string(this.FormatAsMB_string(this.mPrivateMemory))));
            return (_local_3 + (this.LF_string + this.GenerateReportForGOs_string(_arg_2)));
        }

        public function set mTotalMemory(_arg_1:uint):void
        {
            var _local_2:Object = this._1931678392mTotalMemory;
            if (_local_2 !== _arg_1)
            {
                this._1931678392mTotalMemory = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mTotalMemory", _local_2, _arg_1));
            };
        }

        public function FormatAsMB_string(_arg_1:Number):String
        {
            var _local_2:Number = (_arg_1 / 0x0400);
            if (_local_2 > 0x0400)
            {
                return ((_local_2 / 0x0400).toFixed(2) + " MB");
            };
            return (_local_2.toFixed(2) + " KB");
        }

        public function set mUsedBytesScaled(_arg_1:uint):void
        {
            var _local_2:Object = this._840780677mUsedBytesScaled;
            if (_local_2 !== _arg_1)
            {
                this._840780677mUsedBytesScaled = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mUsedBytesScaled", _local_2, _arg_1));
            };
        }

        public function CalculateMemoryUsage():void
        {
            var _debugStage:String = "initialization";
            var _containerIndex:int = -1;
            var _subtypeIndex:int = -1;
            var _frameIndex:int = -1;
            try
            {
                var _local_4:cSpriteLibContainer;
                var _local_5:dSubtypeCalculated;
                var _local_6:dFrameCalculated;
                var _local_1:uint;
                var _local_2:uint;
                var _local_3:uint;
                for each (_local_4 in this.mContainerList_vector)
                {
                    _containerIndex++;
                    _subtypeIndex = -1;
                    _debugStage = "container.mOriginalGraphicsImageBitmapData";
                    _local_1 = (_local_1 + this.CalculateMemorySize(_local_4.mOriginalGraphicsImageBitmapData));
                    _debugStage = "container.mSubtypeCalculated_vector";
                    for each (_local_5 in _local_4.mSubtypeCalculated_vector)
                    {
                        _subtypeIndex++;
                        _frameIndex = -1;
                        _debugStage = "subtype.frameList_vector";
                        for each (_local_6 in _local_5.frameList_vector)
                        {
                            _frameIndex++;
                            _debugStage = "frame.orginalBitmap";
                            _local_2 = (_local_2 + this.CalculateMemorySize(_local_6.orginalBitmap));
                            _debugStage = "frame.filteredBitmap";
                            _local_2 = (_local_2 + this.CalculateMemorySize(_local_6.filteredBitmap));
                            _debugStage = "frame.scaledBitmap";
                            _local_3 = (_local_3 + this.CalculateMemorySize(_local_6.scaledBitmap));
                        };
                    };
                };
                _debugStage = "set mUsedBytesSprites";
                this.mUsedBytesSprites = _local_1;
                _debugStage = "set mUsedBytesUnscaled";
                this.mUsedBytesUnscaled = _local_2;
                _debugStage = "set mUsedBytesScaled";
                this.mUsedBytesScaled = _local_3;
                _debugStage = "System.totalMemory";
                this.mTotalMemory = uint(System.totalMemoryNumber);
                _debugStage = "System.freeMemory";
                this.mFreeMemory = System.freeMemory;
                _debugStage = "System.privateMemory";
                this.mPrivateMemory = System.privateMemory;
                _debugStage = "gAssetManager.CalculateLoadedBitmapMemory";
                this.mAssetBitmapMemory = gAssetManager.CalculateLoadedBitmapMemory();
                _debugStage = "set mOtherMemory";
                var _tracked:Number = (((this.mUsedBytesSprites + this.mUsedBytesUnscaled)
                    + this.mUsedBytesScaled) + this.mAssetBitmapMemory);
                var _managedDifference:Number = (Number(this.mTotalMemory) - _tracked);
                this.mOtherMemory = uint(Math.max(0, _managedDifference));
                this.mBitmapAccountingOverlap = Math.max(0, -(_managedDifference));
                this.mNativeMemory = Math.max(0, (this.mPrivateMemory - Number(this.mTotalMemory)));
            }
            catch (_error:Error)
            {
                ClientLogger.log("gMemoryMonitor.CalculateMemoryUsage failed at " + _debugStage
                    + "; container=" + _containerIndex
                    + ", subtype=" + _subtypeIndex
                    + ", frame=" + _frameIndex);
                ClientLogger.error(_error);
                throw (_error);
            };
        }

        [Bindable(event="propertyChange")]
        public function get mUsedBytesScaled():uint
        {
            return (this._840780677mUsedBytesScaled);
        }


    }
}//package nLib

