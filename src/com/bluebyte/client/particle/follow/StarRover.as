package com.bluebyte.client.particle.follow
{
    import flash.display.DisplayObject;
    import org.flintparticles.twoD.renderers.DisplayObjectRenderer;
    import org.flintparticles.common.emitters.Emitter;
    import org.flintparticles.twoD.initializers.Position;
    import org.flintparticles.twoD.emitters.Emitter2D;
    import org.flintparticles.twoD.zones.RectangleZone;
    import org.flintparticles.common.counters.Steady;
    import org.flintparticles.common.initializers.ImageClass;
    import org.flintparticles.twoD.initializers.Velocity;
    import org.flintparticles.twoD.zones.PointZone;
    import flash.geom.Point;
    import org.flintparticles.common.initializers.ScaleImageInit;
    import org.flintparticles.common.initializers.Lifetime;
    import org.flintparticles.common.actions.Age;
    import org.flintparticles.common.actions.Fade;
    import org.flintparticles.twoD.actions.Move;
    import org.flintparticles.twoD.activities.FollowDisplayObject;
    import flash.events.Event;
    import mx.core.UIComponent;
    import mx.core.Container;

    public final class StarRover 
    {

        [Embed(source="../../../../../../assets/StarRover/defaultSprite_com.bluebyte.client.particle.follow.StarRover_defaultSprite.png")]
        public static const defaultSprite:Class;

        private var source:DisplayObject;
        private var renderer:DisplayObjectRenderer;
        private var emitter:Emitter;
        private var emittingPosition:Position;

        public function StarRover(_arg_1:DisplayObject, _arg_2:int=50, _arg_3:int=80, _arg_4:Number=1, _arg_5:Number=1)
        {
            super();
            this.source = _arg_1;
            this.renderer = new DisplayObjectRenderer();
            this.emitter = new Emitter2D();
            this.emittingPosition = new Position(new RectangleZone(0, 0, _arg_1.width, _arg_1.height));
            this.emitter.counter = new Steady(_arg_2);
            this.emitter.addInitializer(new ImageClass(defaultSprite));
            this.emitter.addInitializer(this.emittingPosition);
            this.emitter.addInitializer(new Velocity(new PointZone(new Point(0, _arg_3))));
            this.emitter.addInitializer(new ScaleImageInit((_arg_4 * 0.5), _arg_4));
            this.emitter.addInitializer(new Lifetime((_arg_5 * (_arg_5 * 0.5)), (_arg_5 * (_arg_5 * 1.5))));
            this.emitter.addAction(new Age());
            this.emitter.addAction(new Fade());
            this.emitter.addAction(new Move());
            this.emitter.addActivity(new FollowDisplayObject(_arg_1, this.renderer));
            this.renderer.x = _arg_1.x;
            this.renderer.y = _arg_1.y;
            this.renderer.addEmitter(this.emitter);
            this.emitter.start();
            if (_arg_1.parent == null)
            {
                _arg_1.addEventListener(Event.ADDED, this.addedHandler);
            }
            else
            {
                this.add(this.renderer);
            };
            _arg_1.addEventListener(Event.REMOVED, this.removed);
        }

        protected function addedHandler(_arg_1:Event):void
        {
            this.add(this.renderer);
            this.source.removeEventListener(Event.ADDED, this.addedHandler);
        }

        private function add(_arg_1:DisplayObjectRenderer):void
        {
            if ((this.source.parent is UIComponent))
            {
                Container(this.source.parent).rawChildren.addChild(_arg_1);
            }
            else
            {
                this.source.parent.addChild(_arg_1);
            };
        }

        protected function removed(_arg_1:Event):void
        {
            this.source.removeEventListener(Event.REMOVED, this.removed);
            this.emitter.counter.stop();
            this.emitter.addEventListener("emitterEmpty", this.destroy);
        }

        private function destroy(_arg_1:Event):void
        {
            this.emitter.removeEventListener("emitterEmpty", this.destroy);
            if (this.source.parent != null)
            {
                if ((this.source.parent is UIComponent))
                {
                    Container(this.source.parent).rawChildren.removeChild(this.renderer);
                }
                else
                {
                    this.source.parent.removeChild(this.renderer);
                };
            };
            this.renderer.removeEmitter(this.emitter);
            this.renderer = null;
            this.emitter.stop();
            this.emitter.killAllParticles();
            this.emitter = null;
            this.emittingPosition = null;
            this.source = null;
        }

        public function pause():void
        {
            this.emitter.counter.stop();
        }

        public function start():void
        {
            this.emitter.counter.resume();
        }


    }
}
