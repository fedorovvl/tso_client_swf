package Communication.VO
{
    public class dResourceCreationVO 
    {

        public var playerId:int;
        public var remove:Boolean;
        public var gatheredResource:int;
        public var depositBuildingGridPos:int;
        public var uniqueID:dUniqueID = new dUniqueID();
        public var pathVO:dPathVO;
        public var pathPos:int;
        public var productionState:int;
        public var settlerKIState:int;
        public var assignedSettler:Boolean;
        public var resourceDefinitionID:int;


        public function toString():String
        {
            var _local_1:* = (((((((((((((((("<ResourceCreationVO resourceDefinitionID='" + this.resourceDefinitionID) + "' depositBuildingGridPos='") + this.depositBuildingGridPos) + "' pathPos='") + this.pathPos) + "' playerId='") + this.playerId) + "' gatheredResource='") + this.gatheredResource) + "' assignedSettler='") + this.assignedSettler) + "' settlerKIState='") + this.settlerKIState) + "' productionState='") + this.productionState) + "'  >\n");
            if (this.pathVO != null)
            {
                _local_1 = (_local_1 + ("" + this.pathVO));
            };
            return (_local_1 + "</ResourceCreationVO>");
        }


    }
}
