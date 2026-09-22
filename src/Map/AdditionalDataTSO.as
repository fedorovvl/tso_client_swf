package Map
{
    import nLib.AdditionalDataField;

    public class AdditionalDataTSO implements AdditionalDataField 
    {

        public static const Sector:AdditionalDataTSO = new AdditionalDataTSO(0xFF, 0);
        public static const Border:AdditionalDataTSO = new AdditionalDataTSO(15, 8);
        public static const BorderColour:AdditionalDataTSO = new AdditionalDataTSO(15, 12);
        public static const Blocked:AdditionalDataTSO = new AdditionalDataTSO(15, 16);
        public static const BackgroundBlocking:AdditionalDataTSO = new AdditionalDataTSO(15, 20);
        public static const Cursor:AdditionalDataTSO = new AdditionalDataTSO(15, 28);
        public static const FogFrame:AdditionalDataTSO = new AdditionalDataTSO(15, 0);
        public static const Fog:AdditionalDataTSO = new AdditionalDataTSO(0xFF, 4);
        public static const BlockingSource:AdditionalDataTSO = new AdditionalDataTSO(0xFFFFFFFF, 0);
        public static const AllFields:AdditionalDataTSO = new AdditionalDataTSO(0xFFFFFFFF, 0);

        private var mShift:uint;
        private var mMask:uint;

        public function AdditionalDataTSO(_arg_1:uint, _arg_2:uint)
        {
            super();
            this.mMask = (_arg_1 << _arg_2);
            this.mShift = _arg_2;
        }

        public function shift():uint
        {
            return (this.mShift);
        }

        public function mask():uint
        {
            return (this.mMask);
        }


    }
}
