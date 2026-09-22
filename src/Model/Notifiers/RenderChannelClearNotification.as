package Model.Notifiers
{
    public class RenderChannelClearNotification 
    {

        public var renderableClass:Class;
        public var layer:int;

        public function RenderChannelClearNotification(_arg_1:int, _arg_2:Class)
        {
            super();
            this.layer = _arg_1;
            this.renderableClass = _arg_2;
        }

    }
}
