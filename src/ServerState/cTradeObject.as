package ServerState
{
    import __AS3__.vec.Vector;
    import Enums.TRADE_TYPE;
    import nLib.gMisc;
    import mx.utils.StringUtil;
    import Communication.VO.dResourceVO;
    import BuffSystem.cBuffDefinition;
    import Communication.VO.dBuffVO;
    import BuffSystem.cBuff;
    import __AS3__.vec.*;

    public class cTradeObject 
    {

        private static var pool_vector:Vector.<cTradeObject> = new Vector.<cTradeObject>();
        private static var pointer:int = 0;

        public var isAffordable:Boolean;
        public var coolDownTime:Number = 0;
        public var receiverID:int;
        public var senderID:int;
        public var slotValue:String;
        public var createdTime:Number = 0;
        public var deleted:Number;
        public var isTradeCancled:Boolean = false;
        public var slotType:int;
        public var remainingTime:Number = 0;
        public var senderName:String;
        public var runningTime:String;
        public var totalLots:int = 1;
        public var slotPos:int;
        public var status:int;
        public var remainingLots:int = -1;
        public var tradeID:int = -1;

        public var offer:Object = new Object();
        public var costs:Object = new Object();

        public function cTradeObject(_arg_1:String, _arg_2:int)
        {
            super();
            this.init(_arg_1, _arg_2);
        }

        public static function getTradeObject(_arg_1:String, _arg_2:int):cTradeObject
        {
            if (pointer == pool_vector.length)
            {
                pool_vector.push(new cTradeObject(null, 0));
            };
            return (pool_vector[pointer++].init(_arg_1, _arg_2));
        }

        public static function dispose():void
        {
            pointer = 0;
        }


        public function get offerNameSort():String
        {
            return (Tradeable(this.offer).getName());
        }

        public function get costsSort():int
        {
            return (Tradeable(this.costs).getAmount());
        }

        public function init(_arg_1:String, _arg_2:int):cTradeObject
        {
            if (((_arg_1 == null) || (_arg_1 == "")))
            {
                return (this);
            };
            var _local_3:Array = _arg_1.split("|");
            if (_local_3.length != 3)
            {
                return (this);
            };
            if (((_arg_2 == TRADE_TYPE.TRADE_RES_FOR_RES) || (_arg_2 == TRADE_TYPE.TRADE_RES_FOR_BUFF)))
            {
                this.offer = this.parseResourceVO(_local_3[0].split(","));
            }
            else
            {
                if (((_arg_2 == TRADE_TYPE.TRADE_BUFF_FOR_RES) || (_arg_2 == TRADE_TYPE.TRADE_BUFF_FOR_BUFF)))
                {
                    this.offer = this.parseBuffVO(_local_3[0].split(","));
                };
            };
            if (_local_3[1] == "@")
            {
                this.costs = null;
            }
            else
            {
                if (((_arg_2 == TRADE_TYPE.TRADE_RES_FOR_RES) || (_arg_2 == TRADE_TYPE.TRADE_BUFF_FOR_RES)))
                {
                    this.costs = this.parseResourceVO(_local_3[1].split(","));
                }
                else
                {
                    if (((_arg_2 == TRADE_TYPE.TRADE_RES_FOR_BUFF) || (_arg_2 == TRADE_TYPE.TRADE_BUFF_FOR_BUFF)))
                    {
                        this.costs = this.parseBuffVO(_local_3[1].split(","));
                    };
                };
            };
            if (_local_3.length > 2)
            {
                this.totalLots = gMisc.ParseInt(StringUtil.trim(_local_3[2]));
            }
            else
            {
                this.totalLots = 0;
            };
            return (this);
        }

        private function parseResourceVO(_arg_1:Array):dResourceVO
        {
            var _local_2:dResourceVO = new dResourceVO();
            _local_2.name_string = _arg_1[0];
            _local_2.amount = gMisc.ParseInt(_arg_1[1]);
            return (_local_2);
        }

        public function get offerSort():int
        {
            return (Tradeable(this.offer).getAmount());
        }

        public function get senderNameSort():String
        {
            return (this.senderName);
        }

        public function get remainingTimeSort():int
        {
            return (this.remainingTime);
        }

        private function parseBuffVO(_arg_1:Array):dBuffVO
        {
            var _local_3:cBuffDefinition;
            var _local_2:dBuffVO = new dBuffVO();
            _local_2.buffName_string = _arg_1[0];
            if (_arg_1.length > 1)
            {
                _local_2.resourceName_string = _arg_1[1];
            }
            else
            {
                _local_2.resourceName_string = "";
            };
            if (_arg_1.length > 2)
            {
                _local_2.amount = gMisc.ParseInt(_arg_1[2]);
                if (_arg_1.length > 3)
                {
                    _local_2.recurringChance = gMisc.ParseInt(_arg_1[3]);
                };
            }
            else
            {
                _local_3 = cBuff.getBuffDefinitionByName(_local_2.buffName_string);
                if (_local_3 != null)
                {
                    _local_2.amount = _local_3.GetAmount();
                }
                else
                {
                    _local_2.amount = 0;
                };
                _local_2.recurringChance = 0;
            };
            return (_local_2);
        }

        public function get costsNameSort():String
        {
            return (Tradeable(this.costs).getName());
        }


    }
}
