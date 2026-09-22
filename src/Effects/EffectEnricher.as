package Effects
{
    import Communication.VO.EffectVO;
    import __AS3__.vec.Vector;

    public interface EffectEnricher 
    {

        function enrichEffect(_arg_1:EffectVO):EffectVO;
        function enrichExtraEffects(_arg_1:EffectVO):Vector.<EffectVO>;

    }
}
