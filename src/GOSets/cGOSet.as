package GOSets
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class cGOSet implements GORenderable 
    {

        public var mGOSetItem_vector:Vector.<cGOSetItem> = new Vector.<cGOSetItem>();
        public var mID:int;
        public var mName_string:String;


        public function Animate(_arg_1:Number):Boolean
        {
            var _local_3:cGOSetItem;
            var _local_2:Boolean = true;
            for each (_local_3 in this.mGOSetItem_vector)
            {
                _local_2 = ((_local_3.mSpriteLib.Animate(_arg_1)) && (_local_2));
            };
            return (_local_2);
        }

        public function RenderFrame(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:cGOSetItem;
            var _local_5:int;
            var _local_6:int;
            for each (_local_4 in this.mGOSetItem_vector)
            {
                _local_5 = _local_4.mSpriteLib.GetAnimFrame();
                _local_6 = _arg_3;
                if (_arg_3 == -1)
                {
                    _local_6 = _local_5;
                };
                _local_4.mSpriteLib.RenderSubTypeAndFrame((_arg_1 + _local_4.mOffsetX), (_arg_2 + _local_4.mOffsetY), _local_4.mSpriteLib.GetSubType(), _local_6);
                _local_4.mSpriteLib.SetFrame(_local_5);
            };
        }

        public function AnimateUntilFinished(_arg_1:Number):Boolean
        {
            var _local_3:cGOSetItem;
            var _local_2:Boolean = true;
            for each (_local_3 in this.mGOSetItem_vector)
            {
                if (!_local_3.mSpriteLib.Animate(_arg_1))
                {
                    _local_2 = false;
                };
            };
            return (_local_2);
        }

        public function randomize():void
        {
            var _local_1:cGOSetItem;
            for each (_local_1 in this.mGOSetItem_vector)
            {
                _local_1.mSpriteLib.SetRandomAnimFrame();
            };
        }

        public function RenderFrameTransform(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:int):void
        {
            var _local_5:cGOSetItem;
            var _local_6:int;
            var _local_7:int;
            for each (_local_5 in this.mGOSetItem_vector)
            {
                _local_6 = _local_5.mSpriteLib.GetAnimFrame();
                _local_7 = _arg_4;
                if (_arg_4 == -1)
                {
                    _local_7 = _local_6;
                };
                _local_5.mSpriteLib.RenderSubTypeAndFrameTransform((_arg_1 + _local_5.mOffsetX), (_arg_2 + _local_5.mOffsetY), _local_5.mSpriteLib.GetSubType(), _local_7, _arg_3, 1, 1, 0);
                _local_5.mSpriteLib.SetFrame(_local_6);
            };
        }

        public function Render(_arg_1:int, _arg_2:int):void
        {
            var _local_3:cGOSetItem;
            for each (_local_3 in this.mGOSetItem_vector)
            {
                _local_3.mSpriteLib.RenderPos((_arg_1 + _local_3.mOffsetX), (_arg_2 + _local_3.mOffsetY));
            };
        }


    }
}
