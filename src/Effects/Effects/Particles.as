package Effects.Effects
{
    import Effects.Effect;
    import Utils.StringUtils;

    public class Particles extends Effect 
    {

        public static const XML_string:String = "particles";


        override protected function action():void
        {
            if (StringUtils.isEmpty(effect.name_string))
            {
                global.getApplication().particlePlane.stop();
            }
            else
            {
                global.getApplication().particlePlane.start(StringUtils.split(effect.name_string, ","));
            };
        }


    }
}
