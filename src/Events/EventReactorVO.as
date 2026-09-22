package Events
{
    import __AS3__.vec.Vector;
    import Communication.VO.EffectVO;
    import Communication.VO.TriggerVO;
    import nLib.cXML;
    import __AS3__.vec.*;

    public class EventReactorVO 
    {

        public var effects_vector:Vector.<EffectVO> = new Vector.<EffectVO>();
        public var triggerVO:TriggerVO;


        public static function CreateFromXML(_arg_1:cXML):EventReactorVO
        {
            var _local_4:cXML;
            var _local_2:EventReactorVO = new (EventReactorVO)();
            _local_2.triggerVO = TriggerVO.createFromXML(_arg_1, -1);
            _local_2.effects_vector = new Vector.<EffectVO>();
            var _local_3:Vector.<cXML> = _arg_1.MoveToSubNodeAndCreateChildrenArray("effect");
            for each (_local_4 in _local_3)
            {
                _local_2.effects_vector.push(EffectVO.CreateFromXML(_local_4));
            };
            return (_local_2);
        }


    }
}
