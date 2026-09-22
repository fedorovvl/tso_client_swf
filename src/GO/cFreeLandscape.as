package GO
{
    import Interface.cGeneralInterface;
    import Enums.OBJECTTYPE;
    import nLib.cSpriteLibContainer;
    import Communication.VO.dFreeLandscapeVO;

    public class cFreeLandscape extends cGO 
    {

        private var mGoGroup:cGOGroup;
        private var mLandscapeName_string:String = null;
        public var mIsAnimated:Boolean = false;
        public var mAnimationInitialized:Boolean = false;

        public function cFreeLandscape(_arg_1:cGeneralInterface)
        {
            super(_arg_1);
        }

        public static function CreateFromString(_arg_1:cGOGroup, _arg_2:String, _arg_3:cGeneralInterface):cFreeLandscape
        {
            var _local_4:int = _arg_1.GetNrFromName(_arg_2);
            var _local_5:cFreeLandscape = new cFreeLandscape(_arg_3);
            _local_5.InitFromNr(_arg_1, _local_4);
            _local_5.SetGoGroup(_arg_1);
            _local_5.SetLevelEnumObjectType(OBJECTTYPE.LANDSCAPE);
            return (_local_5);
        }


        public function GetLandscapeName_string():String
        {
            return (this.mLandscapeName_string);
        }

        public function SetAnimation():void
        {
            var _local_2:cSpriteLibContainer;
            var _local_1:int = GetNofAnimFrames();
            if (_local_1 > 1)
            {
                this.mIsAnimated = true;
                _local_2 = (mSprite.GetContainer() as cSpriteLibContainer);
                mSprite.SetAnim(_local_2.mAnimationSpeed, true);
                mSprite.SetRandomAnimFrame();
            }
            else
            {
                this.mIsAnimated = false;
            };
            this.mAnimationInitialized = true;
        }

        public function SetName_string(_arg_1:String):void
        {
            this.mLandscapeName_string = _arg_1;
        }

        public function SetGoGroup(_arg_1:cGOGroup):Boolean
        {
            this.mGoGroup = _arg_1;
            return (true);
        }

        public function CreateVO():dFreeLandscapeVO
        {
            var _local_1:dFreeLandscapeVO = new dFreeLandscapeVO();
            _local_1.name_string = this.GetLandscapeName_string();
            _local_1.x = GetXInt();
            _local_1.y = GetYInt();
            return (_local_1);
        }


    }
}
