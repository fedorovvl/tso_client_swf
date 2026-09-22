package Text
{
    import Interface.cGeneralInterface;

    public class cOnScreenHelpDisplay 
    {

        private var mGeneralInterface:cGeneralInterface;

        public function cOnScreenHelpDisplay(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
        }

        public function CreatePlayerMapInfoText_string():String
        {
            var _local_1:* = ((((("CursorEditMode: " + this.mGeneralInterface.mCurrentCursor.GetEditMode()) + " ") + "Shadows: ") + this.mGeneralInterface.mRenderBuildingShadows) + "\n");
            _local_1 = (_local_1 + "\n");
            return (_local_1 + ((((("Cursor pixelX,pixelY,grid: " + this.mGeneralInterface.mCurrentCursor.GetCursorXPixelPos()) + ",") + this.mGeneralInterface.mCurrentCursor.GetCursorYPixelPos()) + ",") + this.mGeneralInterface.mCurrentCursor.GetGridPosition()));
        }


    }
}
