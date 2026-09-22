package GUI.Components
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import mx.events.PropertyChangeEvent;
    import GUI.Loca.cLocaManager;
    import global;

    // Keeps Avatar state in sync without MXML bindings: ui_bindable
    // replacement and mPacketLost/mIsDefenseMode changes refresh the
    // controls, languageChanged refreshes the localized tooltip.
    public class AvatarUpdates
    {
        private var update:Function;
        private var ui:IEventDispatcher;

        public function AvatarUpdates(update:Function)
        {
            this.update = update;
            global.staticEventDispatcher.addEventListener("propertyChange", globalChanged, false, 0, true);
            cLocaManager.GetInstance().addEventListener("languageChanged", languageChanged, false, 0, true);
            connectState();
        }

        private function languageChanged(event:Event):void
        {
            update();
        }

        private function globalChanged(event:PropertyChangeEvent):void
        {
            if (event.property == "ui_bindable") connectState();
        }

        private function connectState():void
        {
            if (ui) ui.removeEventListener("propertyChange", stateChanged);
            ui = global.ui_bindable as IEventDispatcher;
            if (ui) ui.addEventListener("propertyChange", stateChanged, false, 0, true);
            update();
        }

        private function stateChanged(event:PropertyChangeEvent):void
        {
            if (event.property == "mPacketLost" || event.property == "mIsDefenseMode") update();
        }
    }
}
