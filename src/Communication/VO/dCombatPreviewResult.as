package Communication.VO
{
    public class dCombatPreviewResult 
    {

        public var buildingGrid:int;
        public var feedback_string:String;
        public var specialistUniqueID:dUniqueID;


        public function Init(_arg_1:dUniqueID, _arg_2:int, _arg_3:String):dCombatPreviewResult
        {
            this.specialistUniqueID = _arg_1;
            this.buildingGrid = _arg_2;
            this.feedback_string = _arg_3;
            return (this);
        }

        public function toString():String
        {
            return (((((("<dCombatPreviewResult specialistUniqueID='" + this.specialistUniqueID) + "' buildingGrid='") + this.buildingGrid) + "' feedback='") + this.feedback_string) + "' />");
        }


    }
}
