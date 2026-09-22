package Communication.VO
{
    public class PlayerOptionVO 
    {

        public var value:String;
        public var settingName:String;

        public function PlayerOptionVO():void
        {
            super();
        }

        public static function Create(_arg_1:String, _arg_2:String):PlayerOptionVO
        {
            var _local_3:PlayerOptionVO = new (PlayerOptionVO)();
            _local_3.settingName = _arg_1;
            _local_3.value = _arg_2;
            return (_local_3);
        }


    }
}
