package GUI.event
{
    import flash.events.Event;
    import mx.events.ToolTipEvent;

    public class CreateInGameTooltipEvent extends Event 
    {

        public static const CREATE_TOOLTIP:String = "createTooltip";

        public var toolTipEvent:ToolTipEvent;

        public function CreateInGameTooltipEvent(_arg_1:ToolTipEvent)
        {
            this.toolTipEvent = _arg_1;
            super(CREATE_TOOLTIP, false, true);
        }

    }
}
