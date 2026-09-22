package Communication.VO
{
    import mx.collections.ArrayCollection;
    import __AS3__.vec.*;

    public class PlayerOptionsVO 
    {

        public var options:ArrayCollection = new ArrayCollection();


        public static function createSingleOptionVO(_arg_1:String, _arg_2:String):PlayerOptionsVO
        {
            var _local_3:PlayerOptionsVO = new (PlayerOptionsVO)();
            _local_3.AddOption(PlayerOptionVO.Create(_arg_1, _arg_2));
            return (_local_3);
        }

        public static function Create():PlayerOptionsVO
        {
            return (new (PlayerOptionsVO)());
        }


        public function AddOption(_arg_1:PlayerOptionVO):void
        {
            this.options.addItem(_arg_1);
        }

        public function Clear():void
        {
            this.options = new Vector.<PlayerOptionVO>();
        }


    }
}
