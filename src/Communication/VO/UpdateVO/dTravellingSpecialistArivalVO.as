package Communication.VO.UpdateVO
{
    import Communication.VO.dSpecialistVO;

    public class dTravellingSpecialistArivalVO 
    {

        public var specialistVO:dSpecialistVO;


        public function Init(_arg_1:dSpecialistVO):dTravellingSpecialistArivalVO
        {
            this.specialistVO = _arg_1;
            return (this);
        }


    }
}
