package GUI.Components
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import mx.events.PropertyChangeEvent;
    import mx.controls.Button;
    import GUI.Assets.gAssetManager;
    import GUI.Loca.cLocaManager;
    import GUI.Components.ToolTips.cToolTipUtil;
    import Enums.LOCA_GROUP;
    import mx.events.ToolTipEvent;
    import global;

    // Connects a section to the current game state, including replaced players.
    public class ActionBarUpdates
    {
        private var update:Function;
        private var ui:IEventDispatcher;
        private var player:IEventDispatcher;
        private var buttons:Array = [];

        public function ActionBarUpdates(update:Function)
        {
            this.update = update;
            global.staticEventDispatcher.addEventListener("propertyChange", globalChanged, false, 0, true);
            cLocaManager.GetInstance().addEventListener("languageChanged", updateToolTips, false, 0, true);
            connectState();
        }

        public function configureButton(button:Button, icon:String, label:String):void
        {
            button.setStyle("upSkin", gAssetManager.GetClass(icon));
            button.setStyle("downSkin", gAssetManager.GetClass(icon + "Highlight"));
            button.setStyle("overSkin", gAssetManager.GetClass(icon + "Highlight"));
            button.setStyle("disabledSkin", gAssetManager.GetClass(icon + "Deactivated"));
            button.addEventListener("toolTipCreate", createToolTip);
            button.addEventListener("toolTipShow", showToolTip);
            buttons.push({button:button, label:label});
            updateToolTips();
        }

        private function updateToolTips(event:Event = null):void
        {
            for each (var entry:Object in buttons)
                entry.button.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, entry.label);
        }

        private function createToolTip(event:ToolTipEvent):void
        {
            cToolTipUtil.createToolTip(cToolTipUtil.SIMPLE_string, event);
        }

        private function showToolTip(event:ToolTipEvent):void
        {
            cToolTipUtil.positionActionBarTip(event);
        }

        private function globalChanged(event:PropertyChangeEvent):void
        {
            if (event.property == "ui_bindable") connectState();
        }

        private function connectState():void
        {
            if (ui) ui.removeEventListener("propertyChange", stateChanged);
            if (player)
            {
                player.removeEventListener("propertyChange", stateChanged);
                player.removeEventListener("levelChanged", levelChanged);
            }
            ui = global.ui_bindable as IEventDispatcher;
            player = global.ui_bindable ? global.ui_bindable.mCurrentPlayer as IEventDispatcher : null;
            if (ui) ui.addEventListener("propertyChange", stateChanged, false, 0, true);
            if (player)
            {
                player.addEventListener("propertyChange", stateChanged, false, 0, true);
                player.addEventListener("levelChanged", levelChanged, false, 0, true);
            }
            update();
        }

        private function stateChanged(event:PropertyChangeEvent):void
        {
            if (event.property == "mCurrentPlayer") connectState();
            else if (event.property == "mPacketLost" || event.property == "mIsDefenseMode" ||
                event.property == "mIsPlayerZone" || event.property == "mIsAdventureZone" ||
                event.property == "mIsColony") update();
        }

        private function levelChanged(event:Event):void
        {
            update();
        }
    }
}
