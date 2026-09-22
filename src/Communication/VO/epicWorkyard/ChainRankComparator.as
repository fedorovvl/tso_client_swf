package Communication.VO.epicWorkyard
{
    public class ChainRankComparator 
    {


        public static function compare(_arg_1:ChainVO, _arg_2:ChainVO):int
        {
            if (_arg_1.getRank() >= _arg_2.getRank())
            {
                return (1);
            };
            return (-1);
        }


    }
}
