package Communication.VO
{
    public class AddResourceResponseVO 
    {

        private var addedDirectly:Boolean;
        private var addedSuccessfully:Boolean;

        public function AddResourceResponseVO(_arg_1:Boolean, _arg_2:Boolean)
        {
            super();
            this.addedSuccessfully = _arg_1;
            this.addedDirectly = _arg_2;
        }

        public function getAddedDirectly():Boolean
        {
            return (this.addedDirectly);
        }

        public function getAddedSuccessfully():Boolean
        {
            return (this.addedSuccessfully);
        }


    }
}
