package Communication.VO.collectibles
{
    public class PickupsDataVO 
    {

        public var numberOfGeneratedPickups:int;
        public var generatedPickupsType:int;


        public function init(_arg_1:int, _arg_2:int):PickupsDataVO
        {
            this.generatedPickupsType = _arg_1;
            this.numberOfGeneratedPickups = _arg_2;
            return (this);
        }


    }
}
