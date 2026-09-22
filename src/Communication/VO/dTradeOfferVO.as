package Communication.VO
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.utils.IDataInput;
    import mx.events.PropertyChangeEvent;
    import flash.utils.IDataOutput;

    public class dTradeOfferVO implements IEventDispatcher 
    {

        private var _1086538152slotType:int;
        private var _bindingEventDispatcher:EventDispatcher;
        private var _3327810lots:int;
        private var _2113263754slotPos:int;
        private var _423786374costsRes:dResourceVO;
        private var _1944015055offerBuff:dBuffVO;
        private var _252937287costsBuff:dBuffVO;
        private var _768558940offerRes:dResourceVO;
        private var _1681791655receipientId:int;

        public function dTradeOfferVO()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function readExternal(_arg_1:IDataInput):void
        {
            this.receipientId = _arg_1.readInt();
            this.offerRes = (_arg_1.readObject() as dResourceVO);
            this.offerBuff = (_arg_1.readObject() as dBuffVO);
            this.costsRes = (_arg_1.readObject() as dResourceVO);
            this.costsBuff = (_arg_1.readObject() as dBuffVO);
            this.lots = _arg_1.readInt();
            this.slotType = _arg_1.readInt();
            this.slotPos = _arg_1.readInt();
        }

        [Bindable(event="propertyChange")]
        public function get lots():int
        {
            return (this._3327810lots);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function set lots(_arg_1:int):void
        {
            var _local_2:Object = this._3327810lots;
            if (_local_2 !== _arg_1)
            {
                this._3327810lots = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lots", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get slotPos():int
        {
            return (this._2113263754slotPos);
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get costsRes():dResourceVO
        {
            return (this._423786374costsRes);
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeInt(this.receipientId);
            _arg_1.writeObject(this.offerRes);
            _arg_1.writeObject(this.offerBuff);
            _arg_1.writeObject(this.costsRes);
            _arg_1.writeObject(this.costsBuff);
            _arg_1.writeInt(this.lots);
            _arg_1.writeInt(this.slotType);
            _arg_1.writeInt(this.slotPos);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function set slotPos(_arg_1:int):void
        {
            var _local_2:Object = this._2113263754slotPos;
            if (_local_2 !== _arg_1)
            {
                this._2113263754slotPos = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "slotPos", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get offerBuff():dBuffVO
        {
            return (this._1944015055offerBuff);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function set costsBuff(_arg_1:dBuffVO):void
        {
            var _local_2:Object = this._252937287costsBuff;
            if (_local_2 !== _arg_1)
            {
                this._252937287costsBuff = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "costsBuff", _local_2, _arg_1));
            };
        }

        public function set offerRes(_arg_1:dResourceVO):void
        {
            var _local_2:Object = this._768558940offerRes;
            if (_local_2 !== _arg_1)
            {
                this._768558940offerRes = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "offerRes", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get receipientId():int
        {
            return (this._1681791655receipientId);
        }

        public function set offerBuff(_arg_1:dBuffVO):void
        {
            var _local_2:Object = this._1944015055offerBuff;
            if (_local_2 !== _arg_1)
            {
                this._1944015055offerBuff = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "offerBuff", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get slotType():int
        {
            return (this._1086538152slotType);
        }

        [Bindable(event="propertyChange")]
        public function get offerRes():dResourceVO
        {
            return (this._768558940offerRes);
        }

        public function set slotType(_arg_1:int):void
        {
            var _local_2:Object = this._1086538152slotType;
            if (_local_2 !== _arg_1)
            {
                this._1086538152slotType = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "slotType", _local_2, _arg_1));
            };
        }

        public function set receipientId(_arg_1:int):void
        {
            var _local_2:Object = this._1681791655receipientId;
            if (_local_2 !== _arg_1)
            {
                this._1681791655receipientId = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "receipientId", _local_2, _arg_1));
            };
        }

        public function toString():String
        {
            return (((((((((((((("<dTradeOfferVO receipientId='" + this.receipientId) + "' offerRes='") + this.offerRes) + "' offerBuff='") + this.offerBuff) + "' costsRes='") + this.costsRes) + "' costsBuff='") + this.costsBuff) + "' lots='") + this.lots) + "' slotType='") + this.slotType) + "' />");
        }

        public function set costsRes(_arg_1:dResourceVO):void
        {
            var _local_2:Object = this._423786374costsRes;
            if (_local_2 !== _arg_1)
            {
                this._423786374costsRes = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "costsRes", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get costsBuff():dBuffVO
        {
            return (this._252937287costsBuff);
        }


    }
}
