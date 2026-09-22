package GO.buildings
{
    import GO.cBuilding;
    import GOSets.cGOSetList;
    import Interface.cGeneralInterface;
    import GOSets.cGOSetManager;
    import Map.GridPosition;

    public class FloatingBuilding extends cBuilding 
    {

        private var mShadowOffsetY:int = 0;
        private var mFloatingRangeMultiplier:Number = 0;
        private var mShadowGfx:cGOSetList;
        private var mHasShadowSprite:Boolean = false;
        private var mRenderOffsetOverrideY:int = 0;
        private var mShadowOffsetX:int = 0;

        public function FloatingBuilding(_arg_1:cGeneralInterface, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:Number, _arg_7:Boolean)
        {
            super(_arg_1, _arg_2);
            this.mShadowOffsetY = _arg_3;
            this.mShadowOffsetX = _arg_4;
            this.mRenderOffsetOverrideY = _arg_5;
            this.mHasShadowSprite = _arg_7;
            this.mFloatingRangeMultiplier = _arg_6;
        }

        public function SetShadowSprite():void
        {
            this.mShadowGfx = cGOSetManager.CreateSingleGfxGOSetList((GetBuildingName_string() + "_shadow"), 0, 0, global.effectGroup);
        }

        override public function SetGrid(_arg_1:int):void
        {
            super.SetGrid(_arg_1);
            renderSortGrid = (((GridPosition.getY(GetGrid(), mGeneralInterface.mCurrentPlayerZone.mMapWidth) + this.mRenderOffsetOverrideY) * 1000) + (GetGrid() % mGeneralInterface.mCurrentPlayerZone.mMapWidth));
            updateRenderPosition();
        }

        override public function Render():void
        {
            mRenderOffsetY = (mGeneralInterface.mOscillatingInt * this.mFloatingRangeMultiplier);
            if (((this.mShadowGfx == null) && (this.mHasShadowSprite)))
            {
                this.SetShadowSprite();
            };
            if (this.mHasShadowSprite)
            {
                this.mShadowGfx.Render((mXNotScaled + this.mShadowOffsetX), ((mYNotScaled + this.mShadowOffsetY) - ((mGeneralInterface.mOscillatingInt * mGeneralInterface.mZoom.mFactorDivDefaultZoom) * this.mFloatingRangeMultiplier)));
            };
            super.Render();
        }


    }
}
