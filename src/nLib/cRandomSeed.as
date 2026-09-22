package nLib
{
    public class cRandomSeed 
    {

        private var m_w:int = 1;
        private var m_z:int = 1;


        public function SetSeed(_arg_1:int):void
        {
            this.m_w = _arg_1;
            this.m_z = _arg_1;
        }

        public function GetNextRandom():int
        {
            this.m_z = ((36969 * (this.m_z & 0xFFFF)) + (this.m_z >> 16));
            this.m_w = ((18000 * (this.m_w & 0xFFFF)) + (this.m_w >> 16));
            return ((this.m_z << 16) + this.m_w);
        }


    }
}
