package com.bluebyte.tso.server
{
    import Model.Notifier;
    import flash.utils.Dictionary;
    import com.bluebyte.tso.util.ClientLogger;
    import flash.events.Event;
    import Communication.VO.UpdateVO.dKillSwitchUpdateVO;

    public class KillSwitch extends Notifier 
    {

        private var map:Dictionary = new Dictionary();


        public function update(_arg_1:dKillSwitchUpdateVO):void
        {
            var _local_4:String;
            if (!_arg_1)
            {
                return;
            };
            var _local_2:Dictionary = new Dictionary();
            var _local_3:Boolean;
            for each (_local_4 in _arg_1.features)
            {
                if (!(_local_4 in this.map))
                {
                    notifyPropertyObserver(_local_4, true);
                    ClientLogger.log((('Killswitch set for "' + _local_4) + '". Feature is disabled.'));
                    _local_3 = true;
                };
                _local_2[_local_4] = true;
            };
            for (_local_4 in this.map)
            {
                if (!_arg_1.features.contains(_local_4))
                {
                    notifyPropertyObserver(_local_4, false);
                    ClientLogger.log((('Killswitch unset for "' + _local_4) + '". Feature is enabled.'));
                    _local_3 = true;
                };
            };
            this.map = _local_2;
            if (_local_3)
            {
                dispatchEvent(new Event("updated"));
            };
        }

        [Bindable(event="updated")]
        public function isLocked(_arg_1:String):Boolean
        {
            var _local_4:String;
            var _local_2:Array = _arg_1.split(".");
            var _local_3:* = "";
            for each (_local_4 in _local_2)
            {
                _local_3 = (_local_3 + _local_4);
                if ((_local_3 in this.map))
                {
                    return (true);
                };
                _local_3 = (_local_3 + ".");
            };
            return (false);
        }

        [Bindable(event="updated")]
        public function isAccessible(_arg_1:String):Boolean
        {
            return (!(this.isLocked(_arg_1)));
        }


    }
}
