package Tracks
{
    import Model.Observer;
    import GUI.GAME.cBasicPanel;
    import Model.Notifier;

    public class UITimeAndClickDetection implements Observer 
    {

        private var windowStartTime:Object = new Object();

        public function UITimeAndClickDetection()
        {
            super();
            global.ui.inputNotifier.addPropertyObserver(cBasicPanel.EVENT_CLICK, this);
            global.ui.inputNotifier.addPropertyObserver(cBasicPanel.EVENT_SHOW, this);
            global.ui.inputNotifier.addPropertyObserver(cBasicPanel.EVENT_HIDE, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:Number;
            var _local_5:Number;
            if (_arg_2 == cBasicPanel.EVENT_CLICK)
            {
                TrackManager.getInstance().trackUI(global.ui.mCurrentPlayer.GetPlayerId(), "UI Click", String(_arg_3), 1, true);
            }
            else
            {
                if (_arg_2 == cBasicPanel.EVENT_SHOW)
                {
                    this.windowStartTime[String(_arg_3)] = new Date().getTime();
                }
                else
                {
                    if (_arg_2 == cBasicPanel.EVENT_HIDE)
                    {
                        _local_4 = this.windowStartTime[String(_arg_3)];
                        _local_5 = ((new Date().getTime() - _local_4) / 1000);
                        TrackManager.getInstance().trackUI(global.ui.mCurrentPlayer.GetPlayerId(), "UI Open Time", String(_arg_3), _local_5, true);
                    };
                };
            };
        }


    }
}
