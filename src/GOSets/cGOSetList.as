package GOSets
{
    import __AS3__.vec.Vector;
    import GO.cBlockingData;
    import __AS3__.vec.*;

    public class cGOSetList implements GORenderable 
    {

        public var mType_string:String;
        private var mCurrentRenderedItem:cGOSetListItem;
        public var mName_string:String;
        private var mController:cGOSetListController;

        public var mGOSetListItem_vector:Vector.<cGOSetListItem> = new Vector.<cGOSetListItem>();
        public var mBlocking_vector:Vector.<cBlockingData> = new Vector.<cBlockingData>();

        public function cGOSetList(_arg_1:cGOSetListController)
        {
            super();
            if (_arg_1 != null)
            {
                _arg_1.SetGOSetList(this);
            };
            this.mController = _arg_1;
        }

        public function Animate(_arg_1:Number):Boolean
        {
            return (this.mCurrentRenderedItem.mGOSet.Animate(_arg_1));
        }

        public function SetSubTypeCurrentGOSetItem(_arg_1:int):void
        {
            var _local_2:cGOSetItem;
            for each (_local_2 in this.mCurrentRenderedItem.mGOSet.mGOSetItem_vector)
            {
                _local_2.mSpriteLib.SetSubTypeAndFrame(_arg_1, 0);
            };
        }

        public function RenderFrameTransform(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:int):void
        {
            this.mCurrentRenderedItem.mGOSet.RenderFrameTransform(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        public function SetValue(_arg_1:Number):void
        {
            if (this.mController != null)
            {
                this.mController.SetValue(_arg_1);
            };
        }

        public function RenderFrame(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            this.mCurrentRenderedItem.mGOSet.RenderFrame(_arg_1, _arg_2, _arg_3);
        }

        public function SetCurrentRenderedItem(_arg_1:cGOSetListItem):void
        {
            this.mCurrentRenderedItem = _arg_1;
        }

        public function AnimateUntilFinished(_arg_1:Number):Boolean
        {
            return (this.mCurrentRenderedItem.mGOSet.AnimateUntilFinished(_arg_1));
        }

        public function randomize():void
        {
            var _local_1:cGOSetListItem;
            for each (_local_1 in this.mGOSetListItem_vector)
            {
                _local_1.mGOSet.randomize();
            };
            if (this.mCurrentRenderedItem != null)
            {
                this.mCurrentRenderedItem.mGOSet.randomize();
            };
        }

        public function Render(_arg_1:int, _arg_2:int):void
        {
            this.mCurrentRenderedItem.mGOSet.Render(_arg_1, _arg_2);
        }


    }
}
