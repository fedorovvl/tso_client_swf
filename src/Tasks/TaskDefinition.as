package Tasks
{
    import Fulfilments.IdentityDefinition;
    import __AS3__.vec.Vector;
    import Communication.VO.EffectVO;
    import Communication.VO.TriggerVO;
    import __AS3__.vec.*;

    public class TaskDefinition extends IdentityDefinition 
    {

        public var isPvp:Boolean = false;
        public var reward_vector:Vector.<EffectVO> = new Vector.<EffectVO>();

        public function TaskDefinition(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:Boolean, _arg_5:Boolean, _arg_6:Vector.<TriggerVO>, _arg_7:Vector.<EffectVO>)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_6);
            this.reward_vector = _arg_7;
            this.isPvp = _arg_5;
        }

    }
}
