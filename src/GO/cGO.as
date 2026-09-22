package GO
{
    import Model.Notifier;
    import converted.bluebyte.tso.rendering.IRenderListRenderable;
    import nLib.cSpriteLib;
    import Interface.cGeneralInterface;
    import Enums.RENDER_LAYER;
    import Enums.OBJECTTYPE;
    import __AS3__.vec.Vector;
    import nLib.gMisc;
    import ServerState.cPlayerData;
    import Enums.CURSOR_RENDERMODE;
    import flash.display.BlendMode;
    import Enums.CURSOR_PLACABLE;
    import nLib.cPosInt;
    import nLib.cBackbuffer;
    import flash.display.Graphics;
    import __AS3__.vec.*;

    public class cGO extends Notifier implements IRenderListRenderable 
    {

        protected var mYScaled:int = 0;
        public var mSprite:cSpriteLib = null;
        protected var mXNotScaled:Number = 0;
        protected var mRenderOffsetY:int = 0;
        protected var mXScaled:int = 0;
        protected var mRenderOffsetX:int = 0;
        public var mGeneralInterface:cGeneralInterface;
        protected var mYNotScaled:Number = 0;
        protected var mLevelEnumObjectType:int = 9;
        protected var renderLayers:uint = RENDER_LAYER.STATIC;

        public function cGO(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
            this.renderLayers = RENDER_LAYER.STATIC;
        }

        public static function GetHitPoints(_arg_1:int, _arg_2:String):int
        {
            var _local_3:int;
            if (_arg_1 == OBJECTTYPE.BUILDING)
            {
                _local_3 = global.buildingGroup.GetHitPoints(_arg_2);
            };
            return (_local_3);
        }

        public static function GetBlockingList(_arg_1:int, _arg_2:String):Vector.<cBlockingData>
        {
            var _local_3:Vector.<cBlockingData> = new Vector.<cBlockingData>();
            if (_arg_1 == OBJECTTYPE.BUILDING)
            {
                _local_3 = global.buildingGroup.GetBlockingListFromName(_arg_2);
            }
            else
            {
                if (_arg_1 == OBJECTTYPE.LANDSCAPE)
                {
                    _local_3 = global.landscapeGroup.GetBlockingListFromName(_arg_2);
                }
                else
                {
                    if (_arg_1 == OBJECTTYPE.BACKGROUND)
                    {
                        _local_3 = global.backgroundGroup.GetBlockingListFromName(_arg_2);
                    };
                };
            };
            return (_local_3);
        }

        public static function GetWatchAreaId(_arg_1:int, _arg_2:String):int
        {
            var _local_3:int;
            if (_arg_1 == OBJECTTYPE.BUILDING)
            {
                _local_3 = global.buildingGroup.GetWatchAreaId(_arg_2);
            };
            return (_local_3);
        }

        public static function CreateGoFromLevelObject(_arg_1:cPlayerData, _arg_2:int, _arg_3:String, _arg_4:cGeneralInterface):cGO
        {
            var _local_5:cBuilding;
            var _local_6:cLandscape;
            var _local_8:cBackground;
            var _local_9:cStreet;
            var _local_10:cGuiIcon;
            var _local_11:cDeposit;
            var _local_7:cGO;
            if (_arg_2 == OBJECTTYPE.BACKGROUND)
            {
                _local_8 = cBackground.CreateFromString(_arg_3, _arg_4);
                _local_7 = _local_8;
            }
            else
            {
                if (_arg_2 == OBJECTTYPE.STREET)
                {
                    _local_9 = cStreet.CreateFromString(global.streetGroup, _arg_3, _arg_4);
                    _local_7 = _local_9;
                }
                else
                {
                    if (_arg_2 == OBJECTTYPE.LANDSCAPE)
                    {
                        _local_6 = cLandscape.CreateFromString(global.landscapeGroup, _arg_3, _arg_2, _arg_4);
                        _local_7 = _local_6;
                    }
                    else
                    {
                        if (_arg_2 == OBJECTTYPE.BUILDING)
                        {
                            _local_5 = cBuilding.CreateFromString(_arg_1, global.buildingGroup, _arg_3, _arg_4);
                            _local_7 = _local_5;
                        }
                        else
                        {
                            if (_arg_2 == OBJECTTYPE.GUIICON)
                            {
                                _local_10 = cGuiIcon.CreateFromString(_arg_3, _arg_4);
                                _local_7 = _local_10;
                            }
                            else
                            {
                                if (_arg_2 == OBJECTTYPE.DEPOSIT)
                                {
                                    _local_11 = cDeposit.CreateFromString(global.guiIconGroup, _arg_3, _arg_4);
                                    _local_7 = _local_11;
                                }
                                else
                                {
                                    gMisc.Assert(false, ("Error: CreateGoFromLevelObject illegal object type " + _arg_2));
                                };
                            };
                        };
                    };
                };
            };
            return (_local_7);
        }

        public static function GetMaxUnits(_arg_1:int, _arg_2:String):int
        {
            var _local_3:int;
            if (_arg_1 == OBJECTTYPE.BUILDING)
            {
                _local_3 = global.buildingGroup.GetMaxUnits(_arg_2);
            };
            return (_local_3);
        }


        public function GetGOContainer():cGOSpriteLibContainer
        {
            return (this.mSprite.GetContainer() as cGOSpriteLibContainer);
        }

        public function RenderNoAlpha():void
        {
            this.mSprite.RenderPosNoScalingNoAlpha(this.mXScaled, this.mYScaled);
        }

        public function GetLevelEnumObjectType():int
        {
            return (this.mLevelEnumObjectType);
        }

        public function GetResourceCreationBuildingName_string():String
        {
            return (this.GetContainerName_string());
        }

        public function updateRenderPosition():void
        {
            notifyPropertyObserver("renderPosition", null);
        }

        public function SetSubType(_arg_1:int):void
        {
            this.mSprite.SetSubType(_arg_1);
        }

        public function GetYInt():int
        {
            return (int(this.mYNotScaled));
        }

        public function SetLevelEnumObjectType(_arg_1:int):Boolean
        {
            this.mLevelEnumObjectType = _arg_1;
            return (true);
        }

        public function RenderCursorTypeXY(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            if (_arg_3 == CURSOR_RENDERMODE.PLACABLE)
            {
                this.RenderTransform(_arg_1, _arg_2, BlendMode.NORMAL, 1, 1, 0);
                this.RenderTransform(_arg_1, _arg_2, BlendMode.SCREEN, 1, 1, 0);
            }
            else
            {
                this.RenderTransform(_arg_1, _arg_2, BlendMode.MULTIPLY, 1, 1, 0);
            };
        }

        public function Compute():void
        {
        }

        public function InitFromNrNoUniqueID(_arg_1:cGOGroup, _arg_2:int):void
        {
            this.setSpriteLib(_arg_1.GetSpriteLibFromNr(_arg_1.mGOList_vector, _arg_2));
            this.PostInit();
        }

        public function GetSubType():int
        {
            return (this.mSprite.GetSubType());
        }

        public function render(_arg_1:uint):void
        {
            this.Render();
        }

        public function getRenderSortSubGrid():int
        {
            return (this.GetXInt() / global.streetGridX);
        }

        public function SetPosition(_arg_1:Number, _arg_2:Number):void
        {
            this.mXNotScaled = _arg_1;
            this.mYNotScaled = _arg_2;
            this.mXScaled = (_arg_1 * this.mGeneralInterface.mZoom.mFactorDivDefaultZoom);
            this.mYScaled = (_arg_2 * this.mGeneralInterface.mZoom.mFactorDivDefaultZoom);
            this.updateRenderPosition();
        }

        public function GetNofAnimFrames():int
        {
            return (this.mSprite.GetNofFrames(this.mSprite.GetSubType()));
        }

        public function GetXInt():int
        {
            return (int(this.mXNotScaled));
        }

        public function getRenderSortGrid():int
        {
            return ((this.GetYInt() / global.streetGridYHalf) * 1000);
        }

        public function getPlayerID():int
        {
            return ((this.mGeneralInterface != null) ? this.mGeneralInterface.mCurrentViewedZoneID : -1);
        }

        public function Render():void
        {
            this.mSprite.RenderPosNoScaling((this.mXScaled + (this.mRenderOffsetX * this.mGeneralInterface.mZoom.mFactorDivDefaultZoom)), (this.mYScaled + (this.mRenderOffsetY * this.mGeneralInterface.mZoom.mFactorDivDefaultZoom)), false);
        }

        public function SetAnimFrame(_arg_1:Number):void
        {
            this.mSprite.SetAnimFrame(_arg_1);
        }

        public function setSpriteLib(_arg_1:cSpriteLib):void
        {
            this.mSprite = _arg_1;
        }

        public function Animate():void
        {
            this.mSprite.Animate(this.mGeneralInterface.mCalculateTicks.mDeltaTicksOne);
        }

        public function isVisibleForRender():Boolean
        {
            return (true);
        }

        public function SetRandomFrame():void
        {
            var _local_1:Number = gMisc.GetRandomMinMax(0, (this.mSprite.GetNofFrames(-1) - 1));
            var _local_2:int = int(_local_1);
            this.SetAnimFrame(_local_2);
        }

        public function checkRenderLayer(_arg_1:int):Boolean
        {
            return ((this.renderLayers & _arg_1) == _arg_1);
        }

        public function getRenderX():int
        {
            return (int(this.mXNotScaled));
        }

        public function Exit():void
        {
            this.mSprite = null;
        }

        public function RenderWithEnforcedAntialias():void
        {
            this.mSprite.RenderPosNoScaling(this.mXScaled, this.mYScaled, true);
        }

        public function getRenderY():int
        {
            return (int(this.mYNotScaled));
        }

        public function IsCursorPlacable(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            return (CURSOR_PLACABLE.GO_PLACABLE);
        }

        public function GetContainerName_string():String
        {
            var _local_1:cGOSpriteLibContainer = (this.mSprite.GetContainer() as cGOSpriteLibContainer);
            return (_local_1.mGfxResourceListName_string);
        }

        public function RenderTransform(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:Number, _arg_5:Number, _arg_6:Number):void
        {
            this.mSprite.RenderSubTypeAndFrameTransform(_arg_1, _arg_2, this.mSprite.GetSubType(), 0, _arg_3, _arg_4, _arg_5, _arg_6);
        }

        public function InitFromNr(_arg_1:cGOGroup, _arg_2:int):void
        {
            this.setSpriteLib(_arg_1.GetSpriteLibFromNr(_arg_1.mGOList_vector, _arg_2));
            this.PostInit();
        }

        public function RenderPos(_arg_1:int, _arg_2:int):void
        {
            this.mSprite.RenderPos(_arg_1, _arg_2);
        }

        public function RenderTextAboveGo(_arg_1:Graphics, _arg_2:String, _arg_3:int):void
        {
            var _local_4:cPosInt = new cPosInt();
            _local_4.x = int((this.mXNotScaled - 16));
            _local_4.y = int((this.mYNotScaled + _arg_3));
            this.mGeneralInterface.mZoom.CalculateScrollPos(_local_4);
            globalFlash.gui.WriteDebugText(cBackbuffer.mBackBuffer, _arg_2, _local_4.x, _local_4.y);
        }

        public function GetY():Number
        {
            return (this.mYNotScaled);
        }

        public function GetNofSubTypes():int
        {
            return (this.mSprite.GetNofSubTypes());
        }

        public function SetSubTypeAndFrame(_arg_1:int, _arg_2:int):void
        {
            this.mSprite.SetSubTypeAndFrame(_arg_1, _arg_2);
        }

        public function GetX():Number
        {
            return (this.mXNotScaled);
        }

        public function SetAnim(_arg_1:Number, _arg_2:Boolean):void
        {
            this.mSprite.SetAnim(_arg_1, _arg_2);
        }

        public function PostInit():void
        {
        }


    }
}
