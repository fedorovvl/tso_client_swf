package Communication.VO
{
    public class dRequirementListsVO 
    {

        private static const REQUIREMENT_TYPE_BUILDING:String = "building";
        private static const REQUIREMENT_TYPE_PRODUCTION:String = "production";
        private static const REQUIREMENT_TYPE_TASK:String = "task";
        private static const REQUIREMENT_TYPE_ADVENTURE:String = "adventure";
        private static const REQUIREMENT_TYPE_ITEM:String = "item";
        private static const REQUIREMENT_TYPE_MISC:String = "misc";
        private static const REQUIREMENT_TYPE_PICKUPMANAGER:String = "pickupmanager";
        private static const REQUIREMENT_TYPE_CHAIN:String = "chain";

        public var buildingRequirements_vector:Object = {};
        public var timedProductionRequirements_vector:Object = {};
        public var specialistTaskRequirements_vector:Object = {};
        public var adventureRequirements_vector:Object = {};
        public var itemRequirements_vector:Object = {};
        public var pickupManagerRequirements_vector:Object = {};
        public var chainRequirements_vector:Object = {};
        public var miscRequirements_vector:Object = {};


        public function getRequirementsByName(_arg_1:String):Object
        {
            _arg_1 = _arg_1.toLowerCase();
            if (_arg_1 == REQUIREMENT_TYPE_BUILDING)
            {
                return (this.buildingRequirements_vector);
            };
            if (_arg_1 == REQUIREMENT_TYPE_PRODUCTION)
            {
                return (this.timedProductionRequirements_vector);
            };
            if (_arg_1 == REQUIREMENT_TYPE_TASK)
            {
                return (this.specialistTaskRequirements_vector);
            };
            if (_arg_1 == REQUIREMENT_TYPE_ADVENTURE)
            {
                return (this.adventureRequirements_vector);
            };
            if (_arg_1 == REQUIREMENT_TYPE_ITEM)
            {
                return (this.itemRequirements_vector);
            };
            if (_arg_1 == REQUIREMENT_TYPE_MISC)
            {
                return (this.miscRequirements_vector);
            };
            if (_arg_1 == REQUIREMENT_TYPE_PICKUPMANAGER)
            {
                return (this.pickupManagerRequirements_vector);
            };
            if (_arg_1 == REQUIREMENT_TYPE_CHAIN)
            {
                return (this.chainRequirements_vector);
            };
            return (null);
        }


    }
}
