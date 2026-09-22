package GUI.Components
{
    import mx.core.Container;
    import mx.core.UIComponentDescriptor;
    import mx.core.mx_internal;

    /** Creates detached MXML content with the original Flex runtime. */
    public final class LegacyMxmlContent
    {
        public static function createChildren(container:Container):void
        {
            if (container.numChildren == 0)
            {
                var descriptors:Array = container.childDescriptors;
                var documentDescriptor:UIComponentDescriptor = container.mx_internal::_documentDescriptor;
                if ((!descriptors || descriptors.length == 0) && documentDescriptor)
                    descriptors = documentDescriptor.properties.childDescriptors;
                for each (var descriptor:UIComponentDescriptor in descriptors)
                    container.createComponentFromDescriptor(descriptor, true);
            }
            for (var index:int = 0; index < container.numChildren; index++)
            {
                var nested:Container = container.getChildAt(index) as Container;
                if (nested)
                    createChildren(nested);
            }
        }
    }
}
