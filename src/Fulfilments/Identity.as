package Fulfilments
{
    import Trigger.Triggerable;
    import Trigger.IUpdateTrigger;
    import flash.events.IEventDispatcher;
    import ServerOnly.DirtyIndicator;
    import __AS3__.vec.Vector;
    import Fulfilments.Trigger.FulfilmentTrigger;
    import flash.events.EventDispatcher;
    import Interface.cGeneralInterface;
    import Utils.Tree.ITreeNode;
    import flash.events.Event;
    import Trigger.Trigger;
    import mx.events.PropertyChangeEvent;

    public class Identity implements IIdentityTreeNode, Triggerable, IUpdateTrigger, IEventDispatcher 
    {

        public var triggersFinishedAndDeletedFlag:Boolean = false;
        private var categoryID:int;
        private var parent:IIdentityTreeNode;
        private var progress:Number;
        public var mDirtyIndicator:DirtyIndicator = new DirtyIndicator();
        private var identityDefinition:IdentityDefinition;
        private var triggers:Vector.<FulfilmentTrigger>;
        private var rank:int;
        private var _bindingEventDispatcher:EventDispatcher;
        private var playerId:int;
        protected var gi:cGeneralInterface;
        private var _1647173984isTracked:Boolean = false;
        private var finished:Boolean;
        private var visible:Boolean = true;

        public function Identity(_arg_1:IdentityDefinition, _arg_2:int, _arg_3:cGeneralInterface)
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            this.identityDefinition = _arg_1;
            this.playerId = _arg_2;
            this.gi = _arg_3;
        }

        public function addChild(_arg_1:ITreeNode):void
        {
            throw (new Error("This is a leaf! It cannot have children!"));
        }

        public function setAllTriggerFinished():void
        {
            var _local_1:FulfilmentTrigger;
            for each (_local_1 in this.triggers)
            {
                _local_1.setFinished(true);
            };
            this.localUpdateProgress(null);
        }

        public function hasSubcategories():Boolean
        {
            return (false);
        }

        public function setTriggerFinished(_arg_1:int):void
        {
            var _local_2:FulfilmentTrigger;
            for each (_local_2 in this.triggers)
            {
                if (_local_2.getTriggerId() == _arg_1)
                {
                    _local_2.setFinished(true);
                    break;
                };
            };
            this.localUpdateProgress(null);
        }

        public function updateTriggerValue(_arg_1:int, _arg_2:int):void
        {
            var _local_3:FulfilmentTrigger;
            for each (_local_3 in this.triggers)
            {
                if (_local_3.getTriggerId() == _arg_1)
                {
                    _local_3.updateValue(_arg_2);
                    break;
                };
            };
        }

        private function sendTriggerFinishedUpdateVO(_arg_1:FulfilmentTrigger):void
        {
        }

        public function disposeFinishedTriggers():void
        {
            var _local_1:FulfilmentTrigger;
            for each (_local_1 in this.triggers)
            {
                _local_1.disposeFinishedTrigger();
            };
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function getId():int
        {
            return (this.identityDefinition.getId());
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function updateProgress():void
        {
            this.localUpdateProgress(null);
        }

        public function setCategoryID(_arg_1:int):void
        {
            this.categoryID = _arg_1;
        }

        public function getCategoryID():int
        {
            return (this.identityDefinition.getCategoryID());
        }

        public function dispose():void
        {
            var _local_1:FulfilmentTrigger;
            this.identityDefinition = null;
            this.parent = null;
            this.gi = null;
            if (this.triggers != null)
            {
                for each (_local_1 in this.triggers)
                {
                    _local_1.dispose();
                };
                this.triggers = null;
            };
        }

        public function getParent():ITreeNode
        {
            return (this.parent);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function getRank():int
        {
            return (this.rank);
        }

        public function handleIdentityJustFinished():void
        {
        }

        public function isLeaf():Boolean
        {
            return (true);
        }

        public function setParent(_arg_1:ITreeNode):void
        {
            this.parent = (_arg_1 as IIdentityTreeNode);
        }

        public function setRank(_arg_1:int):void
        {
            this.rank = _arg_1;
        }

        public function setVisible(_arg_1:Boolean):void
        {
            this.visible = _arg_1;
        }

        public function getProgress():Number
        {
            return (this.progress);
        }

        public function getTriggerCount():int
        {
            return (this.triggers.length);
        }

        public function reward():void
        {
        }

        public function setTriggers(_arg_1:Vector.<FulfilmentTrigger>):void
        {
            this.triggers = _arg_1;
        }

        public function getTriggers():Vector.<FulfilmentTrigger>
        {
            return (this.triggers);
        }

        public function updateVisibility():void
        {
        }

        public function trigger(_arg_1:Trigger):void
        {
            this.localUpdateProgress(_arg_1);
        }

        public function getDefinition():IdentityDefinition
        {
            return (this.identityDefinition);
        }

        [Bindable(event="propertyChange")]
        public function get isTracked():Boolean
        {
            return (this._1647173984isTracked);
        }

        public function reset():void
        {
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function getPlayerId():int
        {
            return (this.playerId);
        }

        private function localUpdateProgress(_arg_1:Trigger):void
        {
            var _local_4:Boolean;
            var _local_5:FulfilmentTrigger;
            var _local_2:int = this.triggers.length;
            var _local_3:int;
            var _local_6:Boolean = this.finished;
            for each (_local_5 in this.triggers)
            {
                if (((!(_arg_1 == null)) && (_local_5.activeTrigger == _arg_1)))
                {
                    _local_4 = _local_5.getFinished();
                    _local_5.setFinished(true);
                    if (!_local_4)
                    {
                        this.sendTriggerFinishedUpdateVO(_local_5);
                    };
                };
                if (_local_5.getFinished())
                {
                    _local_3++;
                };
            };
            this.progress = (_local_3 / _local_2);
            this.finished = (this.progress == 1);
            if (((!(_local_6)) && (this.finished)))
            {
                if (this.playerId < 0)
                {
                    return;
                };
                this.mDirtyIndicator.strongModified();
                this.handleIdentityJustFinished();
            };
        }

        public function triggerUpdated(_arg_1:Trigger):void
        {
            var _local_2:FulfilmentTrigger;
            for each (_local_2 in this.triggers)
            {
                if (_local_2.activeTrigger == _arg_1)
                {
                    _local_2.check();
                };
            };
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function isVisible():Boolean
        {
            return (this.visible);
        }

        public function toString():String
        {
            return ("");
        }

        public function set isTracked(_arg_1:Boolean):void
        {
            var _local_2:Object = this._1647173984isTracked;
            if (_local_2 !== _arg_1)
            {
                this._1647173984isTracked = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "isTracked", _local_2, _arg_1));
            };
        }

        public function checkForUpdates():void
        {
            var _local_1:FulfilmentTrigger;
            for each (_local_1 in this.triggers)
            {
                _local_1.check();
            };
        }

        public function setFinished(_arg_1:Boolean):void
        {
            this.finished = _arg_1;
        }

        public function getFinished():Boolean
        {
            return (this.finished);
        }

        public function removeChild(_arg_1:ITreeNode):void
        {
            throw (new Error("This is a leaf! It cannot have children!"));
        }

        public function getChildren():Vector.<ITreeNode>
        {
            return (null);
        }


    }
}
