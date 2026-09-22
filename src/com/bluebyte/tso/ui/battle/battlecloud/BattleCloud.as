package com.bluebyte.tso.ui.battle.battlecloud
{
    import mx.containers.Canvas;
    import Utils.Disposable;
    import com.bluebyte.tso.ui.battle.battlecloud.definition.BattlegroundDefinition;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    import com.bluebyte.tso.ui.texturepacker.TPMultiAnimation;
    import flash.events.TimerEvent;
    import com.bluebyte.tso.ui.battle.battlecloud.definition.BattleCloudElementDefinition;
    import mx.core.UIComponent;
    import __AS3__.vec.*;

    public class BattleCloud extends Canvas implements IConditionsProvider, Disposable 
    {

        private var _definition:BattlegroundDefinition;

        private var elements:Vector.<IBattleCloudElement> = new Vector.<IBattleCloudElement>();
        private var conditions:Dictionary = new Dictionary();
        private var animationTicker:Timer = new Timer(1000, 0);
        private var multiAnim:TPMultiAnimation = new TPMultiAnimation();

        public function BattleCloud()
        {
            super();
            clipContent = false;
            includeInLayout = false;
            mouseChildren = false;
            mouseEnabled = false;
            percentHeight = 100;
            percentWidth = 100;
            this.animationTicker.addEventListener(TimerEvent.TIMER, this.animationTimerHandler);
        }

        private function createElement(_arg_1:BattleCloudElementDefinition):IBattleCloudElement
        {
            var _local_2:Vector.<IBattleCloudElement>;
            var _local_3:BattleCloudElementDefinition;
            if (_arg_1.isPicker)
            {
                if (_arg_1.list)
                {
                    _local_2 = new Vector.<IBattleCloudElement>();
                    for each (_local_3 in _arg_1.list)
                    {
                        _local_2.push(this.createElement(_local_3));
                    };
                };
                return (new BattleCloudPicker(_arg_1, this, _local_2));
            };
            return (this.multiAnim.addController(new BattleCloudAnimation(_arg_1, this)) as BattleCloudAnimation);
        }

        public function dispose():void
        {
            var _local_1:UIComponent;
            this.animationTicker.stop();
            for each (_local_1 in getChildren())
            {
                if ((_local_1 is Disposable))
                {
                    (_local_1 as Disposable).dispose();
                };
            };
            removeAllChildren();
        }

        public function set definition(_arg_1:BattlegroundDefinition):void
        {
            var _local_2:BattleCloudElementDefinition;
            this._definition = _arg_1;
            if (this.multiAnim)
            {
                this.multiAnim.dispose();
            };
            removeAllChildren();
            this.elements.length = 0;
            for each (_local_2 in _arg_1.battleCloud)
            {
                this.elements.push(this.createElement(_local_2));
            };
            this.multiAnim.x = 0;
            this.multiAnim.y = 0;
            addChild(this.multiAnim);
            this.animationTicker.delay = this.definition.battleCloudTick;
            this.animationTicker.start();
        }

        private function animationTimerHandler(_arg_1:TimerEvent):void
        {
            this.trigger(null);
        }

        public function setCondition(_arg_1:String, _arg_2:Boolean):void
        {
            if (_arg_2)
            {
                this.conditions[_arg_1] = true;
            }
            else
            {
                delete this.conditions[_arg_1];
            };
        }

        public function get definition():BattlegroundDefinition
        {
            return (this._definition);
        }

        public function getConditions():Dictionary
        {
            return (this.conditions);
        }

        public function trigger(_arg_1:String):void
        {
            var _local_2:IBattleCloudElement;
            for each (_local_2 in this.elements)
            {
                if (((_local_2.getElementDefinition().chance == 1) || (Math.random() <= _local_2.getElementDefinition().chance)))
                {
                    _local_2.trigger(_arg_1);
                };
            };
        }


    }
}
