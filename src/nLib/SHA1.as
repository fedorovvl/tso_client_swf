package nLib
{
    import flash.utils.Endian;
    import flash.utils.ByteArray;

    public class SHA1 
    {

        public static const HASH_SIZE:int = 20;

        public var pad_size:int = 40;


        public function getInputSize():uint
        {
            return (64);
        }

        public function getPadSize():int
        {
            return (pad_size);
        }

        public function getHashSize():uint
        {
            return (HASH_SIZE);
        }

        public function hash(src:ByteArray):String
        {
            var savedLength:uint = src.length;
            var savedEndian:String = src.endian;
            src.endian = Endian.BIG_ENDIAN;
            var len:uint = (savedLength * 8);
            while ((src.length % 4) != 0)
            {
                src[src.length] = 0;
            };
            src.position = 0;
            var a:Array = [];
            var i:uint;
            while (i < src.length)
            {
                a.push(src.readUnsignedInt());
                i = (i + 4);
            };
            var h:Array = core(a, len);
            var out:ByteArray = new ByteArray();
            var words:uint = uint((getHashSize() / 4));
            i = 0;
            while (i < words)
            {
                out.writeUnsignedInt(h[i]);
                i++;
            };
            src.length = savedLength;
            src.endian = savedEndian;
            return (fromArray(out));
        }

        private function core(x:Array, len:uint):Array
        {
            x[(len >> 5)] = (x[(len >> 5)] | (128 << (24 - (len % 32))));
            x[((((len + 64) >> 9) << 4) + 15)] = len;
            var w:Array = [];
            var a:uint = 1732584193;
            var b:uint = 4023233417;
            var c:uint = 2562383102;
            var d:uint = 271733878;
            var e:uint = 3285377520;
            var i:uint;
            while (i < x.length)
            {
                var olda:uint = a;
                var oldb:uint = b;
                var oldc:uint = c;
                var oldd:uint = d;
                var olde:uint = e;
                var j:uint = 0;
                while (j < 80)
                {
                    if (j < 16)
                    {
                        w[j] = ((x[(i + j)]) || (0));
                    }
                    else
                    {
                        w[j] = rol((((w[(j - 3)] ^ w[(j - 8)]) ^ w[(j - 14)]) ^ w[(j - 16)]), 1);
                    };
                    var t:uint = ((((rol(a, 5) + ft(j, b, c, d)) + e) + w[j]) + kt(j));
                    e = d;
                    d = c;
                    c = rol(b, 30);
                    b = a;
                    a = t;
                    j++;
                };
                a = (a + olda);
                b = (b + oldb);
                c = (c + oldc);
                d = (d + oldd);
                e = (e + olde);
                i = (i + 16);
            };
            return ([a, b, c, d, e]);
        }

        private function rol(num:uint, cnt:uint):uint
        {
            return ((num << cnt) | (num >>> (32 - cnt)));
        }

        private function ft(t:uint, b:uint, c:uint, d:uint):uint
        {
            if (t < 20)
            {
                return ((b & c) | ((~(b)) & d));
            };
            if (t < 40)
            {
                return ((b ^ c) ^ d);
            };
            if (t < 60)
            {
                return (((b & c) | (b & d)) | (c & d));
            };
            return ((b ^ c) ^ d);
        }

        private function kt(t:uint):uint
        {
            return ((t < 20) ? 1518500249 : ((t < 40) ? 1859775393 : ((t < 60) ? 2400959708 : 3395469782)));
        }

        public function fromArray(array:ByteArray):String
        {
            var s:String = "";
            var i:uint;
            while (i < array.length)
            {
                s = (s + ("0" + array[i].toString(16)).substr(-2, 2));
                i++;
            };
            return (s);
        }

        public function toString():String
        {
            return ("sha1");
        }


    }
}
