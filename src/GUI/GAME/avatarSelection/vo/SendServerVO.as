package GUI.GAME.avatarSelection.vo
{
    import Interface.cGeneralInterface;

    public class SendServerVO 
    {

        private var gi:cGeneralInterface;
        private var requestVO:Object;

        public function SendServerVO(_arg_1:cGeneralInterface, _arg_2:Object)
        {
            super();
            this.gi = _arg_1;
            this.requestVO = _arg_2;
        }

        public function getGeneralInterface():cGeneralInterface
        {
            return (this.gi);
        }

        public function getRequestVO():Object
        {
            return (this.requestVO);
        }


    }
}
