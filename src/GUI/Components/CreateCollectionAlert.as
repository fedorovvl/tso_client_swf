package GUI.Components
{
    import mx.core.UIComponentDescriptor;
    import mx.core.mx_internal;
    import flash.display.Sprite;
    import mx.containers.HBox;
    import ServerState.dResource;
    import GUI.Components.ItemRenderer.ResourceItemRenderer;

    public class CreateCollectionAlert extends CustomAlert 
    {

        private const MAX_HORIZONTAL_RESOURCES:int = 3;

        private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({"type":CustomAlert});

        public function CreateCollectionAlert()
        {
            super();
            mx_internal::_document = this;
        }

        public static function show(_arg_1:String="", _arg_2:String="", _arg_3:uint=4, _arg_4:Sprite=null, _arg_5:Function=null, _arg_6:Class=null, _arg_7:uint=4, _arg_8:Boolean=true, _arg_9:int=0, _arg_10:*=null, _arg_11:String="center"):CustomAlert
        {
            return (showAlert(CreateCollectionAlert, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11));
        }


        override public function initialize():void
        {
            (mx_internal::setDocumentDescriptor(this._documentDescriptor_));
            super.initialize();
        }

        private function addNewHorizontalResourcesList():HBox
        {
            var _local_1:HBox;
            _local_1 = new HBox();
            _local_1.height = 25;
            VResourceList.addChild(_local_1);
            return (_local_1);
        }

        override protected function addResource():void
        {
            var _local_3:dResource;
            var _local_4:ResourceItemRenderer;
            resourceList.visible = false;
            VResourceList.visible = true;
            var _local_1:int;
            var _local_2:HBox = this.addNewHorizontalResourcesList();
            for each (_local_3 in _resourceData)
            {
                if (_local_1 >= this.MAX_HORIZONTAL_RESOURCES)
                {
                    _local_1 = 0;
                    _local_2 = this.addNewHorizontalResourcesList();
                    this.minHeight = (this.minHeight + (27 + int(VResourceList.getStyle("verticalGap"))));
                };
                _local_4 = new ResourceItemRenderer();
                _local_4.data = _local_3;
                _local_2.addChild(_local_4);
                _local_1++;
            };
        }


    }
}
