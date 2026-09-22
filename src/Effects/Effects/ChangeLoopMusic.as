package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import AdventureSystem.cAdventureDefinition;
    import Sound.cSoundManager;

    public final class ChangeLoopMusic extends Effect 
    {

        public static const XML_string:String = "changeloopmusic";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
            applyAsGameTick = true;
        }

        override protected function action():void
        {
            var _local_1:cAdventureDefinition;
            if (((!(effect.name_string == null)) && (!(effect.name_string == ""))))
            {
                cSoundManager.getInstance().playLoop(effect.name_string);
            }
            else
            {
                if (((!(gi.getAdventureName() == "Home")) && (!(gi.getAdventureName() == null))))
                {
                    _local_1 = cAdventureDefinition.FindAdventureDefinition(gi.getAdventureName());
                    if (_local_1 != null)
                    {
                        cSoundManager.getInstance().playLoop(_local_1.GetMusic_string());
                    };
                }
                else
                {
                    cSoundManager.getInstance().playLoop();
                };
            };
        }


    }
}
