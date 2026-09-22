package Trigger
{
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;

    public class TimedTrigger extends InstantTrigger 
    {

        public function TimedTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_3.getTimedTriggerManager().registerTrigger(this);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).getTimedTriggerManager().unregisterTrigger(this);
            super.dispose();
        }


    }
}
