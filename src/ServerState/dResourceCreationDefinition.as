package ServerState
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class dResourceCreationDefinition 
    {

        public var ignoreMaxWarehouseLimit:Boolean;
        public var necessaryResources_vector:Vector.<dResource> = new Vector.<dResource>();
        public var defaultSetting:dResourceDefaultDefinition;
        public var externalResource_string:String;
        public var id:int;
        public var typeEnumResourceType:int;
        public var amountRemoved:int;
        public var externalResourceDeposit_string:String;
        public var buildingName_string:String;
        public var necessaryResourcesUI_vector:Vector.<dResource> = new Vector.<dResource>();
        public var workTime:int;


        public function clone():dResourceCreationDefinition
        {
            var _local_2:dResource;
            var _local_1:dResourceCreationDefinition = new dResourceCreationDefinition();
            _local_1.defaultSetting = this.defaultSetting;
            _local_1.id = this.id;
            _local_1.typeEnumResourceType = this.typeEnumResourceType;
            _local_1.buildingName_string = this.buildingName_string;
            _local_1.externalResource_string = this.externalResource_string;
            _local_1.amountRemoved = this.amountRemoved;
            _local_1.workTime = this.workTime;
            _local_1.ignoreMaxWarehouseLimit = this.ignoreMaxWarehouseLimit;
            for each (_local_2 in this.necessaryResources_vector)
            {
                _local_1.necessaryResources_vector.push(_local_2);
            };
            for each (_local_2 in this.necessaryResourcesUI_vector)
            {
                _local_1.necessaryResourcesUI_vector.push(_local_2);
            };
            return (_local_1);
        }

        public function toString():String
        {
            return (((((("<ResourceCreationDefinition building='" + this.buildingName_string) + "', externalResource='") + this.externalResource_string) + "', necessaryResources_vector='") + this.necessaryResources_vector) + "' >");
        }


    }
}
