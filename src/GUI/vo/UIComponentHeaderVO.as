package GUI.vo
{
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import Interface.cGeneralInterface;

    public class UIComponentHeaderVO 
    {

        private var graphicHeaders:Vector.<GraphicsHeaderVO>;
        private var componentIDs:Dictionary;

        public function UIComponentHeaderVO(_arg_1:String, _arg_2:Vector.<GraphicsHeaderVO>)
        {
            var _local_4:String;
            super();
            this.graphicHeaders = _arg_2;
            var _local_3:Array = _arg_1.split(",");
            this.componentIDs = new Dictionary();
            for each (_local_4 in _local_3)
            {
                this.componentIDs[_local_4] = true;
            };
        }

        public function hasComponentID(_arg_1:String):Boolean
        {
            return (!(this.componentIDs[_arg_1] == null));
        }

        public function getComponentHeaderClassName(_arg_1:cGeneralInterface, _arg_2:String):String
        {
            var _local_3:GraphicsHeaderVO;
            var _local_4:GraphicsHeaderVO;
            if (this.hasComponentID(_arg_2))
            {
                for each (_local_4 in this.graphicHeaders)
                {
                    if (_local_4.isDefault())
                    {
                        _local_3 = _local_4;
                    }
                    else
                    {
                        if (_arg_1.mEventManager.isEventStarted(_local_4.getRequiresEvent()))
                        {
                            return (_local_4.getGraphicsClassName());
                        };
                    };
                };
                return (_local_3.getGraphicsClassName());
            };
            return (null);
        }


    }
}
