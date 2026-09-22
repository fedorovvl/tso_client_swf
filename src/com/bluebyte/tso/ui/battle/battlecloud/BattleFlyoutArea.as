package com.bluebyte.tso.ui.battle.battlecloud
{
    import mx.containers.Canvas;
    import Utils.Disposable;
    import flash.utils.Dictionary;
    import com.bluebyte.tso.ui.battle.battlecloud.definition.BattlegroundDefinition;
    import mx.core.ScrollPolicy;
    import com.gskinner.motion.plugins.MotionBlurPlugin;
    import com.gskinner.motion.GTween;
    import __AS3__.vec.Vector;
    import com.bluebyte.tso.ui.battle.battlecloud.definition.BattleFlyoutDefinition;
    import com.bluebyte.tso.ui.battle.battlecloud.definition.BattleFlyoutListDefinition;
    import com.bluebyte.tso.util.RandomItemUtil;
    import com.bluebyte.tso.util.InstancePool;
    import com.bluebyte.tso.ui.assets.Assets;
    import flash.geom.Point;
    import com.gskinner.motion.easing.Linear;
    import com.gskinner.motion.easing.Sine;
    import __AS3__.vec.*;

    public class BattleFlyoutArea extends Canvas implements Disposable 
    {

        private var stopped:Boolean = false;
        public var conditionsProvider:IConditionsProvider;
        private var tweenMap:Dictionary = new Dictionary(true);
        public var definition:BattlegroundDefinition;

        public function BattleFlyoutArea()
        {
            super();
            clipContent = false;
            mouseChildren = false;
            mouseEnabled = false;
            verticalScrollPolicy = ScrollPolicy.OFF;
            horizontalScrollPolicy = ScrollPolicy.OFF;
            MotionBlurPlugin.install();
        }

        public function flyToEnemy(_arg_1:int=1):void
        {
            var _local_2:int;
            if (this.definition)
            {
                _local_2 = 0;
                while (_local_2 < _arg_1)
                {
                    this.flyTo(this.definition.enemySpawnOrigin, this.definition.enemyLandingZone.getRandomPoint(), this.getNext(this.definition.enemySourceList), true);
                    _local_2++;
                };
            };
        }

        private function moveItem(_arg_1:GTween):void
        {
            var _local_2:Number = (1 - _arg_1.target.t);
            _arg_1.target.r = ((_local_2 * 500) * _arg_1.target.initRotation);
            _arg_1.target.x = ((((_local_2 * _local_2) * _arg_1.target.origin.x) + (((2 * _local_2) * _arg_1.target.t) * _arg_1.target.midPoint.x)) + ((_arg_1.target.t * _arg_1.target.t) * _arg_1.target.target.x));
            _arg_1.target.y = ((((_local_2 * _local_2) * _arg_1.target.origin.y) + (((2 * _local_2) * _arg_1.target.t) * _arg_1.target.midPoint.y)) + ((_arg_1.target.t * _arg_1.target.t) * _arg_1.target.target.y));
        }

        private function getNext(_arg_1:Vector.<BattleFlyoutListDefinition>):BattleFlyoutDefinition
        {
            var _local_2:Vector.<BattleFlyoutDefinition>;
            var _local_3:BattleFlyoutListDefinition;
            var _local_5:BattleFlyoutDefinition;
            for each (_local_3 in _arg_1)
            {
                if (_local_3.event)
                {
                    if (global.ui.mEventManager.isEventStarted(_local_3.event))
                    {
                        _local_2 = _local_3.items;
                        break;
                    };
                }
                else
                {
                    _local_2 = _local_3.items;
                };
            };
            if (!_local_2)
            {
                return (null);
            };
            var _local_4:Vector.<BattleFlyoutDefinition> = new Vector.<BattleFlyoutDefinition>();
            for each (_local_5 in _local_2)
            {
                if (((!(this.conditionsProvider)) || (_local_5.isConditionValid(this.conditionsProvider.getConditions()))))
                {
                    _local_4.push(_local_5);
                };
            };
            return (RandomItemUtil.getNext(_local_4) as BattleFlyoutDefinition);
        }

        private function onFadeEndHandler(tween:GTween):void
        {
            var item:BattleFlyoutItem;
            try
            {
                item = (tween.target as BattleFlyoutItem);
                if (item.parent == this)
                {
                    removeChild(item);
                };
                delete this.tweenMap[item];
                InstancePool.freeInstance(BattleFlyoutItem, item);
            }
            catch(e:Error)
            {
            };
        }

        public function dispose():void
        {
            var _local_1:Object;
            var _local_2:Array;
            this.stopped = true;
            for (_local_1 in this.tweenMap)
            {
                _local_2 = (this.tweenMap[_local_1] as Array);
                (_local_2[0] as GTween).paused = true;
                (_local_2[1] as GTween).paused = true;
                delete this.tweenMap[_local_1];
            };
            removeAllChildren();
        }

        private function flyTo(_arg_1:Point, _arg_2:Point, _arg_3:BattleFlyoutDefinition, _arg_4:Boolean):void
        {
            if (((this.stopped) || (!(_arg_3))))
            {
                return;
            };
            var _local_5:Object = Assets.getInstance().getBitmap(_arg_3.name);
            var _local_6:BattleFlyoutItem = (InstancePool.newInstance(BattleFlyoutItem, {
                "source":_local_5,
                "x":_arg_1.x,
                "y":_arg_1.y,
                "shadow_enabled":this.definition.itemShadow.enabled,
                "shadow_alpha":this.definition.itemShadow.alpha,
                "shadow_blur":this.definition.itemShadow.blur,
                "shadow_distance":this.definition.itemShadow.distance,
                "shadow_strength":this.definition.itemShadow.strength
            }) as BattleFlyoutItem);
            addChild(_local_6);
            var _local_7:Number = Math.random();
            _local_6.origin = new Point(_local_6.x, _local_6.y);
            _local_6.midPoint = new Point(((_local_6.x + _arg_2.x) / 2), ((((_local_6.y + _arg_2.y) / 2) - 200) + (_local_7 * 50)));
            _local_6.target = _arg_2;
            _local_6.t = 0;
            _local_6.initRotation = ((_arg_4) ? -1 : 1);
            var _local_8:GTween = new GTween(_local_6, (0.5 + (_local_7 / 50)), {
                "t":1,
                "x":_arg_2.x,
                "y":_arg_2.y
            }, {
                "ease":Linear.easeNone,
                "onChange":this.moveItem,
                "onComplete":this.onMoveEndHandler
            }, {"MotionBlurEnabled":true});
            var _local_9:GTween = (_local_8.nextTween = new GTween(_local_6, 2, {"alpha":0}, {
                "delay":(_arg_3.lifetime - 2),
                "ease":Sine.easeOut,
                "onComplete":this.onFadeEndHandler
            }));
            this.tweenMap[_local_6] = [_local_8, _local_9];
        }

        public function flyToPlayer(_arg_1:int=1):void
        {
            var _local_2:int;
            if (this.definition)
            {
                _local_2 = 0;
                while (_local_2 < _arg_1)
                {
                    this.flyTo(this.definition.playerSpawnOrigin, this.definition.playerLandingZone.getRandomPoint(), this.getNext(this.definition.playerSourceList), false);
                    _local_2++;
                };
            };
        }

        override protected function updateDisplayList(_arg_1:Number, _arg_2:Number):void
        {
            graphics.clear();
            super.updateDisplayList(_arg_1, _arg_2);
            if (this.definition)
            {
                this.definition.enemyLandingZone.render(graphics);
                this.definition.playerLandingZone.render(graphics, 0xFF);
            };
        }

        private function onMoveEndHandler(tween:GTween):void
        {
            try
            {
                (tween.target as BattleFlyoutItem).showShadow();
            }
            catch(e:Error)
            {
            };
        }


    }
}
