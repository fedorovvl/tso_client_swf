package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import GUI.Components.MemoryMonitorPanel;
    import Interface.cGameInterface;
    import flash.events.Event;

    public class cMemoryMonitorPanel extends cGuiBaseElement
    {
        private var mGI:cGameInterface;
        public var mPanel:MemoryMonitorPanel;

        public function Init(panel:MemoryMonitorPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(panel);
            this.mPanel = panel;
        }

        override public function Show():void
        {
            this.mPanel.addEventListener(Event.ENTER_FRAME, this.calculateMemoryUsage);
            this.calculateMemoryUsage();
            super.Show();
        }

        override public function Hide():void
        {
            this.mPanel.removeEventListener(Event.ENTER_FRAME, this.calculateMemoryUsage);
            super.Hide();
        }

        private function calculateMemoryUsage(event:Event = null):void
        {
            global.getApplication().mMemoryMonitor.CalculateMemoryUsage();
            this.mPanel.refreshValues();
        }
    }
}
