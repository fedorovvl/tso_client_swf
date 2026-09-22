package GUI.Components.tooltipData
{
    import __AS3__.vec.Vector;
    import ServerState.dResource;

    public class MissingResourcesTooltipData 
    {

        private var descriptionText:String;
        private var headerText:String;
        private var missingResources:Vector.<dResource>;

        public function MissingResourcesTooltipData(_arg_1:String, _arg_2:String, _arg_3:Vector.<dResource>)
        {
            super();
            this.headerText = _arg_1;
            this.descriptionText = _arg_2;
            this.missingResources = _arg_3;
        }

        public function getHeaderText():String
        {
            return (this.headerText);
        }

        public function getMissingResources():Vector.<dResource>
        {
            return (this.missingResources);
        }

        public function getDescriptionText():String
        {
            return (this.descriptionText);
        }


    }
}
