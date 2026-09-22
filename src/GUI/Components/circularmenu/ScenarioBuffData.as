package GUI.Components.circularmenu
{
    import BuffSystem.cBuffDefinition;
    import GUI.Assets.gAssetManager;

    public class ScenarioBuffData 
    {

        public var definiton:cBuffDefinition;
        public var icon:Object;
        public var amountNeeded:int = 0;
        public var amount:int = 0;

        public function ScenarioBuffData(_arg_1:cBuffDefinition, _arg_2:int=-1, _arg_3:int=1)
        {
            super();
            this.definiton = _arg_1;
            this.icon = gAssetManager.GetBuffIcon(_arg_1.GetName_string());
            this.amount = _arg_2;
            this.amountNeeded = _arg_3;
        }

    }
}
