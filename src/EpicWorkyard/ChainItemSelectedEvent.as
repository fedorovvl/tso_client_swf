package EpicWorkyard
{
    import flash.events.Event;
    import GUI.Components.ItemRenderer.EpicWorkyardChainItemRenderer;

    public class ChainItemSelectedEvent extends Event 
    {

        public static const ITEM_SELECTED:String = "itemSelected";

        private var chainRenderer:EpicWorkyardChainItemRenderer;

        public function ChainItemSelectedEvent(_arg_1:String, _arg_2:EpicWorkyardChainItemRenderer)
        {
            super(_arg_1, false, true);
            this.chainRenderer = _arg_2;
        }

        public function getChainRenderer():EpicWorkyardChainItemRenderer
        {
            return (this.chainRenderer);
        }


    }
}
