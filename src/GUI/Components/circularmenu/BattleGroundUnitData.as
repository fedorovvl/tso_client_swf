package GUI.Components.circularmenu
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import com.bluebyte.tso.ui.assets.AssetCombineChain;
    import Enums.MILITARY_UNIT_ARMORTYPE;
    import com.bluebyte.tso.ui.assets.Assets;
    import MilitarySystem.cMilitaryUnitData;
    import flash.display.Bitmap;
    import Communication.VO.dSquadVO;
    import MilitarySystem.cCombatSlot;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;

    public class BattleGroundUnitData implements IEventDispatcher 
    {

        private var _1140107293toolTip:String;
        private var _978846117batchSize:int = 1;
        private var _3226745icon:Object;
        private var _1413853096amount:int = -1;
        private var _bindingEventDispatcher:EventDispatcher;

        public function BattleGroundUnitData(_arg_1:Object=null, _arg_2:int=-1, _arg_3:int=1, _arg_4:String=null)
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            this.icon = _arg_1;
            this.amount = _arg_2;
            this.batchSize = _arg_3;
            this.toolTip = _arg_4;
        }

        private static function genIcon(_arg_1:cMilitaryUnitData, _arg_2:String=null):Bitmap
        {
            var _local_3:AssetCombineChain = AssetCombineChain.create(("m:" + _arg_1.GetType())).add(MILITARY_UNIT_ARMORTYPE.getAssetName(_arg_1.GetArmorType()), 5, 35);
            if (_arg_2 != null)
            {
                _local_3.add(_arg_2, 35, 40);
            };
            return (Assets.getInstance().getCombinedBitmap(_local_3));
        }

        public static function fromSquadVO(_arg_1:dSquadVO):BattleGroundUnitData
        {
            if (((_arg_1 == null) || (_arg_1.amount == 0)))
            {
                return (new (BattleGroundUnitData)());
            };
            return (new BattleGroundUnitData(genIcon(_arg_1.GetUnitData()), _arg_1.amount, _arg_1.GetUnitData().GetCombatBatchSize(), _arg_1.name_string));
        }

        public static function fromCombatSlot(_arg_1:cCombatSlot, _arg_2:String=null):BattleGroundUnitData
        {
            if ((((_arg_1 == null) || (!(_arg_1.GetSquad()))) || (_arg_1.GetAmount() == 0)))
            {
                return (new (BattleGroundUnitData)());
            };
            return (new BattleGroundUnitData(genIcon(_arg_1.GetUnitData(), _arg_2), _arg_1.GetAmount(), 1, _arg_1.GetSquad().name_string));
        }


        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function set toolTip(_arg_1:String):void
        {
            var _local_2:Object = this._1140107293toolTip;
            if (_local_2 !== _arg_1)
            {
                this._1140107293toolTip = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "toolTip", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get amount():int
        {
            return (this._1413853096amount);
        }

        [Bindable(event="propertyChange")]
        public function get batchSize():int
        {
            return (this._978846117batchSize);
        }

        [Bindable(event="propertyChange")]
        public function get toolTip():String
        {
            return (this._1140107293toolTip);
        }

        public function set amount(_arg_1:int):void
        {
            var _local_2:Object = this._1413853096amount;
            if (_local_2 !== _arg_1)
            {
                this._1413853096amount = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "amount", _local_2, _arg_1));
            };
        }

        public function set icon(_arg_1:Object):void
        {
            var _local_2:Object = this._3226745icon;
            if (_local_2 !== _arg_1)
            {
                this._3226745icon = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "icon", _local_2, _arg_1));
            };
        }

        public function set batchSize(_arg_1:int):void
        {
            var _local_2:Object = this._978846117batchSize;
            if (_local_2 !== _arg_1)
            {
                this._978846117batchSize = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "batchSize", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get icon():Object
        {
            return (this._3226745icon);
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }


    }
}
