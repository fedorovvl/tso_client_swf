package Communication.VO
{
    import Communication.VO.UpdateVO.dFindEventZoneResponseVO;

    public class dSpecialistTask_FindEventZoneVO extends dSpecialistTaskVO 
    {

        public var findEventZoneResponseVO:dFindEventZoneResponseVO;


        override public function toString():String
        {
            return (((("<dSpecialistTask_FindEventZoneVO " + super.dataString()) + " findEventZoneResponseVO='") + this.findEventZoneResponseVO) + "' />");
        }


    }
}
