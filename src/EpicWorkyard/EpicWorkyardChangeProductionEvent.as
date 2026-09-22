package EpicWorkyard
{
    import flash.events.Event;
    import GO.epicWorkyard.EpicWorkyardSubBuilding;

    public class EpicWorkyardChangeProductionEvent extends Event 
    {

        private var subBuilding:EpicWorkyardSubBuilding;

        public function EpicWorkyardChangeProductionEvent(_arg_1:String, _arg_2:EpicWorkyardSubBuilding)
        {
            super(_arg_1, false, true);
            this.subBuilding = _arg_2;
        }

        public function getSubBuilding():EpicWorkyardSubBuilding
        {
            return (this.subBuilding);
        }


    }
}
