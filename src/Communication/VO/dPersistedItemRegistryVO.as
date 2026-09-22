package Communication.VO
{
    import ServerOnly.DirtyIndicator;

    public class dPersistedItemRegistryVO 
    {

        public var requiresEvent_string:String;
        public var itemType:int;
        public var itemName_string:String;
        public var resource_name_string:String;
        public var amount:int;
        public var dirtyIndicator:DirtyIndicator = new DirtyIndicator();

        public function dPersistedItemRegistryVO()
        {
            super();
            this.dirtyIndicator.created();
        }

        public function GetKey_string():String
        {
            return ((((this.itemType + "_") + this.itemName_string) + "_") + this.resource_name_string);
        }

        public function toString():String
        {
            return (((((((((((((((("<dPersistedItemRegistryVO " + "itemType='") + this.itemType) + "' ") + "itemName_string='") + this.itemName_string) + "' ") + "resourceName_string='") + this.resource_name_string) + "' ") + "requiresEvent='") + this.requiresEvent_string) + "' ") + "amount='") + this.amount) + "' ") + " />");
        }


    }
}
