package com.bluebyte.tso.ui.battle.battlecloud
{
    import com.bluebyte.tso.ui.texturepacker.TPAnimationController;
    import com.bluebyte.tso.ui.battle.battlecloud.definition.BattleCloudElementDefinition;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class BattleCloudAnimation extends TPAnimationController implements IBattleCloudElement 
    {

        private var conditionsProvider:IConditionsProvider;
        private var debugColor:Number;
        private var definition:BattleCloudElementDefinition;
        private var debugRect:BitmapData;

        public function BattleCloudAnimation(_arg_1:BattleCloudElementDefinition, _arg_2:IConditionsProvider)
        {
            super();
            this.definition = _arg_1;
            this.conditionsProvider = _arg_2;
            animation = (_arg_1.name + ".xml");
            autoPlay = (loop = (_arg_1.loopsMin == -1));
            this.loopFinishedCallback = this.loopFinished;
            this.finishedCallback = this.finished;
            this.finished();
        }

        private function finished():void
        {
            if (this.definition.zones)
            {
                offset = this.definition.zones.getRandomPoint();
            }
            else
            {
                offset = this.definition.position;
            };
            if (this.definition.loopsMin != this.definition.loopsMax)
            {
                repeat = int(((Math.random() * this.definition.loopsMax) + this.definition.loopsMin));
            }
            else
            {
                repeat = this.definition.loopsMin;
            };
        }

        public function getElementDefinition():BattleCloudElementDefinition
        {
            return (this.definition);
        }

        public function getChance():Number
        {
            return (this.definition.chance);
        }

        private function loopFinished():void
        {
            if (((isPlaying()) && (!(this.definition.isConditionValid(this.conditionsProvider.getConditions())))))
            {
                stop();
            };
        }

        public function trigger(_arg_1:String):void
        {
            if (((_arg_1 == this.definition.trigger) && (this.definition.isConditionValid(this.conditionsProvider.getConditions()))))
            {
                play();
            };
        }

        override public function renderDebug(_arg_1:BitmapData):void
        {
            if (((this.definition.debug) && (this.debugRect)))
            {
                if (this.definition.zones)
                {
                    _arg_1.copyPixels(this.debugRect, this.debugRect.rect, this.definition.zones.bounds.topLeft, null, null, true);
                }
                else
                {
                    _arg_1.copyPixels(this.debugRect, this.debugRect.rect, offset, null, null, true);
                };
            };
        }

        override protected function measure():void
        {
            var _local_1:Point;
            var _local_2:Point;
            var _local_3:Rectangle;
            super.measure();
            if (this.definition.zones)
            {
                _local_1 = this.definition.zones.bounds.topLeft;
                _local_2 = this.definition.zones.bounds.bottomRight;
                bounds = new Rectangle(_local_1.x, _local_1.y, bounds.width, bounds.height).union(new Rectangle(_local_2.x, _local_2.y, bounds.width, bounds.height));
            }
            else
            {
                bounds = bounds.union(new Rectangle(offset.x, offset.y, bounds.width, bounds.height));
            };
            if (this.definition.debug)
            {
                _local_3 = bounds.clone();
                this.debugColor = ((Math.random() * uint.MAX_VALUE) | 0xFF000000);
                this.debugRect = new BitmapData(_local_3.width, _local_3.height, true, this.debugColor);
                _local_3.x = 1;
                _local_3.y = 1;
                _local_3.height = (_local_3.height - 2);
                _local_3.width = (_local_3.width - 2);
                this.debugRect.fillRect(_local_3, 0);
            };
        }


    }
}
