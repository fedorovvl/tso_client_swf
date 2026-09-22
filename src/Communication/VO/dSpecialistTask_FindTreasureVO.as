package Communication.VO
{
    import Communication.VO.UpdateVO.dFindTreasureResponseVO;

    public class dSpecialistTask_FindTreasureVO extends dSpecialistTaskVO 
    {

        public var findTreasureResponseVO:dFindTreasureResponseVO;
        public var activeTwoStepEvent:String;


        override public function toString():String
        {
            return (((("<dSpecialistTask_FindTreasureVO " + super.dataString()) + " findTreasureResponseVO='") + this.findTreasureResponseVO) + "' />");
        }


    }
}
