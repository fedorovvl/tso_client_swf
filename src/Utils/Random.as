package Utils
{
    public class Random 
    {

        private var random1:int;
        private var random2:int;
        private var random3:int;
        private var seed:int;

        public function Random(_arg_1:int)
        {
            super();
            this.InitSeed(_arg_1);
        }

        public function InitSeed(_arg_1:int):void
        {
            this.seed = _arg_1;
            this.random1 = _arg_1;
            this.random2 = ((_arg_1 + 1000) & 0xFFFF);
            this.random3 = ((_arg_1 + 2000) & 0xFFFF);
        }

        public function GetSeed():int
        {
            return (this.seed);
        }

        public function Init(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            this.seed = _arg_1;
            this.random1 = _arg_2;
            this.random2 = _arg_3;
            this.random3 = _arg_4;
        }

        public function NextMax(_arg_1:int):int
        {
            return (((this.Next() * _arg_1) >> 16) & 0xFFFF);
        }

        public function GetRandom(_arg_1:int):int
        {
            switch (_arg_1)
            {
                case 1:
                    return (this.random1);
                case 2:
                    return (this.random2);
                case 3:
                    return (this.random3);
            };
            return (-1);
        }

        public function Next():int
        {
            this.random1 = (((this.random1 + this.random2) ^ this.random3) & 0xFFFF);
            this.random3 = ((this.random3 + this.random2) & 0xFFFF);
            this.random2 = ((this.random2 ^ this.random3) & 0xFFFF);
            this.random2 = ((((this.random2 & 0x01) * 0x8000) + (this.random2 >> 1)) & 0xFFFF);
            this.random3 = ((((this.random3 & 0x01) * 0x8000) + (this.random3 >> 1)) & 0xFFFF);
            return (this.random1);
        }


    }
}
