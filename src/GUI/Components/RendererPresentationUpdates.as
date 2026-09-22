package GUI.Components
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import mx.core.UIComponent;

    /** Event subscriptions for renderer presentation; plain data objects need no watcher. */
    public final class RendererPresentationUpdates
    {
        private var owner:UIComponent;
        private var refresh:Function;
        private var sources:Array = [];
        private var active:Boolean = true;

        public function RendererPresentationUpdates(owner:UIComponent, refresh:Function)
        {
            this.owner = owner;
            this.refresh = refresh;
            owner.addEventListener("dataChange", changed, false, 0, true);
            owner.addEventListener("propertyChange", changed, false, 0, true);
            owner.addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
            owner.addEventListener(Event.REMOVED_FROM_STAGE, removed, false, 0, true);
        }

        public static function readPath(source:Object, path:String):Object
        {
            if (!path) return source;
            for each (var property:String in path.split("."))
            {
                if (source == null || !(property in source)) return null;
                source = source[property];
            }
            return source;
        }

        public function observe(requested:Array):void
        {
            var next:Array = [];
            var row:Array;
            for each (row in requested)
            {
                if (!(row[0] is IEventDispatcher) || !row[1]) continue;
                if (!contains(next, row)) next.push(row);
            }
            for each (row in sources)
            {
                if (!contains(next, row) && active)
                    IEventDispatcher(row[0]).removeEventListener(row[1], changed);
            }
            for each (row in next)
            {
                if (!contains(sources, row) && active)
                    IEventDispatcher(row[0]).addEventListener(row[1], changed, false, 0, true);
            }
            sources = next;
        }

        private function contains(rows:Array, candidate:Array):Boolean
        {
            for each (var row:Array in rows)
                if (row[0] === candidate[0] && row[1] === candidate[1]) return true;
            return false;
        }

        private function changed(event:Event):void
        {
            if (active) refresh();
        }

        private function removed(event:Event):void
        {
            active = false;
            for each (var row:Array in sources)
                IEventDispatcher(row[0]).removeEventListener(row[1], changed);
        }

        private function added(event:Event):void
        {
            if (active) return;
            active = true;
            for each (var row:Array in sources)
                IEventDispatcher(row[0]).addEventListener(row[1], changed, false, 0, true);
            refresh();
        }
    }
}
