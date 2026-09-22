package GUI.Components
{
    import GUI.Components.ItemRenderer.ResourceItemRenderer;
    import mx.core.UIComponentDescriptor;
    import mx.core.mx_internal;
    import mx.events.PropertyChangeEvent;

    public class BuildingUpgrade_inlineComponent1 extends ResourceItemRenderer 
    {

        private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({"type":ResourceItemRenderer});
        private var _88844982outerDocument:BuildingUpgrade;

        public function BuildingUpgrade_inlineComponent1()
        {
            super();
            mx_internal::_document = this;
            this.formatAsNumber = true;
        }

        override public function initialize():void
        {
            (mx_internal::setDocumentDescriptor(this._documentDescriptor_));
            super.initialize();
        }

        public function set outerDocument(_arg_1:BuildingUpgrade):void
        {
            var _local_2:Object = this._88844982outerDocument;
            if (_local_2 !== _arg_1)
            {
                this._88844982outerDocument = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "outerDocument", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get outerDocument():BuildingUpgrade
        {
            return (this._88844982outerDocument);
        }


    }
}
