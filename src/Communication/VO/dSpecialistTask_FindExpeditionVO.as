package Communication.VO
{
    import Communication.VO.UpdateVO.dFindExpeditionResponseVO;

    public class dSpecialistTask_FindExpeditionVO extends dSpecialistTaskVO 
    {

        public var findExpeditionResponseVO:dFindExpeditionResponseVO;


        override public function toString():String
        {
            return (((("<dSpecialistTask_FindExpeditionVO " + super.dataString()) + " findExpeditionResponseVO='") + this.findExpeditionResponseVO) + "' />");
        }


    }
}
