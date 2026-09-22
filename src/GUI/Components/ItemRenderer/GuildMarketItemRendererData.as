package GUI.Components.ItemRenderer
{
    import flash.events.IEventDispatcher;
    import Communication.VO.Votes.dPlayerVoteItemVO;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;

    public class GuildMarketItemRendererData implements IEventDispatcher 
    {

        private var _1059997450showPercentageCounting:Boolean = false;
        private var _1656570595voteItem:dPlayerVoteItemVO = null;
        private var _921832806percentage:Number = -1;
        private var _748916528isActive:Boolean = true;
        private var _1421131228shopItemId:int = -1;
        private var _bindingEventDispatcher:EventDispatcher;
        private var _398301669isSelected:Boolean = false;

        public function GuildMarketItemRendererData()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function set percentage(_arg_1:Number):void
        {
            var _local_2:Object = this._921832806percentage;
            if (_local_2 !== _arg_1)
            {
                this._921832806percentage = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "percentage", _local_2, _arg_1));
            };
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function set shopItemId(_arg_1:int):void
        {
            var _local_2:Object = this._1421131228shopItemId;
            if (_local_2 !== _arg_1)
            {
                this._1421131228shopItemId = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "shopItemId", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get isActive():Boolean
        {
            return (this._748916528isActive);
        }

        public function set isSelected(_arg_1:Boolean):void
        {
            var _local_2:Object = this._398301669isSelected;
            if (_local_2 !== _arg_1)
            {
                this._398301669isSelected = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "isSelected", _local_2, _arg_1));
            };
        }

        public function set showPercentageCounting(_arg_1:Boolean):void
        {
            var _local_2:Object = this._1059997450showPercentageCounting;
            if (_local_2 !== _arg_1)
            {
                this._1059997450showPercentageCounting = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "showPercentageCounting", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get showPercentageCounting():Boolean
        {
            return (this._1059997450showPercentageCounting);
        }

        [Bindable(event="propertyChange")]
        public function get voteItem():dPlayerVoteItemVO
        {
            return (this._1656570595voteItem);
        }

        public function set isActive(_arg_1:Boolean):void
        {
            var _local_2:Object = this._748916528isActive;
            if (_local_2 !== _arg_1)
            {
                this._748916528isActive = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "isActive", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get percentage():Number
        {
            return (this._921832806percentage);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        [Bindable(event="propertyChange")]
        public function get shopItemId():int
        {
            return (this._1421131228shopItemId);
        }

        [Bindable(event="propertyChange")]
        public function get isSelected():Boolean
        {
            return (this._398301669isSelected);
        }

        public function set voteItem(_arg_1:dPlayerVoteItemVO):void
        {
            var _local_2:Object = this._1656570595voteItem;
            if (_local_2 !== _arg_1)
            {
                this._1656570595voteItem = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "voteItem", _local_2, _arg_1));
            };
        }


    }
}
