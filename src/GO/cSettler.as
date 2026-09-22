package GO
{
    import SettlerKI.cSettlerKI;
    import Enums.RENDER_LAYER;
    import Interface.cGeneralInterface;
    import nLib.gMisc;
    import SettlerKI.cSettlerKIWalkRandom;
    import Enums.SETTLER_KI_TYP;
    import SettlerKI.cSettlerKIWalkFromFieldtoField;
    import SettlerKI.cSettlerKIWalkOnStreets;
    import SettlerKI.cSettlerKIWalkToDestination;
    import SettlerKI.cSettlerAI_WalkToTarget;
    import SettlerKI.cSettlerKIDoNothing;
    import Enums.OBJECTTYPE;
    import nLib.cSpriteLib;
    import nLib.cBackbuffer;
    import Enums.SPECIALIST_TYPE;

    public class cSettler extends cGO 
    {

        public var currentGeneralSpeed:Number;
        public var name:String = null;
        public var mEnumSettlerKIType:int = 0;
        public var mSettlerKi:cSettlerKI = null;

        public function cSettler(_arg_1:cGeneralInterface)
        {
            super(_arg_1);
            renderLayers = RENDER_LAYER.MOVING;
        }

        public static function CreateFromNr(_arg_1:cGOGroup, _arg_2:int, _arg_3:cGeneralInterface):cSettler
        {
            var _local_4:cSettler = new cSettler(_arg_3);
            _local_4.InitFromNrNoUniqueID(_arg_1, _arg_2);
            return (_local_4);
        }

        public static function CreateFromString(_arg_1:cGOGroup, _arg_2:String, _arg_3:int, _arg_4:cGeneralInterface):cSettler
        {
            var _local_5:int = _arg_1.GetNrFromName(_arg_2);
            var _local_6:cSettler = CreateFromNr(_arg_1, _local_5, _arg_4);
            _local_6.SetPosition(0, 0);
            var _local_7:int = _local_6.GetNofAnimFrames();
            var _local_8:int = int(gMisc.GetRandomMinMax(0, (_local_7 - 1)));
            _local_6.SetAnimFrame(_local_8);
            _local_6.SetLevelEnumObjectType(_arg_3);
            return (_local_6);
        }


        public function SetKI(_arg_1:int):void
        {
            this.mEnumSettlerKIType = _arg_1;
            switch (_arg_1)
            {
                case SETTLER_KI_TYP.WALK_RANDOM:
                    this.mSettlerKi = new cSettlerKIWalkRandom(this);
                    return;
                case SETTLER_KI_TYP.WALK_FROM_FIELD_TO_FIELD:
                    this.mSettlerKi = new cSettlerKIWalkFromFieldtoField(this);
                    return;
                case SETTLER_KI_TYP.WALK_ON_STREETS:
                    this.mSettlerKi = new cSettlerKIWalkOnStreets(this);
                    return;
                case SETTLER_KI_TYP.WALK_TO_DESTINATION:
                    this.mSettlerKi = new cSettlerKIWalkToDestination(this);
                    return;
                case SETTLER_KI_TYP.PERFORM_GENERAL_TASK:
                    this.mSettlerKi = new cSettlerAI_WalkToTarget(this);
                    return;
                default:
                    this.mSettlerKi = new cSettlerKIDoNothing(this);
            };
        }

        override public function Compute():void
        {
            this.mSettlerKi.Compute();
        }

        override public function getRenderSortGrid():int
        {
            return (((GetYInt() + global.streetGridYHalf) / global.streetGridYHalf) * 1000);
        }

        override public function isVisibleForRender():Boolean
        {
            return ((this.mSettlerKi.mVisible) && (((cSettingsManager.getInstance().showSettlers) || (!(GetLevelEnumObjectType() == OBJECTTYPE.SETTLER))) || (this.IsGeneral())));
        }

        public function SetSpriteImage(_arg_1:String):void
        {
            var _local_2:int = global.settlerGroup.GetNrFromName(_arg_1);
            var _local_3:cSpriteLib = global.settlerGroup.GetSpriteLibFromNr(global.settlerGroup.mGOList_vector, _local_2);
            setSpriteLib(_local_3);
            var _local_4:cGOSpriteLibContainer = (_local_3.GetContainer() as cGOSpriteLibContainer);
            SetAnim(_local_4.mEffectDefaultAnimSpeed, true);
            SetRandomFrame();
        }

        override public function Render():void
        {
            var _local_1:String;
            var _local_2:int;
            if (this.mSettlerKi.mVisible)
            {
                super.Render();
                if (((((!(this.name == null)) && (GetGOContainer().mGfxResourceListName_string == "RAVING_RABBID")) && ((Math.abs((mGeneralInterface.mCurrentCursor.mLastConvertedMousePosition.x - mXNotScaled)) <= (mSprite.GetWidth() / 2)) && (Math.abs((mGeneralInterface.mCurrentCursor.mLastConvertedMousePosition.y - mYNotScaled)) <= (mSprite.GetHeight() / 2)))) || (global.showAllSettlerNames)))
                {
                    _local_1 = this.name;
                    mGeneralInterface.mCurrentCursor.mCurrentSettler = this;
                    if (((global.showAllSettlerNames) && (!(isNaN(this.currentGeneralSpeed)))))
                    {
                        _local_1 = (_local_1 + (" speed: " + this.currentGeneralSpeed));
                    };
                    mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, _local_1, mXNotScaled, (mYNotScaled + (mSprite.GetHeight() / 2)));
                };
                if (((cSettingsManager.getInstance().showGeneralMarkers) && (this.IsGeneral())))
                {
                    _local_2 = mGeneralInterface.mCurrentPlayerZone.GetPlayerColorIdx(getPlayerID());
                    gGfxResource.mUpgradeLevelIcons.SetSubType(_local_2);
                    gGfxResource.mUpgradeLevelIcons.RenderPos(mXNotScaled, (mYNotScaled - (global.streetGridY * 1.1)));
                };
            };
        }

        public function IsGeneral():Boolean
        {
            if (((this.mSettlerKi is cSettlerAI_WalkToTarget) && (SPECIALIST_TYPE.IsGeneralOrAdmiral((this.mSettlerKi as cSettlerAI_WalkToTarget).getTask().GetOwner().GetType()))))
            {
                return (true);
            };
            return (false);
        }

        override public function PostInit():void
        {
            var _local_1:cGOSpriteLibContainer = (mSprite.GetContainer() as cGOSpriteLibContainer);
            SetAnim(_local_1.mEffectDefaultAnimSpeed, true);
            this.SetKI(_local_1.mEnumSettlerKiTyp);
        }


    }
}
