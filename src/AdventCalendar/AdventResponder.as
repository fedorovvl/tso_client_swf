package AdventCalendar
{
    import ServerState.Responding;
    import GUI.Components.ItemRenderer.AdventFeaturedItemRenderer;
    import GUI.Components.ItemRenderer.AdventDoorRenderer;
    import Communication.VO.dAdventCalendarDoorVO;
    import flash.display.DisplayObject;
    import nLib.cLog;
    import Communication.VO.dServerActionResult;
    import Communication.VO.dGameTickCommandVO;

    public final class AdventResponder implements Responding 
    {

        private var featuredRenderer:AdventFeaturedItemRenderer;
        private var renderer:AdventDoorRenderer;
        private var vo:dAdventCalendarDoorVO;

        public function AdventResponder(_arg_1:dAdventCalendarDoorVO, _arg_2:DisplayObject)
        {
            super();
            this.vo = _arg_1;
            if ((_arg_2 is AdventDoorRenderer))
            {
                this.renderer = (_arg_2 as AdventDoorRenderer);
            }
            else
            {
                if ((_arg_2 is AdventFeaturedItemRenderer))
                {
                    this.featuredRenderer = (_arg_2 as AdventFeaturedItemRenderer);
                };
            };
        }

        public function onFault(_arg_1:int, _arg_2:dServerActionResult):void
        {
            cLog.error(("Fault response on Advent door handling! " + _arg_2.data));
            if (this.renderer)
            {
                this.renderer.data = this.vo;
                if (this.vo.IsSpecial())
                {
                    this.vo.chosenRewardId = -1;
                };
                globalFlash.gui.mAdventWindow.ResetDoorWaiting(this.vo);
            };
        }

        public function onResult(_arg_1:int, _arg_2:dServerActionResult):void
        {
            var _local_3:dAdventCalendarDoorVO = ((_arg_2.data as dGameTickCommandVO).data as dAdventCalendarDoorVO);
            this.vo.chosenRewardId = _local_3.chosenRewardId;
            if (this.renderer)
            {
                this.renderer.open();
            }
            else
            {
                if (this.featuredRenderer)
                {
                    this.featuredRenderer.open();
                };
            };
        }


    }
}
