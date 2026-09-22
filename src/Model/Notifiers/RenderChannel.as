package Model.Notifiers
{
    import converted.bluebyte.tso.rendering.IRenderListRenderable;

    public final class RenderChannel extends Channel 
    {

        public static const ADDED:String = "added";
        public static const REMOVED:String = "removed";
        public static const CLEAR:String = "clear";


        public function renderObjectAdded(_arg_1:IRenderListRenderable):void
        {
            if (_arg_1 != null)
            {
                send(ADDED, _arg_1);
            };
        }

        public function clearByClass(_arg_1:int, _arg_2:Class):void
        {
            send(CLEAR, new RenderChannelClearNotification(_arg_1, _arg_2));
        }

        public function renderObjectRemoved(_arg_1:IRenderListRenderable):void
        {
            if (_arg_1 != null)
            {
                send(REMOVED, _arg_1);
            };
        }

        public function clearLayer(_arg_1:int):void
        {
            send(CLEAR, new RenderChannelClearNotification(_arg_1, null));
        }


    }
}
