package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import Enums.COMMAND;

    public class ChangeAvatar extends Effect 
    {


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
            applyAsGameTick = true;
        }

        override protected function action():void
        {
            gi.mCurrentPlayer.ChangeAvatarIdBy(effect.value);
            globalFlash.gui.mAvatar.SetData(gi.mCurrentPlayer, gi.GetPlayerList_vector());
            globalFlash.gui.mFriendsList.Refresh();
            gi.requestZonePersistence(COMMAND.APPLY_EFFECT);
        }


    }
}
