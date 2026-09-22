package Trigger.vo
{
    import flash.utils.Dictionary;

    public class CompleteAdventureUnitsLostTriggerVO 
    {

        private var adventureName:String;
        private var casualties:Dictionary;

        public function CompleteAdventureUnitsLostTriggerVO(_arg_1:String, _arg_2:Dictionary)
        {
            super();
            this.adventureName = _arg_1;
            this.casualties = _arg_2;
        }

        public function getCasualties():Dictionary
        {
            return (this.casualties);
        }

        public function getAdventureName():String
        {
            return (this.adventureName);
        }


    }
}
