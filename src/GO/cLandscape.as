package GO
{
    import nLib.cSpriteLib;
    import Interface.cGeneralInterface;
    import Enums.OBJECTTYPE;
    import nLib.cSpriteLibContainer;
    import Communication.VO.dLandscapeVO;
    import Enums.RENDER_ORDER;

    public class cLandscape extends cIsoGO 
    {

        public var mDirtyIndicator:int;
        private var mLandscapeName_string:String = null;
        private var mSpriteWorkAnim:cSpriteLib = null;

        public function cLandscape(_arg_1:cGeneralInterface)
        {
            super(_arg_1);
        }

        public static function CreateFromString(_arg_1:cGOGroup, _arg_2:String, _arg_3:int, _arg_4:cGeneralInterface):cLandscape
        {
            var _local_5:int = _arg_1.GetNrFromName(_arg_2);
            var _local_6:cLandscape = new cLandscape(_arg_4);
            _local_6.InitFromNr(_arg_1, _local_5);
            _local_6.mSpriteWorkAnim = _arg_1.GetSpriteLibFromNr(_arg_1.mGOWorkAnimList_vector, _local_5);
            if (_local_6.mSpriteWorkAnim != null)
            {
                _local_6.SetWorkAnimation();
            };
            _local_6.SetLevelEnumObjectType(OBJECTTYPE.LANDSCAPE);
            return (_local_6);
        }


        public function GetLandscapeName_string():String
        {
            return (this.mLandscapeName_string);
        }

        public function SetName_string(_arg_1:String):void
        {
            this.mLandscapeName_string = _arg_1;
        }

        override public function toString():String
        {
            return (((("<Landscape name='" + this.mLandscapeName_string) + "' grid='") + GetGrid()) + "' />");
        }

        public function SetWorkAnimation():void
        {
            var _local_1:cSpriteLibContainer;
            if (this.mSpriteWorkAnim != null)
            {
                _local_1 = (this.mSpriteWorkAnim.GetContainer() as cSpriteLibContainer);
                this.mSpriteWorkAnim.SetAnim(_local_1.mAnimationSpeed, true);
            };
        }

        public function CreateLandscapeVOFromLandscape():dLandscapeVO
        {
            var _local_1:dLandscapeVO = new dLandscapeVO();
            _local_1.name_string = this.GetLandscapeName_string();
            _local_1.grid = GetGrid();
            return (_local_1);
        }

        override public function getRenderSortSubGrid():int
        {
            return (RENDER_ORDER.ORDER_0);
        }


    }
}
