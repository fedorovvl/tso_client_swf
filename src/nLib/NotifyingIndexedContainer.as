package nLib
{
    import GO.cGO;

    public class NotifyingIndexedContainer extends IndexedContainer 
    {

        public function NotifyingIndexedContainer(_arg_1:*, _arg_2:uint)
        {
            super(_arg_1, _arg_2);
        }

        override public function setElement(_arg_1:uint, _arg_2:*):void
        {
            if (isSet(_arg_1))
            {
                global.ui.channels.RENDER.renderObjectRemoved((get(_arg_1) as cGO));
            }
            else
            {
                global.ui.channels.RENDER.renderObjectAdded((_arg_2 as cGO));
            };
            super.setElement(_arg_1, _arg_2);
        }

        override public function remove(_arg_1:uint):void
        {
            global.ui.channels.RENDER.renderObjectRemoved((get(_arg_1) as cGO));
            super.remove(_arg_1);
        }


    }
}
