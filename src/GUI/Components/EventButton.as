package GUI.Components
{
    import Events.EventButtonData;
    import GUI.Assets.gAssetManager;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;

    public class EventButton extends StandardButton 
    {

        public static const CHANGELOG:String = "changelog";
        public static const PROMOCODE:String = "promocode";
        public static const EXTERNAL_SITE:String = "externalsite";
        public static const WEB_SHOP:String = "WEB_SHOP";

        public function EventButton()
        {
            super();
            this.width = 70;
            this.height = 32;
        }

        override public function initialize():void
        {
            super.initialize();
        }

        override public function set data(_arg_1:Object):void
        {
            var _local_2:EventButtonData;
            super.data = _arg_1;
            if ((_arg_1 is EventButtonData))
            {
                _local_2 = (_arg_1 as EventButtonData);
                enabled = _local_2.enabled;
                setStyle("icon", gAssetManager.GetClass(_local_2.icon));
                if (_local_2.name == "CLOSE_WINDOW")
                {
                    toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Close");
                }
                else
                {
                    toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.TOOLTIP, _local_2.tooltip);
                };
            };
        }


    }
}
