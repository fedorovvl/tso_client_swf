package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;

    public final class MoveCamera extends Effect 
    {


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
            applyAsGameTick = true;
        }

        override protected function action():void
        {
            effect.calculateGridPosFromXY(gi.mCurrentPlayerZone.mMapWidth);
            if (((!(global.ui == null)) && (effect.targetGridPos > 0)))
            {
                if (global.ui.mCurrentPlayerZone.mStreetDataMap.IsFogAtGridPosition(effect.targetGridPos))
                {
                    return;
                };
                global.ui.mCurrentPlayerZone.ScrollToGrid(effect.targetGridPos);
            };
        }


    }
}
