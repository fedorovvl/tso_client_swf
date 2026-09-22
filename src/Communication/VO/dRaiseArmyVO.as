package Communication.VO
{
    import mx.collections.ArrayCollection;

    public class dRaiseArmyVO 
    {

        public var armyHolderSpecialistVO:dSpecialistVO = null;
        public var unitSquads:ArrayCollection = new ArrayCollection();
        public var armyHolderBuildingVO:dBuildingVO = null;


        public function toString():String
        {
            var _local_1:* = (((("<RaiseArmyVO armyHolderBuildingVO='" + this.armyHolderBuildingVO) + "' armyHolderSpecialistVO='") + this.armyHolderSpecialistVO) + "' >\n");
            _local_1 = (_local_1 + gCalculations.createListString("Squads", this.unitSquads));
            return (_local_1 + "</RaiseArmyVO>");
        }


    }
}
