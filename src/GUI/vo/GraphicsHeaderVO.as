package GUI.vo
{
    public class GraphicsHeaderVO 
    {

        private var graphicsClassName:String;
        private var requiresEvent:String;

        public function GraphicsHeaderVO(_arg_1:String, _arg_2:String="")
        {
            super();
            this.graphicsClassName = _arg_1;
            this.requiresEvent = _arg_2;
        }

        public function getGraphicsClassName():String
        {
            return (this.graphicsClassName);
        }

        public function getRequiresEvent():String
        {
            return (this.requiresEvent);
        }

        public function isDefault():Boolean
        {
            return (this.requiresEvent == "");
        }


    }
}
