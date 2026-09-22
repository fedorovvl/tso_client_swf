package GUI.Components
{
    import mx.controls.TileList;

    public class TabEnabledTileList extends TileList 
    {


        override public function initialize():void
        {
            super.initialize();
        }

        override protected function createChildren():void
        {
            super.createChildren();
            this.listContent.tabChildren = this.tabChildren;
            this.listContent.tabEnabled = this.tabEnabled;
        }


    }
}
