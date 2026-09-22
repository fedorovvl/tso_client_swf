package GUI.Components.ItemRenderer
{
    import flash.events.IEventDispatcher;
    import Communication.VO.ColonyVO;
    import flash.events.EventDispatcher;
    import GUI.Loca.cLocaManager;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;

    public class PvPColonySearchResultRenderData implements IEventDispatcher 
    {

        private var _1609594047enabled:Boolean = true;
        private var _1191572123selected:Boolean = false;
        private var _32434732sortIndex:int = 0;
        private var _109757585state:String = "";
        private var _628920013colonyVO:ColonyVO = null;
        private var _1304461879adventureVO:Object = null;
        private var _bindingEventDispatcher:EventDispatcher;

        public function PvPColonySearchResultRenderData(_arg_1:ColonyVO)
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            this.colonyVO = _arg_1;
            if (_arg_1.ownerPlayerId == defines.PVP_USER_ID)
            {
                _arg_1.playerName = cLocaManager.GetInstance().getLabel("Bandits");
                _arg_1.guildName = cLocaManager.GetInstance().getLabel("NewColony");
                this.state = "PvE";
                this.sortIndex = 1;
            }
            else
            {
                this.state = "PvP";
                this.sortIndex = 0;
            };
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get enabled():Boolean
        {
            return (this._1609594047enabled);
        }

        public function set enabled(_arg_1:Boolean):void
        {
            var _local_2:Object = this._1609594047enabled;
            if (_local_2 !== _arg_1)
            {
                this._1609594047enabled = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "enabled", _local_2, _arg_1));
            };
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get adventureVO():Object
        {
            return (this._1304461879adventureVO);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        [Bindable(event="propertyChange")]
        public function get state():String
        {
            return (this._109757585state);
        }

        public function set adventureVO(_arg_1:Object):void
        {
            var _local_2:Object = this._1304461879adventureVO;
            if (_local_2 !== _arg_1)
            {
                this._1304461879adventureVO = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "adventureVO", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get selected():Boolean
        {
            return (this._1191572123selected);
        }

        [Bindable(event="propertyChange")]
        public function get sortIndex():int
        {
            return (this._32434732sortIndex);
        }

        public function set colonyVO(_arg_1:ColonyVO):void
        {
            var _local_2:Object = this._628920013colonyVO;
            if (_local_2 !== _arg_1)
            {
                this._628920013colonyVO = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "colonyVO", _local_2, _arg_1));
            };
        }

        public function set state(_arg_1:String):void
        {
            var _local_2:Object = this._109757585state;
            if (_local_2 !== _arg_1)
            {
                this._109757585state = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "state", _local_2, _arg_1));
            };
        }

        public function set sortIndex(_arg_1:int):void
        {
            var _local_2:Object = this._32434732sortIndex;
            if (_local_2 !== _arg_1)
            {
                this._32434732sortIndex = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "sortIndex", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get colonyVO():ColonyVO
        {
            return (this._628920013colonyVO);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function set selected(_arg_1:Boolean):void
        {
            var _local_2:Object = this._1191572123selected;
            if (_local_2 !== _arg_1)
            {
                this._1191572123selected = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selected", _local_2, _arg_1));
            };
        }


    }
}
