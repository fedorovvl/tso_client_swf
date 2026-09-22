package GO
{
    import Interface.IStreet;
    import Interface.cGeneralInterface;
    import Enums.OBJECTTYPE;
    import Enums.DIRTY_INDICATOR;
    import Enums.CURSOR_PLACABLE;
    import Communication.VO.dStreetVO;
    import Enums.RENDER_ORDER;
    import nLib.cPosInt;

    public class cStreet extends cIsoGO implements IStreet 
    {

        public static const TYPE_NORMAL:int = 0;
        public static const TYPE_ARMY:int = 1;
        public static const TYPE_PRODUCTION_WORKYARD:int = 2;
        public static const TYPE_PRODUCTION_DEPOSIT:int = 3;
        public static const TYPE_PRODUCTION_BOTH:int = 4;

        private var mVariationNr:int = 0;
        private var mSkin:int = 0;
        private var mLoadingFinished:Boolean = false;
        private var mStreetType:int = 0;
        public var mDirtyIndicator:int;
        private var mStreetBits:int = 0;

        public function cStreet(_arg_1:cGeneralInterface)
        {
            super(_arg_1);
        }

        public static function CreateStringFromStreetBitField_string(_arg_1:int):String
        {
            var _local_2:* = "";
            if ((_arg_1 & 0x01) == 1)
            {
                _local_2 = (_local_2 + "0");
            };
            if ((_arg_1 & 0x02) == 2)
            {
                _local_2 = (_local_2 + "1");
            };
            if ((_arg_1 & 0x04) == 4)
            {
                _local_2 = (_local_2 + "2");
            };
            if ((_arg_1 & 0x08) == 8)
            {
                _local_2 = (_local_2 + "3");
            };
            return (_local_2);
        }

        public static function ConvertStreetNameToBitField(_arg_1:String):int
        {
            var _local_4:String;
            var _local_2:int;
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_4 = (_arg_1.charAt(_local_3) + "");
                if (_local_4 == "0")
                {
                    _local_2 = (_local_2 | 0x01);
                }
                else
                {
                    if (_local_4 == "1")
                    {
                        _local_2 = (_local_2 | 0x02);
                    }
                    else
                    {
                        if (_local_4 == "2")
                        {
                            _local_2 = (_local_2 | 0x04);
                        }
                        else
                        {
                            if (_local_4 == "3")
                            {
                                _local_2 = (_local_2 | 0x08);
                            };
                        };
                    };
                };
                _local_3++;
            };
            return (_local_2);
        }

        public static function CreateFromString(_arg_1:cGOGroup, _arg_2:String, _arg_3:cGeneralInterface):cStreet
        {
            var _local_4:int = _arg_1.GetNrFromName(_arg_2);
            var _local_5:cStreet = new cStreet(_arg_3);
            _local_5.InitFromNr(_arg_1, _local_4);
            _local_5.mStreetBits = cStreet.ConvertStreetNameToBitField(_local_5.GetContainerName_string());
            _local_5.SetLevelEnumObjectType(OBJECTTYPE.STREET);
            return (_local_5);
        }


        public function GetStreetBits():int
        {
            return (this.mStreetBits);
        }

        public function SetStreetType(_arg_1:int):void
        {
            this.mStreetType = _arg_1;
        }

        public function SetStreetBits(_arg_1:int):void
        {
            this.mStreetBits = _arg_1;
            this.mLoadingFinished = false;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function SetVariationNr(_arg_1:int):void
        {
            this.mVariationNr = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            if (this.mLoadingFinished)
            {
                this.RefreshAnimFrame();
            };
        }

        override public function IsCursorPlacable(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            return (CURSOR_PLACABLE.STREET_PLACE);
        }

        public function getGrid():int
        {
            return (mGridPosition);
        }

        public function RefreshSubType():void
        {
            var _local_1:int = this.mSkin;
            var _local_2:int = GetNofSubTypes();
            if (_local_1 >= _local_2)
            {
                _local_1 = (_local_2 - 1);
            };
            SetSubType(_local_1);
        }

        public function GetStreetType():int
        {
            return (this.mStreetType);
        }

        public function getVariation():int
        {
            return (this.mVariationNr);
        }

        public function CreateStreetVOFromStreet():dStreetVO
        {
            var _local_1:dStreetVO = new dStreetVO();
            _local_1.grid = GetGrid();
            _local_1.bits = this.GetStreetBits();
            _local_1.skin = this.getSkin();
            _local_1.variation = this.GetVariationNr();
            return (_local_1);
        }

        public function GetVariationNr():int
        {
            return (this.mVariationNr);
        }

        public function getBits():int
        {
            return (this.mStreetBits);
        }

        public function Init(_arg_1:int, _arg_2:int, _arg_3:int):cStreet
        {
            this.mSkin = _arg_1;
            this.mVariationNr = _arg_2;
            SetGrid(_arg_3);
            return (this);
        }

        public function getSkin():int
        {
            return (this.mSkin);
        }

        override public function getRenderSortSubGrid():int
        {
            return (RENDER_ORDER.ORDER_3);
        }

        override public function getRenderSortGrid():int
        {
            return (((GetYInt() + global.streetGridYHalf) / global.streetGridYHalf) * 1000);
        }

        public function RefreshAnimFrame():void
        {
            var _local_1:int = GetNofAnimFrames();
            var _local_2:int = (this.mVariationNr % _local_1);
            SetAnimFrame(_local_2);
        }

        override public function Render():void
        {
            var _local_1:cPosInt;
            if (this.mStreetType == TYPE_NORMAL)
            {
                if (!GetGOContainer().mStream)
                {
                    if (!this.mLoadingFinished)
                    {
                        this.mLoadingFinished = true;
                        this.RefreshSubType();
                        this.RefreshAnimFrame();
                    };
                };
                super.RenderWithEnforcedAntialias();
            }
            else
            {
                _local_1 = new cPosInt();
                gCalculations.ConvertStreetGridToPixelPos(mGeneralInterface.mCurrentPlayerZone, GetGrid(), _local_1);
                SetPosition(_local_1.x, _local_1.y);
                switch (this.mStreetType)
                {
                    case TYPE_ARMY:
                        mGeneralInterface.mMilitaryPath.mSprite.RenderPosNoScaling(mXScaled, mYScaled);
                        return;
                    case TYPE_PRODUCTION_WORKYARD:
                        mGeneralInterface.mProductionPathWorkyard.mSprite.RenderPosNoScaling(mXScaled, mYScaled);
                        return;
                    case TYPE_PRODUCTION_DEPOSIT:
                        mGeneralInterface.mProductionPathDeposit.mSprite.RenderPosNoScaling(mXScaled, mYScaled);
                        return;
                    case TYPE_PRODUCTION_BOTH:
                        mGeneralInterface.mProductionPathBoth.mSprite.RenderPosNoScaling(mXScaled, mYScaled);
                        return;
                };
            };
        }

        public function setSkin(_arg_1:int):void
        {
            this.mSkin = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            if (this.mLoadingFinished)
            {
                this.RefreshSubType();
                this.RefreshAnimFrame();
            };
        }


    }
}
