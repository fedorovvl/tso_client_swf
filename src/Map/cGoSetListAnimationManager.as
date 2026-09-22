package Map
{
    import flash.utils.Dictionary;
    import Interface.cGeneralInterface;
    import GOSets.cGOSetManager;
    import GOSets.cGOSetList;
    import Interface.cGameInterface;
    import Enums.RENDER_LAYER;
    import GO.cGOGroup;

    public class cGoSetListAnimationManager 
    {

        private var mAnimations:Dictionary = null;
        private var mIconAnimations:Dictionary = null;
        private var mGeneralInterface:cGeneralInterface;

        public function cGoSetListAnimationManager(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
            this.Reset();
        }

        public function IsAnimationAtGridPos(_arg_1:int):Boolean
        {
            return (!(this.mAnimations[_arg_1] == null));
        }

        public function Remove(_arg_1:int):void
        {
            this.mGeneralInterface.channels.RENDER.renderObjectRemoved(this.mAnimations[_arg_1]);
            this.mAnimations[_arg_1] = null;
        }

        public function AddAnimation(_arg_1:int, _arg_2:String, _arg_3:Number, _arg_4:int, _arg_5:Object):void
        {
            var _local_6:cGOSetList = cGOSetManager.CreateGOSetList(_arg_2, null);
            var _local_7:cGoSetListAnimationItem = new cGoSetListAnimationItem();
            _local_7.gridPos = _arg_1;
            _local_7.mGI = (this.mGeneralInterface as cGameInterface);
            gCalculations.ConvertStreetGridToPixelPos(this.mGeneralInterface.mCurrentPlayerZone, _arg_1, _local_7.pixelPos);
            _local_7.pixelPos.y = (_local_7.pixelPos.y + _arg_4);
            _local_7.animGoSetListContainer = _local_6;
            _local_7.runningTime = _arg_3;
            _local_7.object = _arg_5;
            this.mAnimations[_arg_1] = _local_7;
            this.mGeneralInterface.channels.RENDER.renderObjectAdded(_local_7);
        }

        public function RenderCompute():void
        {
        }

        public function IsSingleAnimationAtGridPos(_arg_1:int):Boolean
        {
            return (!(this.mIconAnimations[_arg_1] == null));
        }

        public function getSingleAnimations():Dictionary
        {
            return (this.mIconAnimations);
        }

        public function Reset():void
        {
            this.mGeneralInterface.channels.RENDER.clearByClass(RENDER_LAYER.MOVING, cGoSetListAnimationItem);
            this.mAnimations = new Dictionary();
            this.mIconAnimations = new Dictionary();
        }

        public function GetSingleAnimAtPos(_arg_1:int):cGoSetListAnimationItem
        {
            return (this.mIconAnimations[_arg_1] as cGoSetListAnimationItem);
        }

        public function Render():void
        {
        }

        public function RemoveSingleAnimation(_arg_1:int):void
        {
            this.mGeneralInterface.channels.RENDER.renderObjectRemoved(this.mIconAnimations[_arg_1]);
            this.mIconAnimations[_arg_1] = null;
        }

        public function GetAnimAtPos(_arg_1:int):cGoSetListAnimationItem
        {
            return (this.mAnimations[_arg_1] as cGoSetListAnimationItem);
        }

        public function AddSingleAnimation(_arg_1:int, _arg_2:String, _arg_3:Number, _arg_4:int, _arg_5:int, _arg_6:cGOGroup, _arg_7:Object):void
        {
            var _local_8:cGOSetList = cGOSetManager.CreateSingleGfxGOSetList(_arg_2, _arg_4, _arg_5, _arg_6);
            var _local_9:cGoSetListAnimationItem = new cGoSetListAnimationItem();
            _local_9.gridPos = _arg_1;
            _local_9.mGI = (this.mGeneralInterface as cGameInterface);
            gCalculations.ConvertStreetGridToPixelPos(this.mGeneralInterface.mCurrentPlayerZone, _arg_1, _local_9.pixelPos);
            _local_9.animGoSetListContainer = _local_8;
            _local_9.runningTime = _arg_3;
            _local_9.object = _arg_7;
            this.mIconAnimations[_arg_1] = _local_9;
            this.mGeneralInterface.channels.RENDER.renderObjectAdded(_local_9);
        }


    }
}
